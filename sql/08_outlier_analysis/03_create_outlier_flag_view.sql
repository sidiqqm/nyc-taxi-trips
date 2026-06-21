CREATE OR REPLACE VIEW `nyc-taxi-analytics-1.nyc_taxi_dbt_reporting.vw_yellow_taxi_outlier_flags` AS

WITH base AS (
    SELECT
        trip_id,

        pickup_datetime,
        dropoff_datetime,
        pickup_date,
        pickup_year_month,
        pickup_hour,
        pickup_time_period,
        is_weekend,

        pickup_location_id,
        dropoff_location_id,
        payment_type_id,
        rate_code_id,

        passenger_count,
        trip_distance,
        trip_duration_minutes,

        fare_amount,
        tip_amount,
        total_amount,
        fare_per_mile,
        tip_rate

    FROM `nyc-taxi-analytics-1.nyc_taxi_dbt_marts.fact_yellow_taxi_trips`
),

quantiles AS (
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

    FROM base
),

thresholds AS (
    SELECT
        q1_trip_distance - 1.5 * (q3_trip_distance - q1_trip_distance) AS lower_trip_distance,
        q3_trip_distance + 1.5 * (q3_trip_distance - q1_trip_distance) AS upper_trip_distance,

        q1_trip_duration - 1.5 * (q3_trip_duration - q1_trip_duration) AS lower_trip_duration,
        q3_trip_duration + 1.5 * (q3_trip_duration - q1_trip_duration) AS upper_trip_duration,

        q1_fare_amount - 1.5 * (q3_fare_amount - q1_fare_amount) AS lower_fare_amount,
        q3_fare_amount + 1.5 * (q3_fare_amount - q1_fare_amount) AS upper_fare_amount,

        q1_total_amount - 1.5 * (q3_total_amount - q1_total_amount) AS lower_total_amount,
        q3_total_amount + 1.5 * (q3_total_amount - q1_total_amount) AS upper_total_amount,

        q1_fare_per_mile - 1.5 * (q3_fare_per_mile - q1_fare_per_mile) AS lower_fare_per_mile,
        q3_fare_per_mile + 1.5 * (q3_fare_per_mile - q1_fare_per_mile) AS upper_fare_per_mile,

        q1_tip_rate - 1.5 * (q3_tip_rate - q1_tip_rate) AS lower_tip_rate,
        q3_tip_rate + 1.5 * (q3_tip_rate - q1_tip_rate) AS upper_tip_rate

    FROM quantiles
),

flagged AS (
    SELECT
        b.trip_id,

        b.pickup_datetime,
        b.dropoff_datetime,
        b.pickup_date,
        b.pickup_year_month,
        b.pickup_hour,
        b.pickup_time_period,
        b.is_weekend,

        b.pickup_location_id,
        b.dropoff_location_id,
        b.payment_type_id,
        b.rate_code_id,

        b.passenger_count,
        b.trip_distance,
        b.trip_duration_minutes,

        b.fare_amount,
        b.tip_amount,
        b.total_amount,
        b.fare_per_mile,
        b.tip_rate,

        b.trip_distance < t.lower_trip_distance
        OR b.trip_distance > t.upper_trip_distance
            AS is_trip_distance_outlier,

        b.trip_duration_minutes < t.lower_trip_duration
        OR b.trip_duration_minutes > t.upper_trip_duration
            AS is_trip_duration_outlier,

        b.fare_amount < t.lower_fare_amount
        OR b.fare_amount > t.upper_fare_amount
            AS is_fare_amount_outlier,

        b.total_amount < t.lower_total_amount
        OR b.total_amount > t.upper_total_amount
            AS is_total_amount_outlier,

        b.fare_per_mile < t.lower_fare_per_mile
        OR b.fare_per_mile > t.upper_fare_per_mile
            AS is_fare_per_mile_outlier,

        b.tip_rate < t.lower_tip_rate
        OR b.tip_rate > t.upper_tip_rate
            AS is_tip_rate_outlier

    FROM base b
    CROSS JOIN thresholds t
)

SELECT
    trip_id,

    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_year_month,
    pickup_hour,
    pickup_time_period,
    is_weekend,

    pickup_location_id,
    dropoff_location_id,
    payment_type_id,
    rate_code_id,

    passenger_count,
    trip_distance,
    trip_duration_minutes,

    fare_amount,
    tip_amount,
    total_amount,
    fare_per_mile,
    tip_rate,

    is_trip_distance_outlier,
    is_trip_duration_outlier,
    is_fare_amount_outlier,
    is_total_amount_outlier,
    is_fare_per_mile_outlier,
    is_tip_rate_outlier,

    is_trip_distance_outlier
    OR is_trip_duration_outlier
    OR is_fare_amount_outlier
    OR is_total_amount_outlier
    OR is_fare_per_mile_outlier
    OR is_tip_rate_outlier AS is_any_outlier

FROM flagged;