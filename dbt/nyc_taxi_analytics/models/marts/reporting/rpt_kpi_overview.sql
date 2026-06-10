{{ config(materialized='view') }}

SELECT
    COUNT(trip_id) AS total_trips,

    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(SUM(fare_amount), 2) AS total_fare,
    ROUND(SUM(tip_amount), 2) AS total_tip,
    ROUND(SUM(tolls_amount), 2) AS total_tolls,

    ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip,
    ROUND(AVG(fare_amount), 2) AS avg_fare_per_trip,
    ROUND(AVG(tip_amount), 2) AS avg_tip_per_trip,

    ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
    ROUND(AVG(trip_duration_minutes), 2) AS avg_trip_duration_minutes,

    ROUND(SAFE_DIVIDE(SUM(tip_amount), SUM(fare_amount)) * 100, 2)
        AS overall_tip_rate_percentage,

    ROUND(SAFE_DIVIDE(COUNTIF(has_tip = TRUE), COUNT(trip_id)) * 100, 2)
        AS tipped_trip_percentage,

    ROUND(SAFE_DIVIDE(COUNTIF(is_credit_card_payment = TRUE), COUNT(trip_id)) * 100, 2)
        AS credit_card_trip_percentage,

    ROUND(SAFE_DIVIDE(COUNTIF(is_cash_payment = TRUE), COUNT(trip_id)) * 100, 2)
        AS cash_trip_percentage

FROM {{ ref('fact_yellow_taxi_trips') }}