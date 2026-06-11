{{ config(materialized='view') }}

WITH hourly_metrics AS (
    SELECT
        pickup_hour,
        pickup_time_period,

        COUNT(trip_id) AS total_trips,
        ROUND(SUM(total_amount), 2) AS total_revenue,

        ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }}
    GROUP BY
        pickup_hour,
        pickup_time_period
),

ranked_hour AS (
    SELECT
        pickup_hour,
        pickup_time_period,

        total_trips,
        total_revenue,

        avg_revenue_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,

        RANK() OVER (
            ORDER BY total_trips DESC
        ) AS demand_rank,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM hourly_metrics
)

SELECT
    pickup_hour,
    pickup_time_period,

    total_trips,
    total_revenue,

    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,

    demand_rank,
    revenue_rank

FROM ranked_hour