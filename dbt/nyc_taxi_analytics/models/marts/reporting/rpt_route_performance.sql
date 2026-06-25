{{ config(materialized='view') }}

WITH route_metrics AS (
    SELECT
        f.pickup_location_id,
        f.dropoff_location_id,

        pu.borough AS pickup_borough,
        pu.zone_name AS pickup_zone_name,
        pu.full_location_name AS pickup_full_location_name,

        do.borough AS dropoff_borough,
        do.zone_name AS dropoff_zone_name,
        do.full_location_name AS dropoff_full_location_name,

        CONCAT(
            f.pickup_location_id,
            '->',
            f.dropoff_location_id
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
        ROUND(AVG(f.fare_amount), 2) AS avg_fare_per_trip,
        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM {{ref('fact_yellow_taxi_trips')}} f
    LEFT JOIN {{ref('dim_location')}} pu
        ON f.pickup_location_id = pu.location_id
    LEFT JOIN {{ref('dim_location')}} do
        ON f.dropoff_location_id = do.location_id
    
    GROUP BY
        pickup_location_id,
        dropoff_location_id,
        pickup_borough,
        pickup_zone_name,
        pickup_full_location_name,
        dropoff_borough,
        dropoff_zone_name,
        dropoff_full_location_name,
        route_name,
        route_type
),

ranked_routes AS (
    SELECT
        pickup_location_id,
        pickup_borough,
        pickup_zone_name,
        pickup_full_location_name,

        dropoff_location_id,
        dropoff_borough,
        dropoff_zone_name,
        dropoff_full_location_name,

        route_name,
        route_type,
        total_trips,
        total_revenue,
        total_fare,
        total_tip,

        avg_revenue_per_trip,
        avg_fare_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,

        DENSE_RANK() OVER(
            ORDER BY total_trips DESC
        ) AS demand_rank,

        DENSE_RANK()  OVER(
            ORDER BY total_revenue
        ) AS revenue_rank,

        ROUND(
            SAFE_DIVIDE(
                total_trips,
                SUM(total_trips) OVER()
            ) * 100, 2
        ) AS trip_share_percentage

        ROUND(
            SAFE_DIVIDE(
                total_revenue,
                SUM(total_revenue) OVER()
            ) * 100, 2
        ) AS revenue_share_percentage

    FROM route_metrics
)

SELECT
    pickup_location_id,
    pickup_borough,
    pickup_zone_name,
    pickup_full_location_name,

    dropoff_location_id,
    dropoff_borough,
    dropoff_zone_name,
    dropoff_full_location_name,

    route_name,
    route_type,
    total_trips,
    total_revenue,
    total_fare,
    total_tip,

    avg_revenue_per_trip,
    avg_fare_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,
    
    demand_rank,
    trip_share_percentage,
    revenue_rank,
    revenue_share_percentage
FROM route_metrics
    