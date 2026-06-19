{{ config(materialized='table') }}

WITH source_data AS (
    SELECT
        source_month,
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count_raw,
        trip_distance,
        rate_code_id_raw,
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
        airport_fee
    FROM {{ ref('stg_yellow_taxi_trips_2023_union') }}
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
            WHEN trip_duration_minutes > 0 AND trip_duration_minutes <= 10 THEN '0-10 minutes'
            WHEN trip_duration_minutes > 10 AND trip_duration_minutes <= 20 THEN '10-20 minutes'
            WHEN trip_duration_minutes > 20 AND trip_duration_minutes <= 40 THEN '20-40 minutes'
            WHEN trip_duration_minutes > 40 AND trip_duration_minutes <= 60 THEN '40-60 minutes'
            WHEN trip_duration_minutes > 60 THEN '60+ minutes'
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

        pickup_datetime IS NULL AS is_null_pickup_datetime,
        dropoff_datetime IS NULL AS is_null_dropoff_datetime,

        pickup_date < '2023-01-01'
        OR pickup_date > '2023-12-31' AS is_pickup_date_outside_2023,

        dropoff_datetime <= pickup_datetime AS is_invalid_trip_datetime,

        passenger_count_raw IS NULL AS is_null_passenger_count,

        passenger_count_raw IS NOT NULL
        AND passenger_count_raw != FLOOR(passenger_count_raw)
            AS is_non_integer_passenger_count,

        passenger_count IS NULL
        OR passenger_count < 1
        OR passenger_count > 6 AS is_invalid_passenger_count,

        trip_distance IS NULL
        OR trip_distance <= 0 AS is_invalid_trip_distance,

        trip_duration_minutes IS NULL
        OR trip_duration_minutes <= 0 AS is_invalid_trip_duration,

        fare_amount IS NULL
        OR fare_amount <= 0 AS is_invalid_fare_amount,

        total_amount IS NULL
        OR total_amount <= 0 AS is_invalid_total_amount,

        tip_amount IS NULL
        OR tip_amount < 0 AS is_invalid_tip_amount,

        payment_type IS NULL
        OR payment_type NOT IN (0, 1, 2, 3, 4, 5) AS is_invalid_payment_type,

        rate_code_id IS NULL
        OR rate_code_id NOT IN (1, 2, 3, 4, 5, 6) AS is_invalid_rate_code,

        pickup_location_id IS NULL AS is_null_pickup_location_id,
        dropoff_location_id IS NULL AS is_null_dropoff_location_id

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
    is_invalid_rate_code,
    is_null_pickup_location_id,
    is_null_dropoff_location_id
FROM with_quality_flags