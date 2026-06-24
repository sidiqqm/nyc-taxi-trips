{{ config(materialized='view') }}

WITH hours AS (
    SELECT
        hour_value AS pickup_hour,

        CASE
            WHEN hour_value BETWEEN 0 AND 5 THEN 'Late night'
            WHEN hour_value BETWEEN 6 AND 10 THEN 'Morning'
            WHEN hour_value BETWEEN 11 AND 15 THEN 'Midday'
            WHEN hour_value BETWEEN 16 AND 20 THEN 'Evening'
            WHEN hour_value BETWEEN 21 AND 23 THEN 'Night'
            ELSE 'Unknown'
        END AS pickup_time_period

    FROM UNNEST(GENERATE_ARRAY(0, 23)) AS hour_value
),

hourly_metrics AS (
    SELECT
        h.pickup_hour,
        h.pickup_time_period,

        COUNT(f.trip_id) AS total_trips,
        COUNT(DISTINCT f.pickup_date) AS active_days,

        ROUND(
            SAFE_DIVIDE(
                COUNT(f.trip_id),
                COUNT(DISTINCT f.pickup_date)
            ),
            2
        ) AS avg_trips_per_active_day,

        ROUND(COALESCE(SUM(f.total_amount), 0), 2) AS total_revenue,
        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,

        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM hours h

    LEFT JOIN {{ ref('fact_yellow_taxi_trips') }} f
        ON h.pickup_hour = f.pickup_hour

    GROUP BY
        h.pickup_hour,
        h.pickup_time_period
),

ranked_hours AS (
    SELECT
        pickup_hour,
        pickup_time_period,

        total_trips,
        active_days,
        avg_trips_per_active_day,

        total_revenue,
        avg_revenue_per_trip,

        avg_trip_distance,
        avg_trip_duration_minutes,

        RANK() OVER (
            ORDER BY total_trips DESC
        ) AS demand_rank,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        ROUND(
            SAFE_DIVIDE(total_trips, SUM(total_trips) OVER ()) * 100,
            2
        ) AS trip_share_percentage

    FROM hourly_metrics
)

SELECT
    pickup_hour,
    pickup_time_period,

    total_trips,
    active_days,
    avg_trips_per_active_day,

    total_revenue,
    avg_revenue_per_trip,

    avg_trip_distance,
    avg_trip_duration_minutes,

    demand_rank,
    revenue_rank,
    trip_share_percentage

FROM ranked_hours
ORDER BY pickup_hour