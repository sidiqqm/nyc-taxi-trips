CREATE OR REPLACE VIEW `nyc-taxi-analytics-1.nyc_taxi_raw.vw_yellow_taxi_trips_2023_union` AS

SELECT
  '2023-01' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_01`

UNION ALL

SELECT
  '2023-02' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_02`

UNION ALL

SELECT
  '2023-03' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_03`

UNION ALL

SELECT
  '2023-04' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_04`

UNION ALL

SELECT
  '2023-05' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_05`

UNION ALL

SELECT
  '2023-06' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_06`

UNION ALL

SELECT
  '2023-07' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_07`

UNION ALL

SELECT
  '2023-08' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_08`

UNION ALL

SELECT
  '2023-09' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_09`

UNION ALL

SELECT
  '2023-10' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_10`

UNION ALL

SELECT
  '2023-11' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_11`

UNION ALL

SELECT
  '2023-12' AS source_month,
  SAFE_CAST(VendorID AS INT64) AS VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count,
  SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
  SAFE_CAST(RatecodeID AS FLOAT64) AS RatecodeID,
  store_and_fwd_flag,
  SAFE_CAST(PULocationID AS INT64) AS PULocationID,
  SAFE_CAST(DOLocationID AS INT64) AS DOLocationID,
  SAFE_CAST(payment_type AS INT64) AS payment_type,
  SAFE_CAST(fare_amount AS FLOAT64) AS fare_amount,
  SAFE_CAST(extra AS FLOAT64) AS extra,
  SAFE_CAST(mta_tax AS FLOAT64) AS mta_tax,
  SAFE_CAST(tip_amount AS FLOAT64) AS tip_amount,
  SAFE_CAST(tolls_amount AS FLOAT64) AS tolls_amount,
  SAFE_CAST(improvement_surcharge AS FLOAT64) AS improvement_surcharge,
  SAFE_CAST(total_amount AS FLOAT64) AS total_amount,
  SAFE_CAST(congestion_surcharge AS FLOAT64) AS congestion_surcharge,
  SAFE_CAST(Airport_fee AS FLOAT64) AS airport_fee
FROM `nyc-taxi-analytics-1.nyc_taxi_raw.yellow_taxi_trips_2023_12`;