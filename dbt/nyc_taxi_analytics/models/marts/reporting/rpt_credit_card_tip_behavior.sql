{{ config(materialized='table') }}

WITH credit_card_trips AS (
    SELECT
        f.pickup_year_month,
        f.pickup_time_period,

        CASE f.pickup_time_period
            WHEN 'Late night' THEN 1
            WHEN 'Morning' THEN 2
            WHEN 'Midday' THEN 3
            WHEN 'Evening' THEN 4
            WHEN 'Night' THEN 5
            ELSE 99
        END AS time_period_order,

        p.payment_type_name,

        f.trip_id,
        f.fare_amount,
        f.tip_amount,
        f.total_amount,
        f.trip_distance,
        f.trip_duration_minutes

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    INNER JOIN {{ ref('dim_payment_type') }} AS p
        ON f.payment_type_id = p.payment_type_id

    WHERE LOWER(p.payment_type_name) = 'credit card'
),

credit_card_tip_metrics AS (
    SELECT
        pickup_year_month,
        pickup_time_period,
        time_period_order,
        payment_type_name,

        COUNT(trip_id) AS total_credit_card_trips,
        COUNTIF(tip_amount > 0) AS tipped_credit_card_trips,

        SUM(COALESCE(fare_amount, 0)) AS core_fare_amount,
        SUM(COALESCE(tip_amount, 0)) AS recorded_tip_amount,
        SUM(COALESCE(total_amount, 0)) AS gross_trip_amount,

        AVG(tip_amount) AS avg_recorded_tip_amount,
        AVG(total_amount) AS avg_gross_trip_amount,
        AVG(trip_distance) AS avg_trip_distance,
        AVG(trip_duration_minutes) AS avg_trip_duration_minutes,

        SAFE_DIVIDE(
            COUNTIF(tip_amount > 0),
            COUNT(trip_id)
        ) * 100 AS tipped_credit_card_trip_percentage,

        SAFE_DIVIDE(
            SUM(COALESCE(tip_amount, 0)),
            SUM(COALESCE(fare_amount, 0))
        ) * 100 AS recorded_tip_rate_percentage

    FROM credit_card_trips
    GROUP BY
        pickup_year_month,
        pickup_time_period,
        time_period_order,
        payment_type_name
)

SELECT
    pickup_year_month,
    pickup_time_period,
    time_period_order,
    payment_type_name,

    total_credit_card_trips,
    tipped_credit_card_trips,

    ROUND(
        tipped_credit_card_trip_percentage,
        2
    ) AS tipped_credit_card_trip_percentage,

    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(recorded_tip_amount, 2) AS recorded_tip_amount,
    ROUND(gross_trip_amount, 2) AS gross_trip_amount,

    ROUND(
        avg_recorded_tip_amount,
        2
    ) AS avg_recorded_tip_amount,

    ROUND(
        avg_gross_trip_amount,
        2
    ) AS avg_gross_trip_amount,

    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(
        avg_trip_duration_minutes,
        2
    ) AS avg_trip_duration_minutes,

    ROUND(
        recorded_tip_rate_percentage,
        2
    ) AS recorded_tip_rate_percentage

FROM credit_card_tip_metrics