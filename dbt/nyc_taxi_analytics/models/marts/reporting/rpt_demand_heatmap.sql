{{config(materialized='view')}}

WITH calendar AS (
    SELECT
        full_date,
        day_of_week,
        day_name,
        is_weekend
    FROM {{ref('dim_date')}}
    WHERE full_date BETWEEN '2023-01-01' AND '2023-12-31'
),

hours AS (
    SELECT
        hour_value AS pickup_hour
    FROM UNNEST(GENERATE_ARRAY(0, 23)) AS hour_value
),

daily_hourly_grid AS (
    SELECT
        c.full_date,
        c.day_of_week,
        c.day_name,
        c.is_weekend,
        h.pickup_hour,
        COUNT(f.trip_id) AS total_trips,

    FROM calendar c
    CROSS JOIN hours h

    LEFT JOIN {{ref('fact_yellow_taxi_trips')}} f
        ON c.full_date = f.pickup_date
        AND h.pickup_hour = f.pickup_hour
    
    GROUP BY
        c.full_date,
        c.day_of_week,
        c.day_name,
        c.is_weekend,
        h.pickup_hour
),

heatmap_metrics AS (
    SELECT
        day_of_week,
        day_name,
        is_weekend,
        pickup_hour,

        SUM(total_trips) AS total_trips,
        ROUND(AVG(total_trips), 2) AS avg_trip_per_day
    FROM daily_hourly_grid
    GROUP BY 
        day_of_week,
        day_name,
        is_weekend,
        pickup_hour
)

SELECT
    day_of_week,
    day_name,
    is_weekend,
    pickup_hour,
    total_trips,
    avg_trip_per_day,
    RANK() OVER(
        ORDER BY avg_trip_per_day DESC
    ) AS demand_rank

FROM heatmap_metrics
ORDER BY day_of_week, pickup_hour