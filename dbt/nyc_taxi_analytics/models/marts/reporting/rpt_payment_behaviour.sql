    {{ config(materialized='view') }}

    WITH payment_metrics AS (
        SELECT
            p.payment_type_id,
            p.payment_type_name,
            p.payment_category,

            COUNT(f.trip_id) AS total_trips,

            ROUND(SUM(f.total_amount), 2) AS total_revenue,
            ROUND(SUM(f.fare_amount), 2) AS total_fare,
            ROUND(SUM(f.tip_amount), 2) AS total_tip,

            ROUND(AVG(f.total_amount), 2) AS avg_revenue_per_trip,
            ROUND(AVG(f.fare_amount), 2) AS avg_fare_per_trip,
            ROUND(AVG(f.tip_amount), 2) AS avg_tip_per_trip,

            ROUND(SAFE_DIVIDE(SUM(f.tip_amount), SUM(f.fare_amount)) * 100, 2)
                AS tip_rate_percentage,

            ROUND(SAFE_DIVIDE(COUNTIF(f.has_tip = TRUE), COUNT(f.trip_id)) * 100, 2)
                AS tipped_trip_percentage

        FROM {{ ref('fact_yellow_taxi_trips') }} AS f

        LEFT JOIN {{ ref('dim_payment_type') }} AS p
            ON f.payment_type_id = p.payment_type_id

        GROUP BY
            p.payment_type_id,
            p.payment_type_name,
            p.payment_category
    ),

    payment_with_share AS (
        SELECT
            payment_type_id,
            payment_type_name,
            payment_category,

            total_trips,
            total_revenue,
            total_fare,
            total_tip,

            avg_revenue_per_trip,
            avg_fare_per_trip,
            avg_tip_per_trip,

            tip_rate_percentage,
            tipped_trip_percentage,

            ROUND(
                SAFE_DIVIDE(total_trips, SUM(total_trips) OVER ()) * 100,
                2
            ) AS trip_share_percentage,

            ROUND(
                SAFE_DIVIDE(total_revenue, SUM(total_revenue) OVER ()) * 100,
                2
            ) AS revenue_share_percentage

        FROM payment_metrics
    )

    SELECT
        payment_type_id,
        payment_type_name,
        payment_category,

        total_trips,
        trip_share_percentage,

        total_revenue,
        revenue_share_percentage,

        total_fare,
        total_tip,

        avg_revenue_per_trip,
        avg_fare_per_trip,
        avg_tip_per_trip,

        tip_rate_percentage,
        tipped_trip_percentage

    FROM payment_with_share