SELECT
    pickup_year_month,
    COUNT(*) AS total_rows
FROM {{ ref('rpt_monthly_revenue_performance') }}
GROUP BY pickup_year_month
HAVING COUNT(*) > 1