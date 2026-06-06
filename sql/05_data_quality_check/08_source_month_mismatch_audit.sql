SELECT
    source_month,
    pickup_year_month,
    COUNT(*) AS total_rows,
    COUNTIF(is_source_month_mismatch = TRUE) AS mismatch_rows,
    ROUND(
        COUNTIF(is_source_month_mismatch = TRUE) * 100.0, 2
    ) AS mismacth_percentage
FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
GROUP BY source_month, pickup_year_month
ORDER BY source_month, pickup_year_month