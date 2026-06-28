WITH top_revenue_months AS (
    SELECT
        pickup_year_month AS category,
        gross_trip_amount AS metric_value,
        'Top Revenue Month' AS analysis_type,
        DENSE_RANK() OVER (
            ORDER BY gross_trip_amount DESC
        ) AS metric_rank
    FROM {{ ref('rpt_monthly_revenue_performance') }}
),

top_revenue_time_periods AS (
    SELECT
        pickup_time_period AS category,
        gross_trip_amount AS metric_value,
        'Top Revenue Time Period' AS analysis_type,
        gross_trip_amount_rank AS metric_rank
    FROM {{ ref('rpt_revenue_time_period') }}
),

top_revenue_pickup_zones AS (
    SELECT
        pickup_full_location_name AS category,
        total_revenue AS metric_value,
        'Top Revenue Pickup Zone' AS analysis_type,
        revenue_rank AS metric_rank
    FROM {{ ref('rpt_pickup_location_performance') }}
)

SELECT
    analysis_type,
    category,
    ROUND(metric_value, 2) AS metric_value,
    metric_rank
FROM top_revenue_months
WHERE metric_rank <= 10

UNION ALL

SELECT
    analysis_type,
    category,
    ROUND(metric_value, 2) AS metric_value,
    metric_rank
FROM top_revenue_time_periods
WHERE metric_rank <= 10

UNION ALL

SELECT
    analysis_type,
    category,
    ROUND(metric_value, 2) AS metric_value,
    metric_rank
FROM top_revenue_pickup_zones
WHERE metric_rank <= 10

ORDER BY
    analysis_type,
    metric_rank