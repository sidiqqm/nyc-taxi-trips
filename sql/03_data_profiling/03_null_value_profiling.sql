SELECT
    source_month,
    COUNT(*) AS total_rows,

    COUNTIF(VendorID IS NULL) AS null_vendor_id,
    COUNTIF(tpep_pickup_datetime IS NULL) AS null_pickup_datetime,
    COUNTIF(tpep_dropoff_datetime IS NULL) AS null_dropoff_datetime,
    COUNTIF(passenger_count IS NULL) AS null_passenger_count,
    COUNTIF(trip_distance IS NULL) AS null_trip_distance,
    COUNTIF(RatecodeID IS NULL) AS null_rate_code_id,
    COUNTIF(PULocationID IS NULL) AS null_pickup_location_id,
    COUNTIF(DOLocationID IS NULL) AS null_dropoff_location_id,
    COUNTIF(payment_type IS NULL) AS null_payment_type,
    COUNTIF(fare_amount IS NULL) AS null_fare_amount,
    COUNTIF(tip_amount IS NULL) AS null_tip_amount,
    COUNTIF(total_amount IS NULL) AS null_total_amount
FROM `nyc-taxi-analytics.nyc-taxi-raw.vw-yellow-taxi-trips_2023_union`
GROUP BY source_month
ORDER BY source_month
