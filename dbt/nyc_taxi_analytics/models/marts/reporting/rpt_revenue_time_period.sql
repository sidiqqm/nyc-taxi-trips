{{ config(materialized='table') }}

WITH time_period_metrics AS (
    SELECT
        pickup_time_period,

        CASE pickup_time_period
            WHEN 'Late night' THEN 1
            WHEN 'Morning' THEN 2
            WHEN 'Midday' THEN 3
            WHEN 'Evening' THEN 4
            WHEN 'Night' THEN 5
            ELSE 99
        END AS time_period_order,

        COUNT(trip_id) AS total_trips,

        SUM(COALESCE(total_amount, 0)) AS gross_trip_amount,
        SUM(COALESCE(fare_amount, 0)) AS core_fare_amount,
        SUM(COALESCE(tip_amount, 0)) AS total_tip_amount,

        AVG(total_amount) AS avg_gross_trip_amount,
        AVG(fare_amount) AS avg_fare_amount,
        AVG(tip_amount) AS avg_tip_amount,

        AVG(trip_distance) AS avg_trip_distance,
        AVG(trip_duration_minutes) AS avg_trip_duration_minutes,

        SAFE_DIVIDE(
            SUM(COALESCE(tip_amount, 0)),
            SUM(COALESCE(fare_amount, 0))
        ) * 100 AS tip_rate_percentage

    FROM {{ ref('fact_yellow_taxi_trips') }}
    GROUP BY
        pickup_time_period,
        time_period_order
),

ranked_time_periods AS (
    SELECT
        pickup_time_period,
        time_period_order,
        total_trips,

        gross_trip_amount,
        core_fare_amount,
        total_tip_amount,

        avg_gross_trip_amount,
        avg_fare_amount,
        avg_tip_amount,

        avg_trip_distance,
        avg_trip_duration_minutes,
        tip_rate_percentage,

        DENSE_RANK() OVER (
            ORDER BY gross_trip_amount DESC
        ) AS gross_trip_amount_rank,

        DENSE_RANK() OVER (
            ORDER BY avg_gross_trip_amount DESC
        ) AS avg_trip_amount_rank,

        ROUND(
            SAFE_DIVIDE(
                gross_trip_amount,
                SUM(gross_trip_amount) OVER ()
            ) * 100,
            2
        ) AS gross_trip_amount_share_percentage

    FROM time_period_metrics
)

SELECT
    pickup_time_period,
    time_period_order,

    total_trips,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,
    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(total_tip_amount, 2) AS total_tip_amount,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_fare_amount, 2) AS avg_fare_amount,
    ROUND(avg_tip_amount, 2) AS avg_tip_amount,

    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(avg_trip_duration_minutes, 2) AS avg_trip_duration_minutes,
    ROUND(tip_rate_percentage, 2) AS tip_rate_percentage,

    gross_trip_amount_rank,
    avg_trip_amount_rank,
    gross_trip_amount_share_percentage

FROM ranked_time_periods