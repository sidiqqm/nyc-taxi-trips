SELECT
    pickup_year_month,
    pickup_time_period,
    payment_type_name
FROM {{ ref('rpt_credit_card_tip_behavior') }}
WHERE LOWER(payment_type_name) != 'credit card'