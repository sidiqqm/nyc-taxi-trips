{{ config(materialized='table') }}

WITH rate_code_metrics AS (
    SELECT
        COALESCE(f.rate_code_id, 0) AS rate_code_id,
        COALESCE(r.rate_code_name, 'Unknown') AS rate_code_name,
        COALESCE(r.rate_category, 'Unknown') AS rate_category,
        COALESCE(r.is_airport_related, FALSE) AS is_airport_related,

        COUNT(f.trip_id) AS total_trips,

        SUM(COALESCE(f.total_amount, 0)) AS gross_trip_amount,
        SUM(COALESCE(f.fare_amount, 0)) AS core_fare_amount,
        SUM(COALESCE(f.tip_amount, 0)) AS total_tip_amount,

        AVG(f.total_amount) AS avg_gross_trip_amount,
        AVG(f.trip_distance) AS avg_trip_distance,
        AVG(f.trip_duration_minutes) AS avg_trip_duration_minutes,

        SAFE_DIVIDE(
            SUM(COALESCE(f.tip_amount, 0)),
            SUM(COALESCE(f.fare_amount, 0))
        ) * 100 AS tip_rate_percentage

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    LEFT JOIN {{ ref('dim_rate_code') }} AS r
        ON f.rate_code_id = r.rate_code_id

    GROUP BY
        rate_code_id,
        rate_code_name,
        rate_category,
        is_airport_related
),

ranked_rate_codes AS (
    SELECT
        rate_code_id,
        rate_code_name,
        rate_category,
        is_airport_related,

        total_trips,

        gross_trip_amount,
        core_fare_amount,
        total_tip_amount,

        avg_gross_trip_amount,
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

    FROM rate_code_metrics
)

SELECT
    rate_code_id,
    rate_code_name,
    rate_category,
    is_airport_related,

    total_trips,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,
    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(total_tip_amount, 2) AS total_tip_amount,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(avg_trip_duration_minutes, 2) AS avg_trip_duration_minutes,
    ROUND(tip_rate_percentage, 2) AS tip_rate_percentage,

    gross_trip_amount_rank,
    avg_trip_amount_rank,
    gross_trip_amount_share_percentage

FROM ranked_rate_codes