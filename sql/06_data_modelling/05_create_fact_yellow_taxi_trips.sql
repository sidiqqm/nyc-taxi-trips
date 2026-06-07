CREATE OR REPLACE TABLE `nyc-taxi-analytics-1.nyc_taxi_marts.fact_yellow_taxi_trips`
PARTITION BY pickup_datetime
CLUSTER BY pickup_location_id, dropoff_location_id, payment_type_id
AS

WITH fact_ready AS (
    SELECT
        trip_id,
        CAST(FORMAT_DATE('%Y%m%d', pickup_date) AS INT64) AS pickup_date_id,
        CAST(FORMAT_DATE('%Y%m%d', DATE(dropoff_datetime)) AS INT64) AS dropoff_date_id,
        vendor_id,

        pickup_datetime,
        dropoff_datetime,
        pickup_date,
        DATE(dropoff_datetime) AS dropoff_date
        pickup_year_month,
        pickup_year,
        pickup_month,
        pickup_day,
        pickup_hour,
        pickup_day_name,
        is_weekend,

        CASE
            WHEN pickup_hour BETWEEN 0 AND 5 THEN 'Late night'
            WHEN pickup_hour BETWEEN 6 AND 10 THEN 'Morning'
            WHEN pickup_hour BETWEEN 11 AND 15 THEN 'Midday'
            WHEN pickup_hour BETWEEN 16 AND 20 THEN 'Evening'
            WHEN pickup_hour BETWEEN 21 AND 23 THEN 'Night'
            ELSE 'Unknown'
        END AS pickup_time_periode,

        passenger_count,
        trip_distance,
        trip_duration_minutes,

        rate_code_id,
        pickup_location_id,
        dropoff_location_id,
        payment_type AS payment_type_id,

        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        congestion_surcharge,
        airport_fee,

        fare_per_mile,
        tip_rate,

        trip_distance_bucket,
        trip_duration_bucket,

        CASE
            WHEN tip_amount > 0 THEN TRUE
            ELSE FALSE
        END AS has_tip,

        CASE
            WHEN payment_type = 0 THEN TRUE
            ELSE FALSE
        END AS is_credit_card_payment,

        CASE
            WHEN payment_type = 1 THEN TRUE
            ELSE FALSE
        END AS is_cash_payment,

        duplicate_row_number
    
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
)

SELECT
  -- Primary key
  trip_id,

  -- Foreign keys
  pickup_date_id,
  dropoff_date_id,
  pickup_location_id,
  dropoff_location_id,
  payment_type_id,
  rate_code_id,

  -- Vendor / degenerate dimension
  vendor_id,

  -- Datetime attributes
  pickup_datetime,
  dropoff_datetime,
  pickup_date,
  dropoff_date,
  pickup_year_month,
  pickup_year,
  pickup_month,
  pickup_day,
  pickup_hour,
  pickup_day_name,
  is_weekend,
  pickup_time_period,

  -- Trip measures
  passenger_count,
  trip_distance,
  trip_duration_minutes,

  -- Revenue measures
  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  improvement_surcharge,
  total_amount,
  congestion_surcharge,
  airport_fee,

  -- Derived metrics
  fare_per_mile,
  tip_rate,

  -- Analytical buckets
  trip_distance_bucket,
  trip_duration_bucket,

  -- Behavioral flags
  has_tip,
  is_credit_card_payment,
  is_cash_payment,

  -- Audit fields
  source_month,
  is_source_month_mismatch,
  duplicate_row_number

FROM fact_ready;