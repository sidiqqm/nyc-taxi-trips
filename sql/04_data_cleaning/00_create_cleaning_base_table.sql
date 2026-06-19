/*
Flow : 
1. Menyeragamkan nama kolom
2. Menyeragamkan tipe data
3. Membuat derived column awal
4. Membuat flag issue
5. Belum memfilter data valid/invalid

catatan:
1. passenger_count dan rate_code_id masih float karena ingin melihat nilai raw terlebih dahulu sebelum di standarized

*/
CREATE OR REPLACE TABLE `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
PARTITION BY pickup_date
CLUSTER BY pickup_location_id, dropoff_location_id, payment_type
AS

WITH source_data AS (
    SELECT
        source_month,

        SAFE_CAST(VendorID AS INT64) AS vendor_id,

        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,

        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,

        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,

        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,

        SAFE_CAST(payment_type AS INT64) AS payment_type,

        SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
        SAFE_CAST(extra AS FLOAT64) AS extra,
        SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
        SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
        SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
        SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
        SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
        SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
        SAFE_CAST(airport_fee AS FLOAT64) AS airport_fee

    FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
),

standardized AS (
    SELECT
        source_month,

        vendor_id,
        pickup_datetime,
        dropoff_datetime,

        DATE(pickup_datetime) AS pickup_date,
        FORMAT_DATE('%Y-%m', DATE(pickup_datetime)) AS pickup_year_month,

        EXTRACT(YEAR FROM pickup_datetime) AS pickup_year,
        EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
        EXTRACT(DAY FROM pickup_datetime) AS pickup_day,
        EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
        FORMAT_DATE('%A', DATE(pickup_datetime)) AS pickup_day_name,

        CASE
        WHEN EXTRACT(DAYOFWEEK FROM pickup_datetime) IN (1, 7)
            THEN TRUE
        ELSE FALSE
        END AS is_weekend,

        passenger_count_raw,

        CASE
        WHEN passenger_count_raw IS NOT NULL
        AND passenger_count_raw = FLOOR(passenger_count_raw)
            THEN SAFE_CAST(passenger_count_raw AS INT64)
        ELSE NULL
        END AS passenger_count,

        trip_distance,

        rate_code_id_raw,

        CASE
        WHEN rate_code_id_raw IS NOT NULL
        AND rate_code_id_raw = FLOOR(rate_code_id_raw)
            THEN SAFE_CAST(rate_code_id_raw AS INT64)
        ELSE NULL
        END AS rate_code_id,

        store_and_fwd_flag,

        pickup_location_id,
        dropoff_location_id,

        payment_type,

        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,

        DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS trip_duration_minutes,

        SAFE_DIVIDE(fare_amount, trip_distance) AS fare_per_mile,

        SAFE_DIVIDE(tip_amount, fare_amount) AS tip_rate,

        CASE
            WHEN source_month != FORMAT_DATE('%Y-%m', DATE(pickup_datetime))
                THEN TRUE
            ELSE FALSE
        END AS is_source_month_mismatch

    FROM source_data
),

with_labels AS (
    SELECT
        source_month,
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        pickup_date,
        pickup_year_month,
        pickup_year,
        pickup_month,
        pickup_day,
        pickup_hour,
        pickup_day_name,
        is_weekend,
        passenger_count_raw,
        passenger_count,
        trip_distance,
        rate_code_id_raw,
        rate_code_id,
        store_and_fwd_flag,
        pickup_location_id,
        dropoff_location_id,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,
        trip_duration_minutes,
        fare_per_mile,
        tip_rate,
        is_source_month_mismatch,

        CASE payment_type
            WHEN 0 THEN 'Flex fare'
            WHEN 1 THEN 'Credit card'
            WHEN 2 THEN 'Cash'
            WHEN 3 THEN 'No charge'
            WHEN 4 THEN 'Dispute'
            WHEN 5 THEN 'Unknown'
            ELSE 'Invalid or null'
        END AS payment_type_label,

        CASE rate_code_id
            WHEN 1 THEN 'Standard rate'
            WHEN 2 THEN 'JFK'
            WHEN 3 THEN 'Newark'
            WHEN 4 THEN 'Nassau or Westchester'
            WHEN 5 THEN 'Negotiated fare'
            WHEN 6 THEN 'Group ride'
            ELSE 'Invalid or null'
        END AS rate_code_label,

        CASE
            WHEN trip_distance > 0 AND trip_distance <= 1 THEN '0-1 mile'
            WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1-3 miles'
            WHEN trip_distance > 3 AND trip_distance <= 5 THEN '3-5 miles'
            WHEN trip_distance > 5 AND trip_distance <= 10 THEN '5-10 miles'
            WHEN trip_distance > 10 AND trip_distance <= 20 THEN '10-20 miles'
            WHEN trip_distance > 20 THEN '20+ miles'
            ELSE 'Invalid or null'
        END AS trip_distance_bucket,

        CASE
            WHEN DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 0
                AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) <= 10
                    THEN '0-10 minutes'
            WHEN DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 10
                AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) <= 20
                    THEN '10-20 minutes'
            WHEN DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 20
                AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) <= 40
                    THEN '20-40 minutes'
            WHEN DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 40
                AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) <= 60
                    THEN '40-60 minutes'
            WHEN DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 60
                THEN '60+ minutes'
            ELSE 'Invalid or null'
        END AS trip_duration_bucket

    FROM standardized
),

with_quality_flags AS (
    SELECT
        source_month,
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        pickup_date,
        pickup_year_month,
        pickup_year,
        pickup_month,
        pickup_day,
        pickup_hour,
        pickup_day_name,
        is_weekend,
        passenger_count_raw,
        passenger_count,
        trip_distance,
        rate_code_id_raw,
        rate_code_id,
        store_and_fwd_flag,
        pickup_location_id,
        dropoff_location_id,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,
        trip_duration_minutes,
        fare_per_mile,
        tip_rate,
        is_source_month_mismatch,
        payment_type_label,
        rate_code_label,
        trip_distance_bucket,
        trip_duration_bucket,

        CASE
            WHEN pickup_datetime IS NULL THEN TRUE
            ELSE FALSE
        END AS is_null_pickup_datetime,

        CASE
            WHEN dropoff_datetime IS NULL THEN TRUE
            ELSE FALSE
        END AS is_null_dropoff_datetime,

        CASE
            WHEN pickup_date < '2023-01-01'
                OR pickup_date > '2023-12-31'
                THEN TRUE
            ELSE FALSE
        END AS is_pickup_date_outside_2023,

        CASE
            WHEN dropoff_datetime <= pickup_datetime THEN TRUE
            ELSE FALSE
        END AS is_invalid_trip_datetime,

        CASE
            WHEN passenger_count_raw IS NULL THEN TRUE
            ELSE FALSE
        END AS is_null_passenger_count,

        CASE
            WHEN passenger_count_raw IS NOT NULL
            AND passenger_count_raw != FLOOR(passenger_count_raw)
                THEN TRUE
            ELSE FALSE
        END AS is_non_integer_passenger_count,

        CASE
            WHEN passenger_count IS NULL
                OR passenger_count < 1
                OR passenger_count > 6
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_passenger_count,

        CASE
            WHEN trip_distance IS NULL
                OR trip_distance <= 0
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_trip_distance,

        CASE
            WHEN trip_duration_minutes IS NULL
                OR trip_duration_minutes <= 0
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_trip_duration,

        CASE
            WHEN fare_amount IS NULL
                OR fare_amount <= 0
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_fare_amount,

        CASE
            WHEN total_amount IS NULL
                OR total_amount <= 0
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_total_amount,

        CASE
            WHEN tip_amount IS NULL
                OR tip_amount < 0
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_tip_amount,

        CASE
            WHEN payment_type IS NULL
                OR payment_type NOT IN (0, 1, 2, 3, 4, 5)
                THEN TRUE
            ELSE FALSE
        END AS is_invalid_payment_type,

        CASE
            WHEN pickup_location_id IS NULL THEN TRUE
            ELSE FALSE
        END AS is_null_pickup_location_id,

        CASE
            WHEN dropoff_location_id IS NULL THEN TRUE
            ELSE FALSE
        END AS is_null_dropoff_location_id

      FROM with_labels
)

SELECT
    source_month,

    vendor_id,

    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_year_month,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_day_name,
    is_weekend,

    passenger_count_raw,
    passenger_count,

    trip_distance,

    rate_code_id_raw,
    rate_code_id,
    rate_code_label,

    store_and_fwd_flag,

    pickup_location_id,
    dropoff_location_id,

    payment_type,
    payment_type_label,

    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,

    trip_duration_minutes,
    fare_per_mile,
    tip_rate,

    trip_distance_bucket,
    trip_duration_bucket,

    is_source_month_mismatch,

    is_null_pickup_datetime,
    is_null_dropoff_datetime,
    is_pickup_date_outside_2023,
    is_invalid_trip_datetime,

    is_null_passenger_count,
    is_non_integer_passenger_count,
    is_invalid_passenger_count,

    is_invalid_trip_distance,
    is_invalid_trip_duration,

    is_invalid_fare_amount,
    is_invalid_total_amount,
    is_invalid_tip_amount,

    is_invalid_payment_type,

    is_null_pickup_location_id,
    is_null_dropoff_location_id

FROM with_quality_flags;