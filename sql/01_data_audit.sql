-- =============================================================================
-- 01_data_audit.sql
-- Data quality checks: missing values, duplicates, referential integrity,
-- range validation, and calculation verification
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: MISSING VALUE CHECKS
-- =============================================================================

-- Q: Are there any missing (NULL) values in the sales table?
SELECT
    COUNT(*)                       AS row_count,
    SUM(order_id IS NULL)          AS missing_order_id,
    SUM(order_date IS NULL)        AS missing_order_date,
    SUM(product_id IS NULL)        AS missing_product_id,
    SUM(store_id IS NULL)          AS missing_store_id,
    SUM(customer_id IS NULL)       AS missing_customer_id,
    SUM(quantity IS NULL)          AS missing_quantity,
    SUM(unit_price IS NULL)        AS missing_unit_price,
    SUM(discount IS NULL)          AS missing_discount,
    SUM(revenue IS NULL)           AS missing_revenue,
    SUM(cost IS NULL)              AS missing_cost,
    SUM(profit IS NULL)            AS missing_profit
FROM sales;

-- Q: Are there any missing (NULL) values in the products table?
SELECT
    COUNT(*)                        AS total_rows,
    SUM(product_id IS NULL)         AS missing_product_id,
    SUM(product_name IS NULL)       AS missing_product_name,
    SUM(brand IS NULL)              AS missing_brand,
    SUM(category IS NULL)           AS missing_category,
    SUM(cocoa_percent IS NULL)      AS missing_cocoa_percent,
    SUM(weight_g IS NULL)           AS missing_weight_g
FROM products;

-- Q: Are there any missing (NULL) values in the stores table?
SELECT
    COUNT(*)                    AS total_rows,
    SUM(store_name IS NULL)     AS missing_store_name,
    SUM(city IS NULL)           AS missing_city,
    SUM(country IS NULL)        AS missing_country,
    SUM(store_type IS NULL)     AS missing_store_type
FROM stores;

-- Q: Are there any missing (NULL) values in the customers table?
SELECT
    COUNT(*)                        AS total_rows,
    SUM(customer_id IS NULL)        AS missing_customer_id,
    SUM(age IS NULL)                AS missing_age,
    SUM(gender IS NULL)             AS missing_gender,
    SUM(loyalty_member IS NULL)     AS missing_loyalty_member,
    SUM(join_date IS NULL)          AS missing_join_date
FROM customers;

-- Q: Are there any missing (NULL) values in the calendar table?
SELECT
    COUNT(*)                       AS total_rows,
    SUM(`date` IS NULL)            AS missing_date,
    SUM(`year` IS NULL)            AS missing_year,
    SUM(`month` IS NULL)           AS missing_month,
    SUM(`day` IS NULL)             AS missing_day,
    SUM(`week` IS NULL)            AS missing_week,
    SUM(`day_of_week` IS NULL)     AS missing_day_of_week
FROM calendar;

-- =============================================================================
-- SECTION 2: DUPLICATE CHECKS
-- =============================================================================

-- Q: Are there duplicate order IDs in the sales table?
SELECT
    COUNT(DISTINCT order_id) AS unique_order_ids,
    COUNT(*)                 AS total_rows,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicates
FROM sales;

-- Q: Are there duplicate customer IDs in the customers table?
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(customer_id)          AS total_customers,
    COUNT(customer_id) - COUNT(DISTINCT customer_id) AS duplicates
FROM customers;

-- Q: Are there duplicate product IDs in the products table?
SELECT
    COUNT(*)                     AS total_rows,
    COUNT(DISTINCT product_id)   AS unique_product_ids,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicates
FROM products;

-- Q: Are there duplicate store IDs in the stores table?
SELECT
    COUNT(*)                    AS total_rows,
    COUNT(DISTINCT store_id)    AS unique_store_ids,
    COUNT(*) - COUNT(DISTINCT store_id) AS duplicates
FROM stores;

-- Q: Are there duplicate dates in the calendar table?
SELECT
    COUNT(*)                    AS total_rows,
    COUNT(DISTINCT `date`)      AS unique_dates,
    COUNT(*) - COUNT(DISTINCT `date`) AS duplicates
