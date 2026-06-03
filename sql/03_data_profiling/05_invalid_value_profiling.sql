SELECT
    source_month,
    COUNT(*) AS total_rows,

    COUNTIF(passenger_count IS NULL) AS null_passenger_count,
    COUNTIF(passenger_count <= 0) AS invalid_passenger_count_zero_or_negative,
    COUNTIF(passenger_count > 6) AS suspicious_passenger_count_above_6,
    COUNTIF(passenger_count != FLOOR(passenger_count)) AS non_integer_passenger_count,

    COUNTIF(trip_distance IS NULL) AS null_trip_distance,
    COUNTIF(trip_distance <= 0) AS invalid_trip_distance_zero_or_negative,
    COUNTIF(trip_distance  > 100) AS suspicious_trip_distance_above_100_miles,

    COUNTIF(fare_amount IS NULL) AS null_fare_amount,
    COUNTIF(fare_amount < 0) AS invalid_negative_fare_amount,
    COUNTIF(fare_amount = 0) AS suspicious_zero_fare_amount,

    COUNTIF(total_amount IS NULL) AS null_total_amount,
    COUNTIF(total_amount < 0) AS invalid_negative_total_amount,
    COUNTIF(total_amount = 0) AS suspicious_zero_total_amount,

    COUNTIF(tip_amount < 0) AS invalid_negative_tip_amount,
    COUNTIF(tpep_dropoff_datetime <= tpep_pickup_datetime) AS invalid_dropoff_before_pickup

FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
GROUP BY source_month
ORDER BY source_month


-- Trip duration profiling
WITH trip_duration AS (
    SELECT
        source_month,
        DATEDIFF(tpep_dropoff_datetime, tpep_pickup_datetime, MINUTE) AS trip_duration_minutes
    
    FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
)

SELECT
    source_month,
    COUNT(*) AS total_rows,
    MAX(trip_duration_minutes) AS max_duration_minutes,
    MIN(trip_duration_minutes) AS min_duration_minutes,
    AVG(trip_duration_minutes) AS avg_duration_minutes,
FROM trip_duration
GROUP BY source_month
ORDER BY source_month

-- check payment type
SELECT
  payment_type,
  COUNT(*) AS total_trips,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
GROUP BY payment_type
ORDER BY total_trips DESC;

-- invalid payment
SELECT
  payment_type,
  COUNT(*) AS total_rows
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union`
WHERE payment_type NOT IN (1, 2, 3, 4, 5, 6)
   OR payment_type IS NULL
GROUP BY payment_type
ORDER BY total_rows DESC;
