-- =============================================================================
-- 02_product_brand_analysis.sql
-- Product, Brand, Category, & Attribute Performance Analysis
-- Retail Stores Sales Analysis (2023-2024)
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: TOP 10 PRODUCTS BY REVENUE, QUANTITY, AND PROFIT
-- =============================================================================

-- Q: What are the top 10 products by total gross revenue, including their brand and category?
WITH product_revenue_ranked AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category,
        SUM(s.quantity)                                                AS total_units_sold,
        ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
        ROUND(SUM(s.profit), 2)                                       AS total_profit,
        ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
        RANK() OVER (ORDER BY SUM(s.revenue) DESC)                     AS revenue_rank
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand, p.category
)
SELECT *
FROM product_revenue_ranked
WHERE revenue_rank <= 10
ORDER BY revenue_rank;

-- Q: What are the top 10 products by total volume (quantity sold)?
WITH product_quantity_ranked AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category,
        SUM(s.quantity)                                                AS total_units_sold,
        ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
        ROUND(SUM(s.profit), 2)                                       AS total_profit,
        RANK() OVER (ORDER BY SUM(s.quantity) DESC)                    AS quantity_rank
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand, p.category
)
SELECT *
FROM product_quantity_ranked
WHERE quantity_rank <= 10
ORDER BY quantity_rank;

-- Q: What are the top 10 products by total operating profit?
WITH product_profit_ranked AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category,
        SUM(s.quantity)                                                AS total_units_sold,
        ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
        ROUND(SUM(s.profit), 2)                                       AS total_profit,
        ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
        RANK() OVER (ORDER BY SUM(s.profit) DESC)                     AS profit_rank
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand, p.category
)
SELECT *
FROM product_profit_ranked
WHERE profit_rank <= 10
ORDER BY profit_rank;

-- =============================================================================
-- SECTION 2: BRAND-LEVEL PERFORMANCE & COMPARISON
-- =============================================================================

-- Q: How do the six confectionery brands compare in volume, revenue, profit, margin,
--    and average revenue per SKU (including orphan keys as 'Unassigned')?
SELECT
    COALESCE(p.brand, 'Unassigned / Orphan Keys')                  AS brand_name,
    COUNT(DISTINCT s.product_id)                                  AS active_sku_count,
    COUNT(DISTINCT s.order_id)                                    AS total_orders,
    SUM(s.quantity)                                                AS total_units_sold,
    ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
    ROUND(SUM(s.profit), 2)                                       AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.product_id), 2)       AS avg_revenue_per_sku,
    ROUND(SUM(s.quantity) / COUNT(DISTINCT s.product_id), 1)      AS avg_units_per_sku
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
GROUP BY COALESCE(p.brand, 'Unassigned / Orphan Keys')
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 3: CATEGORY-LEVEL PERFORMANCE
-- =============================================================================

-- Q: How does demand and profitability distribute across chocolate categories?
SELECT
    COALESCE(p.category, 'Unassigned')                            AS category_name,
    COUNT(DISTINCT s.product_id)                                  AS sku_count,
    SUM(s.quantity)                                                AS total_units_sold,
    ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
    ROUND(SUM(s.profit), 2)                                       AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.product_id), 2)       AS avg_revenue_per_sku,
    ROUND(SUM(s.revenue) / 25486128.86 * 100, 2)                  AS pct_portfolio_revenue
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
GROUP BY COALESCE(p.category, 'Unassigned')
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 4: PRODUCT ATTRIBUTE ANALYSIS (WEIGHT & COCOA %)
-- =============================================================================

-- Q: How does product weight (in grams) associate with total sales and average revenue per SKU?
SELECT
    p.weight_g,
    COUNT(DISTINCT p.product_id)                                  AS sku_count,
    SUM(s.quantity)                                                AS total_units_sold,
    ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
    ROUND(SUM(s.profit), 2)                                       AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT p.product_id), 2)       AS avg_revenue_per_sku,
    ROUND(SUM(s.quantity) / COUNT(DISTINCT p.product_id), 1)      AS avg_units_per_sku
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.weight_g
ORDER BY p.weight_g ASC;

-- Q: How does cocoa solids percentage relate to demand, revenue velocity, and margins?
SELECT
    p.cocoa_percent,
    COUNT(DISTINCT p.product_id)                                  AS sku_count,
    SUM(s.quantity)                                                AS total_units_sold,
    ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
    ROUND(SUM(s.profit), 2)                                       AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT p.product_id), 2)       AS avg_revenue_per_sku,
    ROUND(SUM(s.quantity) / COUNT(DISTINCT p.product_id), 1)      AS avg_units_per_sku
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.cocoa_percent
ORDER BY p.cocoa_percent ASC;

-- Q: What is the average list price and discount across chocolate categories?
SELECT
    p.category,
    ROUND(AVG(s.unit_price), 2)  AS avg_unit_price,
    ROUND(MIN(s.unit_price), 2)  AS min_unit_price,
    ROUND(MAX(s.unit_price), 2)  AS max_unit_price,
    ROUND(AVG(s.discount) * 100, 2) AS avg_discount_pct
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_unit_price DESC;
