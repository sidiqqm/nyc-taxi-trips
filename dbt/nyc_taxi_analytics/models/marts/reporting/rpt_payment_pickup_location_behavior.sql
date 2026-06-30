{{ config(materialized='table') }}

WITH payment_location_metrics AS (
    SELECT
        l.location_id AS pickup_location_id,
        l.borough AS pickup_borough,
        l.zone_name AS pickup_zone,
        l.service_zone AS pickup_service_zone,

        COALESCE(p.payment_type_id, f.payment_type_id)
            AS payment_type_id,

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
        AVG(f.trip_distance) AS avg_trip_distance

    FROM {{ ref('fact_yellow_taxi_trips') }} AS f

    INNER JOIN {{ ref('dim_location') }} AS l
        ON f.pickup_location_id = l.location_id

    LEFT JOIN {{ ref('dim_payment_type') }} AS p
        ON f.payment_type_id = p.payment_type_id

    GROUP BY
        pickup_location_id,
        pickup_borough,
        pickup_zone,
        pickup_service_zone,
        payment_type_id,
        payment_type_name,
        payment_category
),

payment_location_ranked AS (
    SELECT
        pickup_location_id,
        pickup_borough,
        pickup_zone,
        pickup_service_zone,

        payment_type_id,
        payment_type_name,
        payment_category,

        total_trips,
        gross_trip_amount,
        core_fare_amount,
        recorded_tip_amount,

        avg_gross_trip_amount,
        avg_trip_distance,

        SAFE_DIVIDE(
            total_trips,
            SUM(total_trips) OVER (
                PARTITION BY pickup_location_id
            )
        ) * 100 AS payment_trip_share_within_zone,

        SAFE_DIVIDE(
            gross_trip_amount,
            SUM(gross_trip_amount) OVER (
                PARTITION BY pickup_location_id
            )
        ) * 100 AS payment_revenue_share_within_zone,

        DENSE_RANK() OVER (
            PARTITION BY pickup_location_id
            ORDER BY total_trips DESC
        ) AS payment_volume_rank_within_zone

    FROM payment_location_metrics
)

SELECT
    pickup_location_id,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,

    payment_type_id,
    payment_type_name,
    payment_category,

    total_trips,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,
    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(recorded_tip_amount, 2) AS recorded_tip_amount,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_trip_distance, 2) AS avg_trip_distance,

    ROUND(
        payment_trip_share_within_zone,
        2
    ) AS payment_trip_share_within_zone,

    ROUND(
        payment_revenue_share_within_zone,
        2
    ) AS payment_revenue_share_within_zone,

    payment_volume_rank_within_zone

FROM payment_location_ranked