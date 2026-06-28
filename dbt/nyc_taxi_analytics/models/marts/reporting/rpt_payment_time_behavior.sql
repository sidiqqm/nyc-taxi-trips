{{ config(materialized='table') }}

WITH payment_time_metrics AS (
    SELECT
        f.pickup_time_period,

        CASE f.pickup_time_period
            WHEN 'Late night' THEN 1
            WHEN 'Morning' THEN 2
            WHEN 'Midday' THEN 3
            WHEN 'Evening' THEN 4
            WHEN 'Night' THEN 5
            ELSE 99
        END AS time_period_order,

        COALESCE(p.payment_type_id, f.payment_type_id)
            AS payment_type_id,

        COALESCE(
            p.payment_type_name,
            f.payment_type_label,
            'Unknown'
        ) AS payment_type_name,

        COALESCE(
            p.payment_category,
            'Unknown'
        ) AS payment_category,

        COUNT(f.trip_id) AS total_trips,

        SUM(COALESCE(f.total_amount, 0)) AS gross_trip_amount,
        SUM(COALESCE(f.fare_amount, 0)) AS core_fare_amount,
        SUM(COALESCE(f.tip_amount, 0)) AS recorded_tip_amount,

        AVG(f.total_amount) AS avg_gross_trip_amount,
        AVG(f.trip_distance) AS avg_trip_distance,
        AVG(f.trip_duration_minutes) AS avg_trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    LEFT JOIN {{ ref('dim_payment_type') }} AS p
        ON f.payment_type_id = p.payment_type_id

    GROUP BY
        f.pickup_time_period,
        time_period_order,
        payment_type_id,
        payment_type_name,
        payment_category
),

payment_time_ranked AS (
    SELECT
        pickup_time_period,
        time_period_order,

        payment_type_id,
        payment_type_name,
        payment_category,

        total_trips,
        gross_trip_amount,
        core_fare_amount,
        recorded_tip_amount,

        avg_gross_trip_amount,
        avg_trip_distance,
        avg_trip_duration_minutes,

        SAFE_DIVIDE(
            total_trips,
            SUM(total_trips) OVER (
                PARTITION BY pickup_time_period
            )
        ) * 100 AS payment_trip_share_within_time_period,

        SAFE_DIVIDE(
            gross_trip_amount,
            SUM(gross_trip_amount) OVER (
                PARTITION BY pickup_time_period
            )
        ) * 100 AS payment_revenue_share_within_time_period,

        DENSE_RANK() OVER (
            PARTITION BY pickup_time_period
            ORDER BY total_trips DESC
        ) AS payment_volume_rank_within_time_period

    FROM payment_time_metrics
)

SELECT
    pickup_time_period,
    time_period_order,

    payment_type_id,
    payment_type_name,
    payment_category,

    total_trips,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,
    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(recorded_tip_amount, 2) AS recorded_tip_amount,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(avg_trip_duration_minutes, 2) AS avg_trip_duration_minutes,

    ROUND(
        payment_trip_share_within_time_period,
        2
    ) AS payment_trip_share_within_time_period,

    ROUND(
        payment_revenue_share_within_time_period,
        2
    ) AS payment_revenue_share_within_time_period,

    payment_volume_rank_within_time_period

FROM payment_time_ranked