{{ config(materialized='view') }}

WITH pickup_location_metrics AS (
    SELECT
        p.location_id AS pickup_location_id,
        p.borough AS pickup_borough,
        p.zone_name AS pickup_zone,
        p.service_zone AS pickup_service_zone,

        COUNT(f.trip_id) AS total_trips,

        ROUND(SUM(f.total_amount), 2) AS total_revenue,
        ROUND(SUM(f.tip_amount), 2) AS total_tip,

        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    LEFT JOIN {{ ref('dim_location') }} AS p
        ON f.pickup_location_id = p.location_id

    GROUP BY
        p.location_id,
        p.borough,
        p.zone_name,
        p.service_zone
),

ranked_locations AS (
    SELECT
        pickup_location_id,
        pickup_borough,
        pickup_zone,
        pickup_service_zone,

        total_trips,
        total_revenue,
        total_tip,

        avg_revenue_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,

        RANK() OVER (
            ORDER BY total_trips DESC
        ) AS trip_rank,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        ROUND(
            SAFE_DIVIDE(total_trips, SUM(total_trips) OVER ()) * 100,
            2
        ) AS trip_contribution_percentage,

        ROUND(
            SAFE_DIVIDE(total_revenue, SUM(total_revenue) OVER ()) * 100,
            2
        ) AS revenue_contribution_percentage

    FROM pickup_location_metrics
)

SELECT
    pickup_location_id,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,

    total_trips,
    total_revenue,
    total_tip,

    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,

    trip_rank,
    revenue_rank,

    trip_contribution_percentage,
    revenue_contribution_percentage

FROM ranked_locations