WITH duplicate_check AS (
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
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
    GROUP BY
        vendor_id,
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

SELECT
    COUNT(*) AS duplicate_group,
    COALESCE(SUM(duplicate_count), 0) AS duplicate_rows
FROM duplicate_check