FROM calendar;

-- =============================================================================
-- SECTION 3: RANGE / SANITY CHECKS
-- =============================================================================

-- Q: Are there any zero or negative quantities in sales?
SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    AVG(quantity) AS avg_quantity,
    SUM(quantity = 0)  AS zero_quantity_rows,
    SUM(quantity < 0)  AS negative_quantity_rows
FROM sales;

-- Q: Are cocoa_percent and weight_g within valid ranges in the products table?
SELECT
    MIN(cocoa_percent) AS min_cocoa_percent,
    MAX(cocoa_percent) AS max_cocoa_percent,
    MIN(weight_g)      AS min_weight_g,
    MAX(weight_g)      AS max_weight_g,
    SUM(cocoa_percent <= 0 OR cocoa_percent > 100) AS invalid_cocoa_rows,
    SUM(weight_g <= 0)                             AS invalid_weight_rows
FROM products;

-- Q: What is the date range and value range in the calendar table?
SELECT
    MIN(`date`)        AS first_date,
    MAX(`date`)        AS last_date,
    MIN(`month`)       AS min_month,
    MAX(`month`)       AS max_month,
    MIN(`day`)         AS min_day,
    MAX(`day`)         AS max_day,
    MIN(`day_of_week`) AS min_day_of_week,
    MAX(`day_of_week`) AS max_day_of_week
FROM calendar;

-- Q: What is the product_id range in the products table?
SELECT
    MIN(product_id) AS first_product_id,
    MAX(product_id) AS last_product_id
FROM products;

-- =============================================================================
-- SECTION 4: REFERENTIAL INTEGRITY CHECKS
-- =============================================================================

-- Q: Do all foreign keys in sales match their parent tables (customers, products, stores, calendar)?
SELECT
    SUM(c.customer_id IS NULL)  AS missing_customer_id,
    SUM(p.product_id IS NULL)   AS missing_product_id,
    SUM(st.store_id IS NULL)    AS missing_store_id,
    SUM(ca.`date` IS NULL)      AS missing_date
FROM sales s
LEFT JOIN customers c  ON s.customer_id = c.customer_id
LEFT JOIN products p   ON s.product_id  = p.product_id
LEFT JOIN stores st    ON s.store_id    = st.store_id
LEFT JOIN calendar ca  ON s.order_date  = ca.`date`;

-- Q: Which product IDs in sales have no matching record in the products table, and how many sales are affected?
SELECT
    s.product_id,
    COUNT(*) AS affected_sales
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL
GROUP BY s.product_id
ORDER BY affected_sales DESC;

-- Q: Do the unmatched product IDs P0000 and P0201 exist in the sales data?
-- (These product IDs were found to not exist in the products table.)
SELECT product_id, COUNT(*) AS occurrences
FROM sales
WHERE product_id IN ('P0000', 'P0201')
GROUP BY product_id;

-- =============================================================================
-- SECTION 5: REVENUE / PROFIT CALCULATION VALIDATION
-- =============================================================================

-- Q: Does revenue equal quantity * unit_price * (1 - discount) for all rows?
SELECT
    COUNT(*) AS total_rows,
    SUM(
        ABS(revenue - (quantity * unit_price * (1 - discount))) > 0.01
    ) AS revenue_mismatch_count
FROM sales;

-- Q: Does profit equal revenue - cost for all rows?
SELECT
    COUNT(*) AS total_rows,
    SUM(
        ABS(profit - (revenue - cost)) > 0.01
    ) AS profit_mismatch_count
FROM sales;

-- Q: Show sample rows where revenue or profit calculations do not match
SELECT
    order_id,
    quantity,
    unit_price,
    discount,
    revenue,
    cost,
    profit,
    ROUND(quantity * unit_price * (1 - discount), 2) AS expected_revenue,
    ROUND(revenue - cost, 2)                         AS expected_profit
FROM sales
WHERE ABS(revenue - (quantity * unit_price * (1 - discount))) > 0.01
   OR ABS(profit - (revenue - cost)) > 0.01
LIMIT 20;
