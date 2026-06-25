{{ config(materialized='view') }}

WITH route_metrics AS (
    SELECT
        f.pickup_location_id,
        f.dropoff_location_id,

        pu.borough AS pickup_borough,
        pu.zone_name AS pickup_zone,
        pu.full_location_name AS pickup_full_location_name,

        do.borough AS dropoff_borough,
        do.zone_name AS dropoff_zone,
        do.full_location_name AS dropoff_full_location_name,

        CONCAT(
            pu.zone_name,
            ' → ',
            do.zone_name
        ) AS route_name,

        CASE
            WHEN f.pickup_location_id = f.dropoff_location_id
                THEN 'Same zone route'
            WHEN pu.borough = do.borough
                THEN 'Within borough route'
            ELSE 'Cross borough route'
        END AS route_type,

        COUNT(f.trip_id) AS total_trips,

        ROUND(SUM(f.total_amount), 2) AS total_revenue,
        ROUND(SUM(f.fare_amount), 2) AS total_fare,
        ROUND(SUM(f.tip_amount), 2) AS total_tip,

        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes,
        ROUND(AVG(f.fare_per_mile), 2) AS avg_fare_per_mile,

        ROUND(
            SAFE_DIVIDE(
                SUM(f.tip_amount),
                SUM(f.fare_amount)
            ) * 100,
            2
        ) AS tip_rate_percentage

    FROM {{ ref('fact_yellow_taxi_trips') }} f

    INNER JOIN {{ ref('dim_location') }} AS pu
        ON f.pickup_location_id = pu.location_id

    INNER JOIN {{ ref('dim_location') }} AS do
        ON f.dropoff_location_id = do.location_id

    GROUP BY
        f.pickup_location_id,
        f.dropoff_location_id,
        pu.borough,
        pu.zone_name,
        pu.full_location_name,
        do.borough,
        do.zone_name,
        do.full_location_name,
        route_name,
        route_type
),

ranked_routes AS (
    SELECT
        pickup_location_id,
        dropoff_location_id,

        pickup_borough,
        pickup_zone,
        pickup_full_location_name,

        dropoff_borough,
        dropoff_zone,
        dropoff_full_location_name,

        route_name,
        route_type,

        total_trips,
        total_revenue,
        total_fare,
        total_tip,

        avg_revenue_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,
        avg_fare_per_mile,
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

    FROM route_metrics
)

SELECT
    pickup_location_id,
    dropoff_location_id,

    pickup_borough,
    pickup_zone,
    pickup_full_location_name,

    dropoff_borough,
    dropoff_zone,
    dropoff_full_location_name,

    route_name,
    route_type,

    total_trips,
    total_revenue,
    total_fare,
    total_tip,

    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,
    avg_fare_per_mile,
    tip_rate_percentage,

    demand_rank,
    revenue_rank,
    trip_share_percentage,
    revenue_share_percentage

FROM ranked_routes