-- =============================================================================
-- 01_data_audit.sql
-- Empirical Data Quality Audit, Integrity Checks, & Reconciliation
-- Retail Stores Sales Analysis (2023-2024)
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: NULL AND MISSING VALUE AUDITING
-- =============================================================================

-- Q: Are there any NULL or missing values across the 1,000,000 sales transactions?
SELECT
    COUNT(*)                       AS total_rows,
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

-- Q: Are there any NULL values in the dimension tables?
SELECT 'products' AS table_name,
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL OR product_name IS NULL OR brand IS NULL OR category IS NULL OR cocoa_percent IS NULL OR weight_g IS NULL) AS rows_with_nulls
FROM products
UNION ALL
SELECT 'customers', COUNT(*), SUM(customer_id IS NULL OR age IS NULL OR gender IS NULL OR loyalty_member IS NULL OR join_date IS NULL)
FROM customers
UNION ALL
SELECT 'stores', COUNT(*), SUM(store_id IS NULL OR store_name IS NULL OR city IS NULL OR country IS NULL OR store_type IS NULL)
FROM stores
UNION ALL
SELECT 'calendar', COUNT(*), SUM(`date` IS NULL OR `year` IS NULL OR `month` IS NULL OR `day` IS NULL OR `week` IS NULL OR `day_of_week` IS NULL)
FROM calendar;

-- =============================================================================
-- SECTION 2: CANDIDATE KEY UNIQUENESS & GRAIN VALIDATION
-- =============================================================================

-- Q: Does each primary key candidate uniquely identify each record with zero duplicates?
SELECT
    'sales.order_id' AS key_name,
    COUNT(DISTINCT order_id) AS unique_keys,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_rows
FROM sales
UNION ALL
SELECT 'products.product_id', COUNT(DISTINCT product_id), COUNT(*), COUNT(*) - COUNT(DISTINCT product_id) FROM products
UNION ALL
SELECT 'customers.customer_id', COUNT(DISTINCT customer_id), COUNT(*), COUNT(*) - COUNT(DISTINCT customer_id) FROM customers
UNION ALL
SELECT 'stores.store_id', COUNT(DISTINCT store_id), COUNT(*), COUNT(*) - COUNT(DISTINCT store_id) FROM stores
UNION ALL
SELECT 'calendar.date', COUNT(DISTINCT `date`), COUNT(*), COUNT(*) - COUNT(DISTINCT `date`) FROM calendar;

-- =============================================================================
-- SECTION 3: REFERENTIAL INTEGRITY & ORPHAN KEY AUDITING
-- =============================================================================

-- Q: How many sales records reference dimension keys that do not exist in the dimension tables?
SELECT
    COUNT(*) AS total_sales,
    SUM(CASE WHEN c.customer_id IS NULL THEN 1 ELSE 0 END) AS orphan_customer_sales,
    SUM(CASE WHEN st.store_id IS NULL THEN 1 ELSE 0 END)   AS orphan_store_sales,
    SUM(CASE WHEN ca.`date` IS NULL THEN 1 ELSE 0 END)     AS orphan_date_sales,
    SUM(CASE WHEN p.product_id IS NULL THEN 1 ELSE 0 END)  AS orphan_product_sales
FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN stores st   ON s.store_id = st.store_id
LEFT JOIN calendar ca ON s.order_date = ca.`date`
LEFT JOIN products p  ON s.product_id = p.product_id;

-- Q: What are the exact orphan product IDs in sales, how many transactions do they affect,
--    and what revenue and profit do they represent?
SELECT
    s.product_id,
    COUNT(*)                     AS affected_transactions,
    ROUND(SUM(s.quantity), 0)    AS total_units,
    ROUND(SUM(s.revenue), 2)     AS orphan_revenue,
    ROUND(SUM(s.profit), 2)      AS orphan_profit,
    ROUND(AVG(s.unit_price), 2)  AS avg_unit_price,
    ROUND(AVG(s.discount) * 100, 2) AS avg_discount_pct
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL
GROUP BY s.product_id
ORDER BY s.product_id;

