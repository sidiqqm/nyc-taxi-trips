SELECT
    source_month,
    MIN(tpep_pickup_datetime) AS min_pickup_datetime,
    MAX(tpep_pickup_datetime) AS max_pickup_datetime,
    MIN(tpep_dropoff_datetime) AS min_dropoff_datetime,
    MAX(tpep_dropoff_datetime) AS max_dropoff_datetime,
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
GROUP BY source_month
ORDER BY source_month


SELECT
    source_month,
    COUNT(*) AS total_outside_2023_records
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
WHERE tpep_pickup_datetime > '2023-12-31' OR tpep_pickup_datetime < '2023-01-01'
GROUP BY source_month
ORDER BY source_month