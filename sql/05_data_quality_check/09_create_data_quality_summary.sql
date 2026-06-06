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