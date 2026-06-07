WITH date_range AS (
    SELECT
        MIN(pickup_date) AS start_date,
        MAX(DATE(dropoff_datetime)) AS end_date
    FROM `nyc-taxi-analytics-1.nyc_taxi_staging.stg_yellow_taxi_trips_cleaned`
),

date_spine AS (
    SELECT
        date_day
    FROM date_range
    UNNEST(GENERATE_DATE_ARRAY(start_date, end_date)) AS date_day
)

SELECT
    CAST(FORMAT_DATE('%Y%m%d', date_day) AS INT64) AS date_id,
    date_day AS full_date,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(QUARTER FROM date_day) AS quarter,
    EXTRACT(MONTH FROM date_day) AS month,
    FORMAT_DATE('%B', date_day) AS month_name,
    FORMAT_DATE('%Y-%m') AS year_month,

    EXTRACT(DAY FROM date_day) AS day,
    EXTRACT(DAYOFWEEK FROM date_day) day_of_week
    FORMAT_DATE('%A', date_day) AS day_name,

    EXTRACT(ISOWEEK FROM date_day) AS iso_week,
    EXTRACT(ISOYEAR FROM date_day) AS iso_year

    CASE
        WHEN EXTRACT(DAY FROM date_day) IN (1, 7)
            THEN TRUE
        ELSE FALSE
    END AS is_weekend,

    CASE
        WHEN EXTRACT(DAY FROM date_day) BETWEEN 2 AND 6
            THEN TRUE
        ELSE FALSE
    END AS is_weekday

    CASE
        WHEN EXTRACT(MONTH FROM date_day) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM date_day) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date_day) IN (6,7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date_day) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Unknown'
    END AS season

FROM date_spine
ORDER BY full_date