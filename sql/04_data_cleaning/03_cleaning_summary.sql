-- 1. Compare Row Counts
SELECT
    'cleaning_base' AS table_name,
    COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`

UNION ALL

SELECT
    'cleaned' AS table_name,
    COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`

UNION ALL

SELECT
    'rejected_base' AS table_name,
    COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.rejected_yellow_taxi_trips`


-- 2. Row Count Reconcilitation
WITH row_counts AS (
    SELECT
        COUNT(*) AS base_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
),

cleaned_counts AS(
    SELECT
        COUNT(*) AS cleaned_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
),

rejected_counts AS (
    SELECT
        COUNT(*) AS rejected_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.rejected_yellow_taxi_trips_2023`
)

SELECT
    b.base_rows,
    c.cleaned_rows,
    r.rejected_rows,

    b.base_rows - c.cleaned_rows - r.rejected_rows AS row_count_difference,

    ROUND(c.cleaned_rows * 100.0 / b.base_rows, 2) AS cleaned_percentage,
    ROUND(r.rejected_rows * 100.0 / b.base_rows, 2) AS rejected_percentage
    
FROM row_counts b
CROSS JOIN cleaned_counts c
CROSS JOIN rejected_counts r


-- 3. Cleaned Row Count by Pickup Month
SELECT
    pickup_year_month,
    COUNT(*) AS cleaned_rows,
    COUNT(DISTINCT pickup_date) AS active_pickup_date,
    MIN(pickup_date) AS min_pickup_date,
    MAX(pickup_date) AS max_pickup_date
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
GROUP BY pickup_year_month
ORDER BY pickup_year_month

-- 4. Cleaned Row Count by Source Month
SELECT
    source_month,
    COUNT(*) AS cleaned_rows,
    COUNTIF(is_source_month_mismatch = TRUE) AS source_month_mismatch_rows,
    ROUND(
        COUNTIF(is_source_month_mismatch = TRUE) * 100.0 / COUNT(*),
        2
    ) AS source_month_mismatch_percentage
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
GROUP BY source_month
ORDER BY source_month;

-- 5. Rejection Reason Summary
SELECT
    rejection_reasons,
    COUNT(*) AS total_rows,
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.rejected_yellow_taxi_trips`
UNNEST(SPLIT(rejection_reasons), ', ') AS rejection_reasons
GROUP BY rejection_reasons
ORDER BY rejection_reasons

-- 6. Rejected Rows by Months
SELECT
    source_month,
    COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.rejected_yellow_taxi_trips`
GROUP BY source_month
ORDER BY source_month

-- 7. Data Range Checked
SELECT
    MIN(pickup_datetime) AS min_pickup_date,
    MAX(pickup_datetime) AS max_pickup_date,
    MIN(dropoff_datetime) AS min_dropoff_date,
    MAX(dropoff_datetime) AS max_dropoff_date
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`

-- 8. Validate cleaned table
SELECT
    COUNT(*) AS total_rows,
    COUNTIF(pickup_datetime IS NULL) AS null_pickup_datetime,
    COUNTIF(dropoff_datetime IS NULL) AS null_dropoff_datetime,

    COUNTIF(pickup_date > '2023-12-31' OR pickup_date < '2023-01-01') AS pickup_date_outside_2023,

    COUNTIF(dropoff_datetime <= pickup_datetime) AS invalid_trip_datetime,

    COUNTIF(passenger_count IS NULL) AS null_passenger_count,
    COUNTIF(passenger_count < 1 OR passenger_count > 6) AS invalid_passenger_count,

    COUNTIF(trip_distance IS NULL) AS null_trip_distance,
    COUNTIF(trip_distance <= 0) AS invalid_trip_distance,

    COUNTIF(trip_duration_minutes IS NULL) AS null_trip_duration,
    COUNTIF(trip_duration_minutes <= 0) AS invalid_trip_duration,

    COUNTIF(fare_amount IS NULL) AS null_fare_amount,
    COUNTIF(fare_amount <= 0) AS invalid_fare_amount,

    COUNTIF(total_amount IS NULL) AS null_total_amount,
    COUNTIF(total_amount <= 0) AS invalid_total_amount,

    COUNTIF(tip_amount IS NULL) AS null_tip_amount,
    COUNTIF(tip_amount < 0) AS invalid_tip_amount,

    COUNTIF(payment_type IS NULL) AS null_payment_type,
    COUNTIF(payment_type NOT IN (0, 1, 2, 3, 4, 5)) AS invalid_payment_type,

    COUNTIF(pickup_location_id IS NULL) AS null_pickup_location_id,
    COUNTIF(dropoff_location_id IS NULL) AS null_dropoff_location_id
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`

-- 9. Check Duplicate trip_id
SELECT
    trip_id,
    COUNT(*) AS total_rows,
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
GROUP BY trip_id
HAVING COUNT(*) > 1

-- 10. Check duplicate row
SELECT
    duplicate_row_number,
    COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
GROUP BY duplicate_row_number
ORDER BY duplicate_row_number

-- 11. Source Month Mismatch Detail
SELECT
    source_month,
    pickup_year_month,
    COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
WHERE is_source_month_mismatch = TRUE
GROUP BY
    source_month,
    pickup_year_month
ORDER BY
    source_month,
    pickup_year_month;