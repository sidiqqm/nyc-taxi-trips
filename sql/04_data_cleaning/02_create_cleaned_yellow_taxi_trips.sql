CREATE OR REPLACE TABLE `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
PARTITION BY pickup_date
CLUSTER BY pickup_location_id, dropoff_location_id, payment_type
AS

WITH valid_trips AS (
  SELECT
    source_month,

    vendor_id,

    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_year_month,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_day_name,
    is_weekend,

    passenger_count,
    trip_distance,
    trip_duration_minutes,

    rate_code_id,
    rate_code_label,

    store_and_fwd_flag,

    pickup_location_id,
    dropoff_location_id,

    payment_type,
    payment_type_label,

    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,

    fare_per_mile,
    tip_rate,

    trip_distance_bucket,
    trip_duration_bucket,

    is_source_month_mismatch,

    is_null_pickup_datetime,
    is_null_dropoff_datetime,
    is_pickup_date_outside_2023,
    is_invalid_trip_datetime,
    is_null_passenger_count,
    is_non_integer_passenger_count,
    is_invalid_passenger_count,
    is_invalid_trip_distance,
    is_invalid_trip_duration,
    is_invalid_fare_amount,
    is_invalid_total_amount,
    is_invalid_tip_amount,
    is_invalid_payment_type,
    is_null_pickup_location_id,
    is_null_dropoff_location_id

  FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaning_base`
  WHERE is_null_pickup_datetime = FALSE
    AND is_null_dropoff_datetime = FALSE
    AND is_pickup_date_outside_2023 = FALSE
    AND is_invalid_trip_datetime = FALSE
    AND is_null_passenger_count = FALSE
    AND is_non_integer_passenger_count = FALSE
    AND is_invalid_passenger_count = FALSE
    AND is_invalid_trip_distance = FALSE
    AND is_invalid_trip_duration = FALSE
    AND is_invalid_fare_amount = FALSE
    AND is_invalid_total_amount = FALSE
    AND is_invalid_tip_amount = FALSE
    AND is_invalid_payment_type = FALSE
    AND is_null_pickup_location_id = FALSE
    AND is_null_dropoff_location_id = FALSE
),

with_deduplication_key AS (
  SELECT
    source_month,

    vendor_id,

    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_year_month,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_day_name,
    is_weekend,

    passenger_count,
    trip_distance,
    trip_duration_minutes,

    rate_code_id,
    rate_code_label,

    store_and_fwd_flag,

    pickup_location_id,
    dropoff_location_id,

    payment_type,
    payment_type_label,

    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,

    fare_per_mile,
    tip_rate,

    trip_distance_bucket,
    trip_duration_bucket,

    is_source_month_mismatch,

    TO_HEX(
      MD5(
        CONCAT(
          COALESCE(CAST(vendor_id AS STRING), ''), '|',
          COALESCE(CAST(pickup_datetime AS STRING), ''), '|',
          COALESCE(CAST(dropoff_datetime AS STRING), ''), '|',
          COALESCE(CAST(pickup_location_id AS STRING), ''), '|',
          COALESCE(CAST(dropoff_location_id AS STRING), ''), '|',
          COALESCE(CAST(passenger_count AS STRING), ''), '|',
          COALESCE(CAST(ROUND(trip_distance, 4) AS STRING), ''), '|',
          COALESCE(CAST(ROUND(fare_amount, 2) AS STRING), ''), '|',
          COALESCE(CAST(ROUND(total_amount, 2) AS STRING), '')
        )
      )
    ) AS deduplication_key

  FROM valid_trips
),

deduplicated AS (
  SELECT
    source_month,

    vendor_id,

    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_year_month,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_day_name,
    is_weekend,

    passenger_count,
    trip_distance,
    trip_duration_minutes,

    rate_code_id,
    rate_code_label,

    store_and_fwd_flag,

    pickup_location_id,
    dropoff_location_id,

    payment_type,
    payment_type_label,

    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,

    fare_per_mile,
    tip_rate,

    trip_distance_bucket,
    trip_duration_bucket,

    is_source_month_mismatch,

    deduplication_key,

    ROW_NUMBER() OVER (
      PARTITION BY deduplication_key
      ORDER BY
        source_month,
        pickup_datetime,
        dropoff_datetime
    ) AS duplicate_row_number

  FROM with_deduplication_key
)

SELECT
  deduplication_key AS trip_id,

  source_month,

  vendor_id,

  pickup_datetime,
  dropoff_datetime,
  pickup_date,
  pickup_year_month,
  pickup_year,
  pickup_month,
  pickup_day,
  pickup_hour,
  pickup_day_name,
  is_weekend,

  passenger_count,
  trip_distance,
  trip_duration_minutes,

  rate_code_id,
  rate_code_label,

  store_and_fwd_flag,

  pickup_location_id,
  dropoff_location_id,

  payment_type,
  payment_type_label,

  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  improvement_surcharge,
  total_amount,
  congestion_surcharge,
  airport_fee,

  fare_per_mile,
  tip_rate,

  trip_distance_bucket,
  trip_duration_bucket,

  is_source_month_mismatch,

  duplicate_row_number

FROM deduplicated
WHERE duplicate_row_number = 1;