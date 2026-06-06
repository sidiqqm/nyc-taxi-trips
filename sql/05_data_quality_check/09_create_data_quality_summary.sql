CREATE OR REPLACE TABLE `nyc-taxi-analytics-1.nyc_taxi_staging.dq_yellow_taxi_trips_summary` AS

WITH cleaned AS (
    SELECT
        trip_id,
        source_month,

        vendor_id,

        pickup_datetime,
        dropoff_datetime,
        pickup_date,
        pickup_year_month,

        passenger_count,
        trip_distance,
        trip_duration_minutes,

        rate_code_id,
        rate_code_label,

        pickup_location_id,
        dropoff_location_id,

        payment_type,
        payment_type_label,

        fare_amount,
        tip_amount,
        total_amount,
        fare_per_mile,
        tip_rate,
        is_weekend,
        is_source_month_mismatch

    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
),

zone_lookup AS (
    SELECT
        LocationID AS location_id
    FROM `nyc-taxi-analytics-1.nyc_taxi_raw.taxi_zone_lookup`
),

duplicate_trip_id AS (
    SELECT
        trip_id,
        COUNT(*) AS duplicate_trip_id_rows,
    FROM cleaned
    GROUP BY trip_id
    HAVING COUNT(*) > 1
),

duplicate_bussiness_key AS (
    SELECT
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        pickup_location_id,
        dropoff_location_id,
        passenger_count,
        CAST(ROUND(trip_distance, 4) AS STRING) AS trip_distance_key,
        CAST(ROUND(fare_amount, 2) AS STRING) AS fare_amount_key,
        CAST(ROUND(total_amount, 2) AS STRING) AS total_amount_key,
        COUNT(*) AS duplicate_count
    FROM cleaned
    GROUP BY
        vendor_id
        pickup_datetime,
        dropoff_datetime,
        pickup_location_id,
        dropoff_location_id,
        passenger_count,
        trip_distance_key,
        fare_amount_key,
        total_amount_key
    HAVING COUNT(*) > 1
)

location_check AS (
    SELECT
        COUNTIF(pu.location_id IS NULL) AS invalid_pickup_location_id,
        COUNTIF(do.location_id IS NULL) AS invalid_dropoff_location_id
    FROM cleaned c
    LEFT JOIN zone_lookup pu
        ON c.pickup_location_id = pu.location_id
    LEFT JOIN zone_lookup do
        ON c.pickup_location_id = do.location_id
)

dq_checks AS (
    SELECT
        'not_null_trip_id' AS check_name,
        COUNTIF(trip_id IS NULL) AS failed_rows,
        'trip_id must not be null' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'unique_trip_id' AS check_name,
        COUNT(*) AS failed_rows,
        'trip_id must be unique' AS check_description
    FROM duplicate_trip_id

    UNION ALL

    SELECT
        'pickup_date_in_2023' AS check_name,
        COUNTIF(pickup_date < '2023-01-01' OR pickup_date > '2023-12-31') AS failed_rows,
        'pickup_date must be within 2023' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_datetime_order' AS check_name,
        COUNTIF(dropoff_datetime <= pickup_datetime) AS failed_rows,
        'dropoff_datetime must be greater than pickup_datetime' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_passenger_count' AS check_name,
        COUNTIF(passenger_count < 1 OR passenger_count > 6 OR passenger_count IS NULL) AS failed_rows,
        'passenger_count must be between 1 and 6' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_trip_distance' AS check_name,
        COUNTIF(trip_distance <= 0 OR trip_distance IS NULL) AS failed_rows,
        'trip_distance must be greater than 0' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_trip_duration' AS check_name,
        COUNTIF(trip_duration_minutes <= 0 OR trip_duration_minutes IS NULL) AS failed_rows,
        'trip_duration_minutes must be greater than 0' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_fare_amount' AS check_name,
        COUNTIF(fare_amount <= 0 OR fare_amount IS NULL) AS failed_rows,
        'fare_amount must be greater than 0' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_total_amount' AS check_name,
        COUNTIF(total_amount <= 0 OR total_amount IS NULL) AS failed_rows,
        'total_amount must be greater than 0' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_tip_amount' AS check_name,
        COUNTIF(tip_amount < 0 OR tip_amount IS NULL) AS failed_rows,
        'tip_amount must not be negative' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_payment_type' AS check_name,
        COUNTIF(payment_type NOT IN (0, 1, 2, 3, 4, 5) OR payment_type IS NULL) AS failed_rows,
        'payment_type must be in valid mapping 1 to 6' AS check_description
    FROM cleaned

    UNION ALL

    SELECT
        'valid_pickup_location_relationship' AS check_name,
        invalid_pickup_location_id AS failed_rows,
        'pickup_location_id must exist in taxi_zone_lookup' AS check_description
    FROM location_check

    UNION ALL

    SELECT
        'valid_dropoff_location_relationship' AS check_name,
        invalid_dropoff_location_id AS failed_rows,
        'dropoff_location_id must exist in taxi_zone_lookup' AS check_description
    FROM location_check

    UNION ALL

    SELECT
        'duplicate_business_key' AS check_name,
        COUNT(*) AS failed_rows,
        'business duplicate should not exist after deduplication' AS check_description
    FROM duplicate_business_key
    )

    SELECT
    check_name,
    check_description,
    failed_rows,

    CASE
        WHEN failed_rows = 0 THEN 'PASSED'
        ELSE 'FAILED'
    END AS status,

    CURRENT_DATETIME() AS checked_at

FROM dq_checks;