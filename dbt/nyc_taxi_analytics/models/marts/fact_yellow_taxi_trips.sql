{{ config(
    materialized='table',
    partition_by={
      "field": "pickup_date",
      "data_type": "date"
    },
    cluster_by=["pickup_location_id", "dropoff_location_id", "payment_type_id"]
) }}

WITH cleaned_trips AS (
    SELECT
        trip_id,

        source_month,
        is_source_month_mismatch,

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

        passenger_count,
        trip_distance,
        trip_duration_minutes,

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

        fare_per_mile,
        tip_rate,

        trip_distance_bucket,
        trip_duration_bucket,

        duplicate_row_number

    FROM {{ ref('int_yellow_taxi_trips_cleaned') }}
),

fact_ready AS (
    SELECT
        trip_id,

        CAST(FORMAT_DATE('%Y%m%d', pickup_date) AS INT64) AS pickup_date_id,
        CAST(FORMAT_DATE('%Y%m%d', DATE(dropoff_datetime)) AS INT64) AS dropoff_date_id,

        source_month,
        is_source_month_mismatch,

        vendor_id,

        pickup_datetime,
        dropoff_datetime,
        pickup_date,
        DATE(dropoff_datetime) AS dropoff_date,

        pickup_year_month,
        pickup_year,
        pickup_month,
        pickup_day,
        pickup_hour,
        pickup_day_name,
        is_weekend,

        CASE
            WHEN pickup_hour BETWEEN 0 AND 5 THEN 'Late night'
            WHEN pickup_hour BETWEEN 6 AND 10 THEN 'Morning'
            WHEN pickup_hour BETWEEN 11 AND 15 THEN 'Midday'
            WHEN pickup_hour BETWEEN 16 AND 20 THEN 'Evening'
            WHEN pickup_hour BETWEEN 21 AND 23 THEN 'Night'
            ELSE 'Unknown'
        END AS pickup_time_period,

        passenger_count,
        trip_distance,
        trip_duration_minutes,

        rate_code_id,
        rate_code_label,

        pickup_location_id,
        dropoff_location_id,

        payment_type AS payment_type_id,
        payment_type_label AS payment_type_name,

        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,

        fare_per_mile,
        tip_rate,

        trip_distance_bucket,
        trip_duration_bucket,

        CASE
            WHEN tip_amount > 0 THEN TRUE
            ELSE FALSE
        END AS has_tip,

        CASE
            WHEN payment_type = 1 THEN TRUE
            ELSE FALSE
        END AS is_credit_card_payment,

        CASE
            WHEN payment_type = 2 THEN TRUE
            ELSE FALSE
        END AS is_cash_payment,

        duplicate_row_number

    FROM cleaned_trips
)

SELECT
    trip_id,

    pickup_date_id,
    dropoff_date_id,

    source_month,
    is_source_month_mismatch,

    vendor_id,

    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    dropoff_date,

    pickup_year_month,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_day_name,
    is_weekend,
    pickup_time_period,

    passenger_count,
    trip_distance,
    trip_duration_minutes,

    rate_code_id,
    rate_code_label,

    pickup_location_id,
    dropoff_location_id,

    payment_type_id,
    payment_type_name,

    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,

    fare_per_mile,
    tip_rate,

    trip_distance_bucket,
    trip_duration_bucket,

    has_tip,
    is_credit_card_payment,
    is_cash_payment,

    duplicate_row_number

FROM fact_ready