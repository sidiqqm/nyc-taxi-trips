-- trip distance, trip_duration, fare_amount, total_amount, fare per mile, dan tip rate

SELECT
    COUNT(*) AS total_rows,

    ROUND(MIN(trip_distance), 2) AS min_trip_disntance,
    ROUND(APPROX_QUANTILES(trip_distance, 100)[OFFSET(25)], 2) AS q1_trip_distance,
    ROUND(APPROX_QUANTILES(trip_distance, 100)[OFFSET(50)], 2) AS median_trip_distance,
    ROUND(APPROX_QUANTILES(trip_distance, 100)[OFFSET(75)], 2) AS q3_trip_distance,
    ROUND(MAX(trip_distance), 2) AS max_trip_distance,

    ROUND(MIN(trip_duration), 2) AS min_trip_duration,
    ROUND(APPROX_QUANTILES(trip_duration, 100)[OFFSET(25)], 2) AS q1_trip_duration,
    ROUND(APPROX_QUANTILES(trip_duration, 100)OFFSET(50), 2) AS median_trip_duration,
    ROUND(APPROX_QUANTILES(trip_duration, 100)[OFFSET(75)], 2) AS q3_trip_duration,
    ROUND(MAX(trip_duration), 2) AS max_trip_duration,

    ROUND(MIN(fare_amount), 2) AS min_fare_amount,
    ROUND(APPROX_QUANTILES(fare_amount, 100)[OFFSET(25)], 2) AS q1_fare_amount,
    ROUND(APPROX_QUANTILES(fare_amount, 100)OFFSET(50), 2) AS median_fare_amount,
    ROUND(APPROX_QUANTILES(fare_amount, 100)[OFFSET(75)], 2) AS q3_fare_amount,
    ROUND(MAX(fare_amount), 2) AS max_fare_amount,

    ROUND(MIN(total_amount), 2) AS min_total_amount,
    ROUND(APPROX_QUANTILES(total_amount, 100)[OFFSET(25)], 2) AS q1_total_amount,
    ROUND(APPROX_QUANTILES(total_amount, 100)OFFSET(50), 2) AS median_total_amount,
    ROUND(APPROX_QUANTILES(total_amount, 100)[OFFSET(75)], 2) AS q3_total_amount,
    ROUND(MAX(total_amount), 2) AS max_total_amount,

    ROUND(MIN(tip_rate), 2) AS min_tip_rate,
    ROUND(APPROX_QUANTILES(tip_rate, 100)[OFFSET(25)], 2) AS q1_tip_rate,
    ROUND(APPROX_QUANTILES(tip_rate, 100)OFFSET(50), 2) AS median_tip_rate,
    ROUND(APPROX_QUANTILES(tip_rate, 100)[OFFSET(75)], 2) AS q3_tip_rate,
    ROUND(MAX(tip_rate), 2) AS max_tip_rate
    
FROM `nyc-taxi-analytics-1.nyc_taxi_dbt_marts.fact_yellow_taxi_trips`;