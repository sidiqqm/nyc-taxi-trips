WITH borough_metrics AS (
    SELECT
        pu.borough AS pickup_borough,
        do.borough AS dropoff_borough,
        
        CASE
            WHEN pu.borough = do.borough
                THEN 'Within Borough'
            ELSE 'Cross Borough'
        END borough_trip_type,

        COUNT(f.trip_id) AS total_trips,

        ROUND(SUM(total_amount), 2) AS total_revenue,
        ROUND(SUM(fare_amount), 2) AS total_fare,
        ROUND(SUM(tip_amount), 2) AS total_tip,

        ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip,
        ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(trip_duration_minutes), 2) AS avg_trip_duration_minutes
    FROM {{ref('fact_yellow_taxi_trips')}}f
    INNER JOIN {{ref('dim_location')}} pu
        ON f.pickup_location_id = pu.location_id
    INNER JOIN {{ref('dim_location')}} do
        ON f.dropoff_location_id = do.location_id
    
    GROUP BY
        pickup_borough,
        dropoff_borough,
        borough_trip_type
),

ranked_borough_flow AS (
    SELECT
        pickup_borough,
        dropoff_borough,
        borough_trip_type,
        total_trips,
        total_revenue,
        total_fare,
        total_tip,
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
                SUM(total_trips) OVER()
            ) * 100, 2
        ) AS trip_share_percentage

    FROM borough_metrics
)

SELECT
    pickup_borough,
    dropoff_borough,
    borough_trip_type,
    total_trips,
    total_revenue,
    total_fare,
    total_tip,
    avg_revenue_per_trip,
    avg_trip_distance,
    avg_trip_duration_minutes,
    demand_rank,
    revenue_rank,
    trip_share_percentage
FROM ranked_borough_flow