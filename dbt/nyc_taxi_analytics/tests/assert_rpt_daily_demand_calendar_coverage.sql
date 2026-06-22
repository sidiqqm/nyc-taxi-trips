SELECT
    dim_date.full_date
FROM {{ ref('dim_date') }} AS dim_date

LEFT JOIN {{ ref('rpt_daily_demand') }} AS daily_demand
    ON dim_date.full_date = daily_demand.pickup_date

WHERE dim_date.full_date BETWEEN '2023-01-01' AND '2023-12-31'
  AND daily_demand.pickup_date IS NULL