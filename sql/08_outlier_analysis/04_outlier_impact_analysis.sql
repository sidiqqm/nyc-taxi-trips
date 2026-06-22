WITH base AS (
    SELECT
        trip_id,
        trip_distance,
        trip_duration_minutes,
        fare_amount,
        tip_amount,
        total_amount,
        fare_per_mile,
        tip_rate,
        is_any_outlier
    FROM `nyc-taxi-analytics-1.nyc_taxi_dbt_reporting.vw_yellow_taxi_outlier_flags`
),

summary AS (
    SELECT
        CASE
            WHEN is_any_outlier = TRUE THEN 'Outlier'
            ELSE 'Non-Outlier'
        END AS outlier_group,

        COUNT(trip_id) AS total_trips,

        ROUND(SUM(total_amount), 2) AS total_revenue,
        ROUND(SUM(fare_amount), 2) AS total_fare,
        ROUND(SUM(tip_amount), 2) AS total_tip,

        ROUND(AVG(total_amount), 2) AS avg_total_amount,
        ROUND(AVG(fare_amount), 2) AS avg_fare_amount,
        ROUND(AVG(tip_amount), 2) AS avg_tip_amount,

        ROUND(AVG(trip_distance), 2) AS avg_trip_distance,
        ROUND(AVG(trip_duration_minutes), 2) AS avg_trip_duration_minutes,
        ROUND(AVG(fare_per_mile), 2) AS avg_fare_per_mile,
        ROUND(AVG(tip_rate), 2) AS avg_tip_rate

    FROM base
    GROUP BY outlier_group
),

with_share AS (
    SELECT
        outlier_group,

        total_trips,
        ROUND(SAFE_DIVIDE(total_trips, SUM(total_trips) OVER ()) * 100, 2)
            AS trip_share_percentage,

        total_revenue,
        ROUND(SAFE_DIVIDE(total_revenue, SUM(total_revenue) OVER ()) * 100, 2)
            AS revenue_share_percentage,

        total_fare,
        total_tip,

        avg_total_amount,
        avg_fare_amount,
        avg_tip_amount,
        avg_trip_distance,
        avg_trip_duration_minutes,
        avg_fare_per_mile,
        avg_tip_rate

    FROM summary
)

SELECT
    outlier_group,
    total_trips,
    trip_share_percentage,
    total_revenue,
    revenue_share_percentage,
    total_fare,
    total_tip,

    avg_total_amount,
    avg_fare_amount,
    avg_tip_amount,
    avg_trip_distance,
    avg_trip_duration_minutes,
    avg_fare_per_mile,
    avg_tip_rate
FROM with_share
ORDER BY outlier_group;