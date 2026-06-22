SELECT
    day_of_week,
    pickup_hour,
    COUNT(*) AS total_rows
FROM {{ ref('rpt_demand_heatmap') }}
GROUP BY
    day_of_week,
    pickup_hour
HAVING COUNT(*) > 1