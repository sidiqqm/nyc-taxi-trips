WITH route_metrics AS (
    SELECT
        pu.borough AS pickup_borough,
        pu.zone_name AS pickup_zone,

        do.borough AS dropoff_borough,
        do.zone_name AS dropoff_zone,

        CONCAT(
            pu.zone_name,
            ' → ',
            do.zone_name
        ) AS route_name,

        COUNT(f.trip_id) AS total_trips,

        ROUND(SUM(f.total_amount), 2) AS total_revenue,
        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    LEFT JOIN {{ ref('dim_location') }} AS pu
        ON f.pickup_location_id = pu.location_id

    LEFT JOIN {{ ref('dim_location') }} AS do
        ON f.dropoff_location_id = do.location_id

    GROUP BY
        pu.borough,
        pu.zone_name,
        do.borough,
        do.zone_name,
        route_name
),

ranked_routes AS (
    SELECT
        pickup_borough,
        pickup_zone,
        dropoff_borough,
        dropoff_zone,
        route_name,

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

    FROM route_metrics
)

SELECT
    pickup_borough,
    pickup_zone,
    dropoff_borough,
    dropoff_zone,
    route_name,

    total_trips,
    total_revenue,
    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,

    demand_rank,
    revenue_rank

FROM ranked_routes
ORDER BY total_trips DESC
LIMIT 50