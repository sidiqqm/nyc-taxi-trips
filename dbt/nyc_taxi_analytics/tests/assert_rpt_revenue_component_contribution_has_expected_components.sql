WITH expected_components AS (
    SELECT 'Core Fare' AS component_name
    UNION ALL SELECT 'Tip'
    UNION ALL SELECT 'Tolls'
    UNION ALL SELECT 'Extra'
    UNION ALL SELECT 'MTA Tax'
    UNION ALL SELECT 'Improvement Surcharge'
    UNION ALL SELECT 'Congestion Surcharge'
    UNION ALL SELECT 'Airport Fee'
),

actual_components AS (
    SELECT
        component_name
    FROM {{ ref('rpt_revenue_component_contribution') }}
)

SELECT
    expected_components.component_name
FROM expected_components

LEFT JOIN actual_components
    ON expected_components.component_name = actual_components.component_name

WHERE actual_components.component_name IS NULL