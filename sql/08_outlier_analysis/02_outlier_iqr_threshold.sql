WITH quantiles AS (
    SELECT
        APPROX_QUANTILES(trip_distance, 100)[OFFSET(25)] AS q1_trip_distance,
        APPROX_QUANTILES(trip_distance, 100)[OFFSET(75)] AS q3_trip_distance,

        APPROX_QUANTILES(trip_duration_minutes, 100)[OFFSET(25)] AS q1_trip_duration,
        APPROX_QUANTILES(trip_duration_minutes, 100)[OFFSET(75)] AS q3_trip_duration,

        APPROX_QUANTILES(fare_amount, 100)[OFFSET(25)] AS q1_fare_amount,
        APPROX_QUANTILES(fare_amount, 100)[OFFSET(75)] AS q3_fare_amount,

        APPROX_QUANTILES(total_amount, 100)[OFFSET(25)] AS q1_total_amount,
        APPROX_QUANTILES(total_amount, 100)[OFFSET(75)] AS q3_total_amount,

        APPROX_QUANTILES(fare_per_mile, 100)[OFFSET(25)] AS q1_fare_per_mile,
        APPROX_QUANTILES(fare_per_mile, 100)[OFFSET(75)] AS q3_fare_per_mile,

        APPROX_QUANTILES(tip_rate, 100)[OFFSET(25)] AS q1_tip_rate,
        APPROX_QUANTILES(tip_rate, 100)[OFFSET(75)] AS q3_tip_rate

    FROM `your_project_id.nyc_taxi_dbt_marts.fact_yellow_taxi_trips`
),

thresholds AS (
    SELECT
        q1_trip_distance,
        q3_trip_distance,
        q3_trip_distance - q1_trip_distance AS iqr_trip_distance,
        q1_trip_distance - 1.5 * (q3_trip_distance - q1_trip_distance) AS lower_trip_distance,
        q3_trip_distance + 1.5 * (q3_trip_distance - q1_trip_distance) AS upper_trip_distance,

        q1_trip_duration,
        q3_trip_duration,
        q3_trip_duration - q1_trip_duration AS iqr_trip_duration,
        q1_trip_duration - 1.5 * (q3_trip_duration - q1_trip_duration) AS lower_trip_duration,
        q3_trip_duration + 1.5 * (q3_trip_duration - q1_trip_duration) AS upper_trip_duration,

        q1_fare_amount,
        q3_fare_amount,
        q3_fare_amount - q1_fare_amount AS iqr_fare_amount,
        q1_fare_amount - 1.5 * (q3_fare_amount - q1_fare_amount) AS lower_fare_amount,
        q3_fare_amount + 1.5 * (q3_fare_amount - q1_fare_amount) AS upper_fare_amount,

        q1_total_amount,
        q3_total_amount,
        q3_total_amount - q1_total_amount AS iqr_total_amount,
        q1_total_amount - 1.5 * (q3_total_amount - q1_total_amount) AS lower_total_amount,
        q3_total_amount + 1.5 * (q3_total_amount - q1_total_amount) AS upper_total_amount,

        q1_fare_per_mile,
        q3_fare_per_mile,
        q3_fare_per_mile - q1_fare_per_mile AS iqr_fare_per_mile,
        q1_fare_per_mile - 1.5 * (q3_fare_per_mile - q1_fare_per_mile) AS lower_fare_per_mile,
        q3_fare_per_mile + 1.5 * (q3_fare_per_mile - q1_fare_per_mile) AS upper_fare_per_mile,

        q1_tip_rate,
        q3_tip_rate,
        q3_tip_rate - q1_tip_rate AS iqr_tip_rate,
        q1_tip_rate - 1.5 * (q3_tip_rate - q1_tip_rate) AS lower_tip_rate,
        q3_tip_rate + 1.5 * (q3_tip_rate - q1_tip_rate) AS upper_tip_rate

    FROM quantiles
)

SELECT
    *
FROM thresholds;