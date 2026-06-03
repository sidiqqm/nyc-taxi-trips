WITH duplicate_check AS(
    SELECT
        VendorID,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        PULocationID,
        DOLocationID,
        passenger_count,
        trip_distance,
        payment_type,
        tip_amount,
        total_amount,
        COUNT(*) AS duplicate_count
    FROM nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union
    GROUP BY 
        VendorID,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        PULocationID,
        DOLocationID,
        passenger_count,
        trip_distance,
        payment_type,
        tip_amount,
        total_amount
    HAVING COUNT(*) > 1
)

SELECT
  COUNT(*) AS duplicate_groups,
  SUM(duplicate_count) AS total_duplicate_like_rows
FROM duplicate_check;