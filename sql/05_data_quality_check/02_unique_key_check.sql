WITH trip_id_check AS (
    SELECT
        trip_id,
        COUNT(*) AS total_rows
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
    GROUP BY trip_id
    HAVING COUNT(*) > 1
)

SELECT
    COUNT(*) AS duplicate_trip_id_grup,
    COALESCE(SUM(total_rows), 0) AS total_duplicate_row
FROM trip_id_check