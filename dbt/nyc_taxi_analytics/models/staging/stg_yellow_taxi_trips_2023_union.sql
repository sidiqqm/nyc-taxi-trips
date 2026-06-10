{{ config(materialized='view') }}

WITH january AS (
    SELECT
        '2023-01' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_01') }}
),

february AS (
    SELECT
        '2023-02' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_02') }}
),

march AS (
    SELECT
        '2023-03' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_03') }}
),

april AS (
    SELECT
        '2023-04' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_04') }}
),

may AS (
    SELECT
        '2023-05' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_05') }}
),

june AS (
    SELECT
        '2023-06' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_06') }}
),

july AS (
    SELECT
        '2023-07' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_07') }}
),

august AS (
    SELECT
        '2023-08' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_08') }}
),

september AS (
    SELECT
        '2023-09' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_09') }}
),

october AS (
    SELECT
        '2023-10' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_10') }}
),

november AS (
    SELECT
        '2023-11' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_11') }}
),

december AS (
    SELECT
        '2023-12' AS source_month,
        SAFE_CAST(VendorID AS INT64) AS vendor_id,
        SAFE_CAST(tpep_pickup_datetime AS DATETIME) AS pickup_datetime,
        SAFE_CAST(tpep_dropoff_datetime AS DATETIME) AS dropoff_datetime,
        SAFE_CAST(passenger_count AS FLOAT64) AS passenger_count_raw,
        SAFE_CAST(trip_distance AS FLOAT64) AS trip_distance,
        SAFE_CAST(RatecodeID AS FLOAT64) AS rate_code_id_raw,
        store_and_fwd_flag,
        SAFE_CAST(PULocationID AS INT64) AS pickup_location_id,
        SAFE_CAST(DOLocationID AS INT64) AS dropoff_location_id,
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
    FROM {{ source('nyc_taxi_raw', 'yellow_taxi_trips_2023_12') }}
)

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM january

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM february

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM march

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM april

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM may

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM june

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM july

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM august

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM september

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM october

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM november

UNION ALL

SELECT
    source_month,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count_raw,
    trip_distance,
    rate_code_id_raw,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee
FROM december