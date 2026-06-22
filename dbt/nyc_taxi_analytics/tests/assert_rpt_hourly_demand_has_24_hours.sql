WITH expected_hours AS (
    SELECT
        hour_value AS pickup_hour
    FROM UNNEST(GENERATE_ARRAY(0, 23)) AS hour_value
),

observed_hours AS (
    SELECT
        pickup_hour
    FROM {{ ref('rpt_hourly_demand') }}
)

SELECT
    expected_hours.pickup_hour
FROM expected_hours

LEFT JOIN observed_hours
    ON expected_hours.pickup_hour = observed_hours.pickup_hour

WHERE observed_hours.pickup_hour IS NULL