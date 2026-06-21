SELECT
    COUNT(*) AS total_rows,

    COUNTIF(is_trip_distance_outlier) AS trip_distance_outliers,
    ROUND(COUNTIF(is_trip_distance_outlier) * 100.0 / COUNT(*), 2)
        AS trip_distance_outlier_percentage,

    COUNTIF(is_trip_duration_outlier) AS trip_duration_outliers,
    ROUND(COUNTIF(is_trip_duration_outlier) * 100.0 / COUNT(*), 2)
        AS trip_duration_outlier_percentage,

    COUNTIF(is_fare_amount_outlier) AS fare_amount_outliers,
    ROUND(COUNTIF(is_fare_amount_outlier) * 100.0 / COUNT(*), 2)
        AS fare_amount_outlier_percentage,

    COUNTIF(is_total_amount_outlier) AS total_amount_outliers,
    ROUND(COUNTIF(is_total_amount_outlier) * 100.0 / COUNT(*), 2)
        AS total_amount_outlier_percentage,

    COUNTIF(is_fare_per_mile_outlier) AS fare_per_mile_outliers,
    ROUND(COUNTIF(is_fare_per_mile_outlier) * 100.0 / COUNT(*), 2)
        AS fare_per_mile_outlier_percentage,

    COUNTIF(is_tip_rate_outlier) AS tip_rate_outliers,
    ROUND(COUNTIF(is_tip_rate_outlier) * 100.0 / COUNT(*), 2)
        AS tip_rate_outlier_percentage,

    COUNTIF(is_any_outlier) AS any_outlier_rows,
    ROUND(COUNTIF(is_any_outlier) * 100.0 / COUNT(*), 2)
        AS any_outlier_percentage

FROM `nyc-taxi-analytics-1.nyc_taxi_dbt_reporting.vw_yellow_taxi_outlier_flags`;