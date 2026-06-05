SELECT
    COUNT(*) AS total_rows,
    COUNTIF(trip_id IS NULL) AS null_trip_id,
    COUNTIF(source_month IS NULL) AS null_source_month,
    COUNTIF(vendor_id IS NULL) AS null_vendor_id,
    
    COUNTIF(pickup_date IS NULL) AS null_pickup_date,
    COUNTIF(passenger_count IS NULL) AS null_passenger_count,
    
    COUNTIF(trip_distance IS NULL) AS null_trip_distance,
    COUNTIF(trip_duration_minutes IS NULL) AS null_trip_duration_minutes,
    
    COUNTIF(rate_code_id IS NULL) AS null_rate_code_id,
    COUNTIF(pickup_location_id IS NULL) AS null_pickup_location_id,
    COUNTIF(dropoff_location_id IS NULL) AS null_dropoff_location_id,
    
    COUNTIF(payment_type IS NULL) AS null_payment_type,
    COUNTIF(payment_type_label IS NULL) AS null_payment_type_label,

    COUNTIF(fare_amount IS NULL) AS null_fare_amount,
    COUNTIF(tip_amount IS NULL) AS null_tip_amount,
    COUNTIF(total_amount IS NULL) AS null_total_amount,
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