-- =============================================================================
-- SECTION 4: MATHEMATICAL CALCULATION DISCREPANCIES (ONE-CENT vs > ONE-CENT)
-- =============================================================================

-- Q: How do source revenue values compare against `ROUND(quantity * unit_price * (1 - discount), 2)`?
--    We evaluate:
--    - Exact match (difference = 0.00)
--    - Exact negative one-cent mismatch (calc - source = -0.01)
--    - Exact positive one-cent mismatch (calc - source = +0.01)
--    - Severe mismatch (|calc - source| > 0.01)
WITH revenue_audit AS (
    SELECT
        order_id,
        revenue AS recorded_revenue,
        ROUND(quantity * unit_price * (1.0 - discount), 2) AS calculated_revenue,
        ROUND(ROUND(quantity * unit_price * (1.0 - discount), 2) - revenue, 2) AS diff
    FROM sales
)
SELECT
    CASE
        WHEN diff = 0.00   THEN '01. Exact Match (diff = $0.00)'
        WHEN diff = -0.01  THEN '02. Under-calculated by 1 cent (diff = -$0.01)'
        WHEN diff = 0.01   THEN '03. Over-calculated by 1 cent (diff = +$0.01)'
        WHEN ABS(diff) > 0.01 THEN '04. Severe discrepancy (|diff| > $0.01)'
        ELSE '05. Other minor variance'
    END AS discrepancy_category,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) / 1000000.0 * 100, 3) AS pct_of_total_sales
FROM revenue_audit
GROUP BY discrepancy_category
ORDER BY discrepancy_category;

-- Q: How do source profit values compare against `ROUND(revenue - cost, 2)`?
WITH profit_audit AS (
    SELECT
        order_id,
        profit AS recorded_profit,
        ROUND(revenue - cost, 2) AS calculated_profit,
        ROUND(ROUND(revenue - cost, 2) - profit, 2) AS diff
    FROM sales
)
SELECT
    CASE
        WHEN diff = 0.00   THEN '01. Exact Match (diff = $0.00)'
        WHEN diff = -0.01  THEN '02. Under-calculated by 1 cent (diff = -$0.01)'
        WHEN diff = 0.01   THEN '03. Over-calculated by 1 cent (diff = +$0.01)'
        WHEN ABS(diff) > 0.01 THEN '04. Severe discrepancy (|diff| > $0.01)'
        ELSE '05. Other minor variance'
    END AS discrepancy_category,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) / 1000000.0 * 100, 3) AS pct_of_total_sales
FROM profit_audit
GROUP BY discrepancy_category
ORDER BY discrepancy_category;

-- =============================================================================
-- SECTION 5: GEOGRAPHIC DISCORDANCE AUDITING (STORES)
-- =============================================================================

-- Q: How many store records have cities assigned to discordant countries in the source data?
--    Real-world mappings:
--    Berlin -> Germany, London -> UK, Melbourne -> Australia, New York -> USA,
--    Paris -> France, Sydney -> Australia, Toronto -> Canada
WITH geo_audit AS (
    SELECT
        store_id,
        store_name,
        city,
        country,
        CASE
            WHEN city = 'Berlin'    AND country = 'Germany'   THEN 'Consistent'
            WHEN city = 'London'    AND country = 'UK'        THEN 'Consistent'
            WHEN city = 'Melbourne' AND country = 'Australia' THEN 'Consistent'
            WHEN city = 'New York'  AND country = 'USA'       THEN 'Consistent'
            WHEN city = 'Paris'     AND country = 'France'    THEN 'Consistent'
            WHEN city = 'Sydney'    AND country = 'Australia' THEN 'Consistent'
            WHEN city = 'Toronto'   AND country = 'Canada'    THEN 'Consistent'
            ELSE 'Discordant / Mismatched'
        END AS mapping_status
    FROM stores
)
SELECT
    mapping_status,
    COUNT(*) AS store_count,
    ROUND(COUNT(*) / 100.0 * 100, 1) AS pct_of_stores
FROM geo_audit
GROUP BY mapping_status;
