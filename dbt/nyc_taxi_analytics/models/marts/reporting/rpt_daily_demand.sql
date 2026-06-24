{{ config(materialized='view') }}

WITH calendar AS (
    SELECT
        date_id,
        full_date,
        year,
        quarter,
        month,
        month_name,
        year_month,
        day_of_week,
        day_name,
        is_weekend
    FROM {{ ref('dim_date') }}
    WHERE full_date BETWEEN '2023-01-01' AND '2023-12-31'
),

daily_metrics AS (
    SELECT
        c.date_id,
        c.full_date AS pickup_date,
        c.year,
        c.quarter,
        c.month,
        c.month_name,
        c.year_month AS pickup_year_month,
        c.day_of_week,
        c.day_name,
        c.is_weekend,

        COUNT(f.trip_id) AS total_trips,

        ROUND(COALESCE(SUM(f.total_amount), 0), 2) AS total_revenue,

        ROUND(AVG(f.trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(f.trip_duration_minutes), 2) AS avg_trip_duration_minutes,
        ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip

    FROM calendar c

    LEFT JOIN {{ ref('fact_yellow_taxi_trips') }} AS f
        ON c.full_date = f.pickup_date

    GROUP BY
        c.date_id,
        c.full_date,
        c.year,
        c.quarter,
        c.month,
        c.month_name,
        c.year_month,
        c.day_of_week,
        c.day_name,
        c.is_weekend
),

daily_with_comparison AS (
    SELECT
        date_id,
        pickup_date,
        year,
        quarter,
        month,
        month_name,
        pickup_year_month,
        day_of_week,
        day_name,
        is_weekend,

        total_trips,
        total_revenue,
        avg_trip_distance,
        avg_trip_duration_minutes,
        avg_revenue_per_trip,

        LAG(total_trips) OVER (
            ORDER BY pickup_date
        ) AS previous_day_trips,

        ROUND(
            AVG(total_trips) OVER (
                ORDER BY pickup_date
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ),
            2
        ) AS demand_7_day_moving_avg

    FROM daily_metrics
)

SELECT
    date_id,
    pickup_date,
    year,
    quarter,
    month,
    month_name,
    pickup_year_month,
    day_of_week,
    day_name,
    is_weekend,

    total_trips,
    total_revenue,
    avg_trip_distance,
    avg_trip_duration_minutes,
    avg_revenue_per_trip,

    previous_day_trips,

    ROUND(
        SAFE_DIVIDE(
            total_trips - previous_day_trips,
            previous_day_trips
        ) * 100,
        2
    ) AS daily_trip_growth_percentage,

    demand_7_day_moving_avg

FROM daily_with_comparison