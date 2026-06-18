{{ config(materialized='table') }}

SELECT
    payment_type_id,
    payment_type_name,
    payment_category,
    is_standard_payment_type
FROM UNNEST([
    STRUCT(0 AS payment_type_id, 'Flex fare' AS payment_type_name, 'Special fare program' AS payment_category, TRUE AS is_standard_payment_type),
    STRUCT(1 AS payment_type_id, 'Credit card' AS payment_type_name, 'Card payment' AS payment_category, TRUE AS is_standard_payment_type),
    STRUCT(2 AS payment_type_id, 'Cash' AS payment_type_name, 'Cash payment' AS payment_category, TRUE AS is_standard_payment_type),
    STRUCT(3 AS payment_type_id, 'No charge' AS payment_type_name, 'Non-revenue' AS payment_category, TRUE AS is_standard_payment_type),
    STRUCT(4 AS payment_type_id, 'Dispute' AS payment_type_name, 'Exception' AS payment_category, TRUE AS is_standard_payment_type),
    STRUCT(5 AS payment_type_id, 'Unknown' AS payment_type_name, 'Unknown' AS payment_category, TRUE AS is_standard_payment_type)
])