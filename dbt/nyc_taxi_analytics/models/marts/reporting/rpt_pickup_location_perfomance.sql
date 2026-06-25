{{ config(materialized='view') }}

WITH pickup_metrics AS (
    SELECT
        l.location_id AS pickup_location_id,
        l.borough AS pickup_borough,
        l.zone_name AS pickup_zone,
        l.service_zone AS pickup_service_zone,
        l.full_location_name AS pickup_full_location_name,

        COUNT(f.trip_id) AS total_trips,
        COUNT(DISTINCT f.pickup_date) AS active_pickup_days,

        ROUND(
            SAFE_DIVIDE(
                COUNT(f.trip_id),
                COUNT(DISTINCT f.pickup_date)
            ),
            2
        ) AS avg_trips_per_active_day,

        ROUND(SUM(f.total_amount), 2) AS total_revenue,
        ROUND(SUM(f.fare_amount), 2) AS total_fare,
        ROUND(SUM(f.tip_amount), 2) AS total_tip,

        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes,

        ROUND(
            SAFE_DIVIDE(
                SUM(f.tip_amount),
                SUM(f.fare_amount)
            ) * 100,
            2
        ) AS tip_rate_percentage

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    INNER JOIN {{ ref('dim_location') }} l
        ON f.pickup_location_id = l.location_id

    GROUP BY
        l.location_id,
        l.borough,
        l.zone_name,
        l.service_zone,
        l.full_location_name
),

ranked_pickup_locations AS (
    SELECT
        pickup_location_id,
        pickup_borough,
        pickup_zone,
        pickup_service_zone,
        pickup_full_location_name,

        total_trips,
        active_pickup_days,
        avg_trips_per_active_day,

        total_revenue,
        total_fare,
        total_tip,

        avg_revenue_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,
        tip_rate_percentage,

        DENSE_RANK() OVER (
            ORDER BY total_trips DESC
        ) AS demand_rank,

        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        ROUND(
            SAFE_DIVIDE(
                total_trips,
                SUM(total_trips) OVER ()
            ) * 100,
            2
        ) AS trip_share_percentage,

        ROUND(
            SAFE_DIVIDE(
                total_revenue,
                SUM(total_revenue) OVER ()
            ) * 100,
            2
        ) AS revenue_share_percentage

    FROM pickup_metrics
)

SELECT
    pickup_location_id,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,
    pickup_full_location_name,

    total_trips,
    active_pickup_days,
    avg_trips_per_active_day,

    total_revenue,
    total_fare,
    total_tip,

    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,
    tip_rate_percentage,

    demand_rank,
    revenue_rank,
    trip_share_percentage,
    revenue_share_percentage

FROM ranked_pickup_locations