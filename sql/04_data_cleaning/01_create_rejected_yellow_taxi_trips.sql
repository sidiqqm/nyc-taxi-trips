/*

1. Cleaned table  → data valid untuk analisis
2. Rejected table → data invalid untuk audit dan dokumentasi

*/

CREATE OR REPLACE TABLE `nyc-taxi-analytics-1.nyc_taxi_staging.rejected_yellow_taxi_trips`
PARTITION BY pickup_date
CLUSTER BY source_month, payment_type
AS

WITH rejected_base AS (
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
        is_null_dropoff_location_id,

        FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
        WHERE
            s_null_pickup_datetime = TRUE
            OR is_null_dropoff_datetime = TRUE
            OR is_pickup_date_outside_2023 = TRUE
            OR is_invalid_trip_datetime = TRUE
            OR is_null_passenger_count = TRUE
            OR is_non_integer_passenger_count = TRUE
            OR is_invalid_passenger_count = TRUE
            OR is_invalid_trip_distance = TRUE
            OR is_invalid_trip_duration = TRUE
            OR is_invalid_fare_amount = TRUE
            OR is_invalid_total_amount = TRUE
            OR is_invalid_tip_amount = TRUE
            OR is_invalid_payment_type = TRUE
            OR is_null_pickup_location_id = TRUE
            OR is_null_dropoff_location_id = TRUE
),

with_rejection_reasons AS (
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
        is_null_dropoff_location_id,

        ARRAY_TO_STRING(
            ARRAY(
                SELECT reason
                FROM UNNEST([
                    IF(is_null_pickup_datetime, "is_null_pickup_datetime", NULL),
                    IF(is_null_dropoff_datetime, "is_null_dropoff_datetime", NULL),
                    IF(is_pickup_date_outside_2023, "is_pickup_date_outside_2023", NULL),
                    IF(is_invalid_trip_datetime, "is_invalid_trip_datetime", NULL),
                    IF(is_null_passenger_count, "is_null_passenger_count", NULL),
                    IF(is_non_integer_passenger_count, "is_non_integer_passenger_count", NULL),
                    IF(is_invalid_passenger_count, "is_invalid_passenger_count", NULL),
                    IF(is_invalid_trip_distance, "is_invalid_trip_distance", NULL),
                    IF(is_invalid_trip_distance, "is_invalid_trip_distance", NULL),
                    IF(is_invalid_trip_duration, "is_invalid_trip_duration", NULL),
                    IF(is_invalid_fare_amount, "is_invalid_fare_amount", NULL),
                    IF(is_invalid_total_amount, "is_invalid_total_amount", NULL),
                    IF(is_invalid_tip_amount, "is_invalid_tip_amount", NULL),
                    IF(is_invalid_payment_type, "is_invalid_payment_type", NULL),
                    IF(is_null_pickup_location_id, "is_null_pickup_location_id", NULL),
                    IF(is_null_dropoff_location_id, "is_null_dropoff_location_id", NULL)
                ]) AS reason
                WHERE reason IS NOT NULL
            ),
            ', '
        ) AS rejection_reasons
        
    FROM rejected_base
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
    is_null_dropoff_location_id,
    rejection_reasons
FROM with_rejection_reasons