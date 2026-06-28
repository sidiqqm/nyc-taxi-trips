{{ config(materialized='table') }}

WITH payment_metrics AS (
    SELECT
        COALESCE(p.payment_type_id, f.payment_type_id) AS payment_type_id,

        COALESCE(
            p.payment_type_name,
            f.payment_type_name,
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
        AVG(f.fare_amount) AS avg_fare_amount,
        AVG(f.trip_distance) AS avg_trip_distance,
        AVG(f.trip_duration_minutes) AS avg_trip_duration_minutes,

        COUNTIF(f.tip_amount > 0) AS recorded_tipped_trips,

        SAFE_DIVIDE(
            COUNTIF(f.tip_amount > 0),
            COUNT(f.trip_id)
        ) * 100 AS recorded_tipped_trip_percentage,

        SAFE_DIVIDE(
            SUM(COALESCE(f.tip_amount, 0)),
            SUM(COALESCE(f.fare_amount, 0))
        ) * 100 AS recorded_tip_rate_percentage

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    LEFT JOIN {{ ref('dim_payment_type') }} AS p
        ON f.payment_type_id = p.payment_type_id

    GROUP BY
        payment_type_id,
        payment_type_name,
        payment_category
),

payment_with_metrics AS (
    SELECT
        payment_type_id,
        payment_type_name,
        payment_category,

        total_trips,
        gross_trip_amount,
        core_fare_amount,
        recorded_tip_amount,

        avg_gross_trip_amount,
        avg_fare_amount,
        avg_trip_distance,
        avg_trip_duration_minutes,

        recorded_tipped_trips,
        recorded_tipped_trip_percentage,
        recorded_tip_rate_percentage,

        DENSE_RANK() OVER (
            ORDER BY total_trips DESC
        ) AS trip_volume_rank,

        DENSE_RANK() OVER (
            ORDER BY gross_trip_amount DESC
        ) AS gross_trip_amount_rank,

        DENSE_RANK() OVER (
            ORDER BY avg_gross_trip_amount DESC
        ) AS avg_gross_trip_amount_rank,

        SAFE_DIVIDE(
            total_trips,
            SUM(total_trips) OVER ()
        ) * 100 AS trip_share_percentage,

        SAFE_DIVIDE(
            gross_trip_amount,
            SUM(gross_trip_amount) OVER ()
        ) * 100 AS gross_trip_amount_share_percentage

    FROM payment_metrics
)

SELECT
    payment_type_id,
    payment_type_name,
    payment_category,

    total_trips,

    ROUND(trip_share_percentage, 2) AS trip_share_percentage,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,
    ROUND(gross_trip_amount_share_percentage, 2)
        AS gross_trip_amount_share_percentage,

    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(recorded_tip_amount, 2) AS recorded_tip_amount,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_fare_amount, 2) AS avg_fare_amount,
    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(avg_trip_duration_minutes, 2) AS avg_trip_duration_minutes,

    recorded_tipped_trips,
    ROUND(
        recorded_tipped_trip_percentage,
        2
    ) AS recorded_tipped_trip_percentage,

    ROUND(
        recorded_tip_rate_percentage,
        2
    ) AS recorded_tip_rate_percentage,

    CASE
        WHEN LOWER(payment_type_name) = 'credit card'
            THEN 'Recorded tip metrics are comparable'

        WHEN LOWER(payment_type_name) = 'cash'
            THEN 'Cash tips are not captured in tip_amount'

        ELSE 'Tip interpretation is not applicable'
    END AS tip_interpretation_note,

    trip_volume_rank,
    gross_trip_amount_rank,
    avg_gross_trip_amount_rank

FROM payment_with_metrics