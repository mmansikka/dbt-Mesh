WITH stg_orders AS (
  SELECT
    *
  FROM {{ ref('stg_orders') }}
), stg_customers AS (
  SELECT
    *
  FROM {{ ref('stg_customers') }}
), stg_locations AS (
  SELECT
    *
  FROM {{ ref('stg_locations') }}
), rename_1 AS (
  SELECT
    location_id AS orders_location_id,
    customer_id AS orders_customer_id,
    *
    EXCEPT (location_id, customer_id)
  FROM stg_orders
), rename_2 AS (
  SELECT
    customer_id AS customers_customer_id,
    *
    EXCEPT (customer_id)
  FROM stg_customers
), rename_3 AS (
  SELECT
    location_id AS locations_location_id,
    *
    EXCEPT (location_id)
  FROM stg_locations
), join_1 AS (
  SELECT
    *
  FROM rename_1
  LEFT JOIN rename_2
    ON rename_1.orders_customer_id = rename_2.customers_customer_id
), join_2 AS (
  SELECT
    *
  FROM join_1
  LEFT JOIN rename_3
    ON join_1.orders_location_id = rename_3.locations_location_id
), rename_4 AS (
  SELECT
    order_id,
    orders_location_id AS location_id,
    orders_customer_id AS customer_id,
    order_total,
    tax_paid,
    ordered_at,
    customer_name,
    location_name,
    tax_rate,
    location_opened_at
  FROM join_2
), int_orders AS (
  /* My orders model
*/
  SELECT
    order_id,
    location_id,
    customer_id,
    order_total,
    tax_paid,
    ordered_at,
    customer_name,
    location_name,
    tax_rate,
    location_opened_at
  FROM rename_4
)
SELECT
  *
FROM int_orders