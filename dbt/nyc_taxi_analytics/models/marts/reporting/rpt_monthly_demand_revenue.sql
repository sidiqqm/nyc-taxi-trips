{{ config(materialized='view') }}

WITH monthly_metrics AS (
    SELECT
        pickup_year_month,

        COUNT(trip_id) AS total_trips,
        ROUND(SUM(total_amount), 2) AS total_revenue,
        ROUND(SUM(fare_amount), 2) AS total_fare,
        ROUND(SUM(tip_amount), 2) AS total_tip,

        ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }}
    GROUP BY pickup_year_month
),

monthly_with_lag AS (
    SELECT
        pickup_year_month,

        total_trips,
        total_revenue,
        total_fare,
        total_tip,

        avg_revenue_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,

        LAG(total_trips) OVER (
            ORDER BY pickup_year_month
        ) AS previous_month_trips,

        LAG(total_revenue) OVER (
            ORDER BY pickup_year_month
        ) AS previous_month_revenue

    FROM monthly_metrics
)

SELECT
    pickup_year_month,

    total_trips,
    previous_month_trips,

    ROUND(
        SAFE_DIVIDE(total_trips - previous_month_trips, previous_month_trips) * 100,
        2
    ) AS trips_mom_growth_percentage,

    total_revenue,
    previous_month_revenue,

    ROUND(
        SAFE_DIVIDE(total_revenue - previous_month_revenue, previous_month_revenue) * 100,
        2
    ) AS revenue_mom_growth_percentage,

    total_fare,
    total_tip,

    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes

FROM monthly_with_lag