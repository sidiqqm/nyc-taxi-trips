{{ config(materialized='table') }}

WITH base_trips AS (
    SELECT
        trip_id,
        total_amount,
        fare_amount,
        tip_amount,
        trip_distance,
        trip_duration_minutes
    FROM {{ ref('fact_yellow_taxi_trips') }}
),

quantiles AS (
    SELECT
        APPROX_QUANTILES(total_amount, 100)[OFFSET(25)] AS q1_total_amount,
        APPROX_QUANTILES(total_amount, 100)[OFFSET(75)] AS q3_total_amount
    FROM base_trips
),

thresholds AS (
    SELECT
        q1_total_amount,
        q3_total_amount,
        q3_total_amount - q1_total_amount AS iqr_total_amount,
        q3_total_amount
        + 1.5 * (q3_total_amount - q1_total_amount)
            AS upper_total_amount_threshold
    FROM quantiles
),

flagged_trips AS (
    SELECT
        base_trips.trip_id,
        base_trips.total_amount,
        base_trips.fare_amount,
        base_trips.tip_amount,
        base_trips.trip_distance,
        base_trips.trip_duration_minutes,

        thresholds.upper_total_amount_threshold,

        base_trips.total_amount > thresholds.upper_total_amount_threshold
            AS is_total_amount_outlier

    FROM base_trips
    CROSS JOIN thresholds
),

summary AS (
    SELECT
        CASE
            WHEN is_total_amount_outlier THEN 'Revenue outlier'
            ELSE 'Non-revenue-outlier'
        END AS revenue_group,

        CASE
            WHEN is_total_amount_outlier THEN 2
            ELSE 1
        END AS revenue_group_order,

        MAX(upper_total_amount_threshold)
            AS upper_total_amount_threshold,

        COUNT(trip_id) AS total_trips,

        SUM(total_amount) AS gross_trip_amount,
        SUM(fare_amount) AS core_fare_amount,
        SUM(tip_amount) AS total_tip_amount,

        AVG(total_amount) AS avg_gross_trip_amount,
        AVG(fare_amount) AS avg_fare_amount,
        AVG(tip_amount) AS avg_tip_amount,

        AVG(trip_distance) AS avg_trip_distance,
        AVG(trip_duration_minutes) AS avg_trip_duration_minutes

    FROM flagged_trips
    GROUP BY
        revenue_group,
        revenue_group_order
)

SELECT
    revenue_group,
    revenue_group_order,

    ROUND(upper_total_amount_threshold, 2)
        AS upper_total_amount_threshold,

    total_trips,

    ROUND(
        SAFE_DIVIDE(total_trips, SUM(total_trips) OVER ()) * 100,
        2
    ) AS trip_share_percentage,

    ROUND(gross_trip_amount, 2) AS gross_trip_amount,

    ROUND(
        SAFE_DIVIDE(
            gross_trip_amount,
            SUM(gross_trip_amount) OVER ()
        ) * 100,
        2
    ) AS gross_trip_amount_share_percentage,

    ROUND(core_fare_amount, 2) AS core_fare_amount,
    ROUND(total_tip_amount, 2) AS total_tip_amount,

    ROUND(avg_gross_trip_amount, 2) AS avg_gross_trip_amount,
    ROUND(avg_fare_amount, 2) AS avg_fare_amount,
    ROUND(avg_tip_amount, 2) AS avg_tip_amount,

    ROUND(avg_trip_distance, 2) AS avg_trip_distance,
    ROUND(avg_trip_duration_minutes, 2) AS avg_trip_duration_minutes

FROM summary