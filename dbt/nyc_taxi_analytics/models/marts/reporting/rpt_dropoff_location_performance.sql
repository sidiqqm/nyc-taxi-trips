{{config(materialized='view')}}

WITH dropoff_metrics AS (
    SELECT
        l.location_id AS dropoff_location_id,
        l.borough AS dropoff_borough,
        l.zone_name AS dropoff_zone_name,
        l.service_zone AS dropoff_service_zone,
        l.full_location_name AS dropoff_full_location_name,

        COUNT(f.trip_id) AS total_trips,
        COUNT(DISTINCT f.dropoff_date) AS active_dropoff_days,

        ROUND(
            SAFE_DIVIDE(
                COUNT(f.trip_id),
                COUNT(DISTINCT f.dropoff_date)
            ), 2
        ) AS avg_trips_per_active_day,

        ROUND(SUM(f.total_amount), 2) AS total_revenue,
        ROUND(SUM(f.fare_amount), 2) AS total_fare,
        ROUND(SUM(f.tip_amount), 2) AS total_tip,

        ROUND(
            SAFE_DIVIDE(
                SUM(tip_amount),
                SUM(total_amount)
            ) * 100, 2
        ) AS tip_share_percentage,

        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes
    FROM {{ref('dim_location')}} l
    INNER JOIN {{ref('fact_yellow_taxi_trips')}}
        ON l.location_id = f.dropoff_location_id
    GROUP BY 
        dropoff_location_id,
        dropoff_borough,
        dropoff_zone_name,
        dropoff_service_zone,
        dropoff_full_location_name
),

ranked_dropoff_locations AS (
    SELECT
        dropoff_location_id,
        dropoff_borough,
        dropoff_zone_name,
        dropoff_service_zone,
        dropoff_full_location_name,
        total_trips,
        active_dropoff_days,
        tip_share_percentage,
        avg_revenue_per_trip,
        avg_trip_distance,
        avg_trip_duration_minutes,

        DENSE_RANK() OVER(
            ORDER BY total_trips DESC
        ) AS demand_rank,

        DENSE_RANK() OVER(
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        ROUND(
            SAFE_DIVIDE(
                total_trips,
                SUM(total_trips)
            ) * 100, 2
        ) AS trip_share_percentage,

        ROUND(
            SAFE_DIVIDE(
                total_revenue,
                SUM(total_revenue)
            ) * 100, 2
        ) AS revenue_share_percentage
    FROM dropoff_metrics
)

SELECT
    dropoff_location_id,
    dropoff_borough,
    dropoff_zone_name,
    dropoff_service_zone,
    dropoff_full_location_name,
    total_trips,
    active_dropoff_days,
    tip_share_percentage,
    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,
    demand_rank,
    revenue_rank,
    trip_share_percentage,
    revenue_share_percentage
FROM ranked_dropoff_locations