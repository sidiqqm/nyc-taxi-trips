WITH base_count AS (
    SELECT
        COUNT(*) AS base_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
),

rejected_count AS (
    SELECT
        COUNT(*) AS rejected_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.rejected_yellow_taxi_trips`
),

valid_before_dedup AS (
    SELECT
        COUNT(*) AS valid_rows_before_dedup
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
    WHERE is_null_pickup_datetime = FALSE
        AND is_null_dropoff_datetime = FALSE
        AND is_pickup_date_outside_2023 = FALSE
        AND is_invalid_trip_datetime = FALSE
        AND is_null_passenger_count = FALSE
        AND is_non_integer_passenger_count = FALSE
        AND is_invalid_passenger_count = FALSE
        AND is_invalid_trip_distance = FALSE
        AND is_invalid_trip_duration = FALSE
        AND is_invalid_fare_amount = FALSE
        AND is_invalid_total_amount = FALSE
        AND is_invalid_tip_amount = FALSE
        AND is_invalid_payment_type = FALSE
        AND is_null_pickup_location_id = FALSE
        AND is_null_dropoff_location_id = FALSE
),

cleaned_count AS (
    SELECT
        COUNT(*) AS cleaned_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
)

SELECT
    b.base_rows,
    r.rejected_rows,
    bd.valid_rows_before_dedup,
    c.cleaned_rows,

    bd.valid_rows_before_dedup - c.cleaned_rows AS duplicate_remove_rows,

    b.base_rows - r.rejected_rows - bd.valid_rows_before_dedup AS reconciliation_difference
FROM base_count b
CROSS JOIN rejected_count r
CROSS JOIN valid_before_dedup bd
CROSS JOIN cleaned_count c;
