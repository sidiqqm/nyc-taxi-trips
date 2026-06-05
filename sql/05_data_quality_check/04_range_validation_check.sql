SELECT
    COUNT(*) AS total_rows,

    COUNTIF(pickup_date < '2023-01-01') AS pickup_before_2023,
    COUNTIF(pickup_date > '2023-12-31') AS pickup_after_2023,
    COUNTIF(dropoff_datetime <= pickup_datetime) AS invalid_datetime_order,

    COUNTIF(trip_distance <= 0) AS trip_distance_zero_or_negative,
    COUNTIF(trip_distance > 100) AS suspicious_trip_distance_above_100_miles,
    
    COUNTIF(trip_duration_minutes <= 0) AS duration_zero_or_negative,
    COUNTIF(trip_duration_minutes > 180) AS suspicious_duration_above_3_hours,
    
    COUNTIF(passenger_count <= 0) AS passenger_count_below_1,
    COUNTIF(passenger_count > 6) AS passenger_count_above_6,
    
    COUNTIF(fare_amount <= 0) AS fare_amount_zero_or_negative,
    COUNTIF(tip_amount < 0) AS tip_amount_negative,
    COUNTIF(total_amount <= 0) AS total_amount_zero_or_negative,

    COUNTIF(fare_per_mile <= 0) AS fare_per_mile_zero_or_negative,
    COUNTIF(fare_per_mile > 100) AS suspicious_fare_per_mile_above_100,

    COUNTIF(tip_rate < 0) AS tip_rate_negative,
    COUNTIF(tip_rate > 1) AS suspicious_tip_rate_above_100_percent
FROM nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned