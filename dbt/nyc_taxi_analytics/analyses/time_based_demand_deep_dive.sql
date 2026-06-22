WITH daily_demand AS (
    SELECT
        pickup_date,
        pickup_year_month,
        day_name,
        is_weekend,
        total_trips,
        demand_7_day_moving_avg
    FROM {{ ref('rpt_daily_demand') }}
),

peak_daily_demand AS (
    SELECT
        pickup_date,
        pickup_year_month,
        day_name,
        is_weekend,
        total_trips,
        demand_7_day_moving_avg,

        RANK() OVER (
            ORDER BY total_trips DESC
        ) AS demand_rank

    FROM daily_demand
),

peak_hour AS (
    SELECT
        pickup_hour,
        pickup_time_period,
        total_trips,
        avg_trips_per_active_day,
        demand_rank
    FROM {{ ref('rpt_hourly_demand') }}
)

SELECT
    'Peak Daily Demand' AS analysis_type,
    CAST(pickup_date AS STRING) AS period,
    total_trips AS demand_value,
    demand_rank AS ranking
FROM peak_daily_demand
WHERE demand_rank <= 10

UNION ALL

SELECT
    'Peak Hour Demand' AS analysis_type,
    CAST(pickup_hour AS STRING) AS period,
    total_trips AS demand_value,
    demand_rank AS ranking
FROM peak_hour
WHERE demand_rank <= 10

ORDER BY
    analysis_type,
    ranking