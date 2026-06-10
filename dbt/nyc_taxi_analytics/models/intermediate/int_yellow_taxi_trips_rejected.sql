{{ config(materialized='table') }}

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_year_month,
    passenger_count_raw,
    passenger_count,
    trip_distance,
    rate_code_id_raw,
    rate_code_id,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    tip_amount,
    total_amount,

    ARRAY_TO_STRING(
        ARRAY(
            SELECT reason
            FROM UNNEST([
                IF(is_null_pickup_datetime, 'null_pickup_datetime', NULL),
                IF(is_null_dropoff_datetime, 'null_dropoff_datetime', NULL),
                IF(is_pickup_date_outside_2023, 'pickup_date_outside_2023', NULL),
                IF(is_invalid_trip_datetime, 'invalid_trip_datetime', NULL),
                IF(is_null_passenger_count, 'null_passenger_count', NULL),
                IF(is_non_integer_passenger_count, 'non_integer_passenger_count', NULL),
                IF(is_invalid_passenger_count, 'invalid_passenger_count', NULL),
                IF(is_invalid_trip_distance, 'invalid_trip_distance', NULL),
                IF(is_invalid_trip_duration, 'invalid_trip_duration', NULL),
                IF(is_invalid_fare_amount, 'invalid_fare_amount', NULL),
                IF(is_invalid_total_amount, 'invalid_total_amount', NULL),
                IF(is_invalid_tip_amount, 'invalid_tip_amount', NULL),
                IF(is_invalid_payment_type, 'invalid_payment_type', NULL),
                IF(is_invalid_rate_code, 'invalid_rate_code', NULL),
                IF(is_null_pickup_location_id, 'null_pickup_location_id', NULL),
                IF(is_null_dropoff_location_id, 'null_dropoff_location_id', NULL)
            ]) AS reason
            WHERE reason IS NOT NULL
        ),
        ', '
    ) AS rejection_reasons

FROM {{ ref('int_yellow_taxi_trips_cleaning_base') }}
WHERE is_null_pickup_datetime = TRUE
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
   OR is_invalid_rate_code = TRUE
   OR is_null_pickup_location_id = TRUE
   OR is_null_dropoff_location_id = TRUE