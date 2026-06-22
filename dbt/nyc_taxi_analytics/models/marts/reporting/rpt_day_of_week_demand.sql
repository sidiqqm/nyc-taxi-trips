{{ config(materialized='view') }}

WITH day_metrics AS (
    SELECT
        day_of_week,
        day_name,
        is_weekend,

        COUNT(*) AS total_calendar_days,
        SUM(total_trips) AS total_trips,

        ROUND(AVG(total_trips), 2) AS avg_trips_per_day,

        ROUND(SUM(total_revenue), 2) AS total_revenue,
        ROUND(AVG(total_revenue), 2) AS avg_revenue_per_day,

        ROUND(AVG(avg_trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(avg_trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM {{ ref('rpt_daily_demand') }}

    GROUP BY
        day_of_week,
        day_name,
        is_weekend
),

ranked_days AS (
    SELECT
        day_of_week,
        day_name,
        is_weekend,

        total_calendar_days,
        total_trips,
        avg_trips_per_day,

        total_revenue,
        avg_revenue_per_day,

        avg_trip_distance,
        avg_trip_duration_minutes,

        RANK() OVER (
            ORDER BY avg_trips_per_day DESC
        ) AS demand_rank,

        ROUND(
            SAFE_DIVIDE(total_trips, SUM(total_trips) OVER ()) * 100,
            2
        ) AS trip_share_percentage

    FROM day_metrics
)

SELECT
    day_of_week,
    day_name,
    is_weekend,

    total_calendar_days,
    total_trips,
    avg_trips_per_day,

    total_revenue,
    avg_revenue_per_day,

    avg_trip_distance,
    avg_trip_duration_minutes,

    demand_rank,
    trip_share_percentage

FROM ranked_days
ORDER BY day_of_week