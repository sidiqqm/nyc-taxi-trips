{{ config(materialized='view') }}

SELECT
    f.trip_id,

    f.pickup_datetime,
    f.dropoff_datetime,
    f.pickup_date,
    f.dropoff_date,

    f.pickup_year_month,
    f.pickup_year,
    f.pickup_month,
    f.pickup_day,
    f.pickup_hour,
    f.pickup_day_name,
    f.is_weekend,
    f.pickup_time_period,

    pl.borough AS pickup_borough,
    pl.zone_name AS pickup_zone,
    pl.service_zone AS pickup_service_zone,
    pl.full_location_name AS pickup_full_location_name,

    dl.borough AS dropoff_borough,
    dl.zone_name AS dropoff_zone,
    dl.service_zone AS dropoff_service_zone,
    dl.full_location_name AS dropoff_full_location_name,

    p.payment_type_name,
    p.payment_category,

    r.rate_code_name,
    r.rate_category,
    r.is_airport_related,

    f.passenger_count,
    f.trip_distance,
    f.trip_duration_minutes,
    f.trip_distance_bucket,
    f.trip_duration_bucket,

    f.fare_amount,
    f.extra,
    f.mta_tax,
    f.tip_amount,
    f.tolls_amount,
    f.improvement_surcharge,
    f.total_amount,
    f.congestion_surcharge,
    f.airport_fee,

    f.fare_per_mile,
    f.tip_rate,

    f.has_tip,
    f.is_credit_card_payment,
    f.is_cash_payment,

    f.source_month,
    f.is_source_month_mismatch

FROM {{ ref('fact_yellow_taxi_trips') }} AS f

LEFT JOIN {{ ref('dim_location') }} AS pl
    ON f.pickup_location_id = pl.location_id

LEFT JOIN {{ ref('dim_location') }} AS dl
    ON f.dropoff_location_id = dl.location_id

LEFT JOIN {{ ref('dim_payment_type') }} AS p
    ON f.payment_type_id = p.payment_type_id

LEFT JOIN {{ ref('dim_rate_code') }} AS r
    ON f.rate_code_id = r.rate_code_id