-- =============================================================================
-- 02_product_brand_analysis.sql
-- Product and brand performance analysis using JOINs, CTEs, and window functions
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: TOP 10 PRODUCTS
-- =============================================================================

-- Q: What are the top 10 products by total revenue?
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category,
        SUM(s.revenue)  AS total_revenue,
        SUM(s.quantity)  AS total_quantity,
        SUM(s.profit)   AS total_profit,
        RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS revenue_rank
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand, p.category
)
SELECT *
FROM product_revenue
WHERE revenue_rank <= 10
ORDER BY revenue_rank;

-- Q: What are the top 10 products by total quantity sold?
WITH product_quantity AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category,
        SUM(s.quantity)  AS total_quantity,
        SUM(s.revenue)   AS total_revenue,
        RANK() OVER (ORDER BY SUM(s.quantity) DESC) AS quantity_rank
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand, p.category
)
SELECT *
FROM product_quantity
WHERE quantity_rank <= 10
ORDER BY quantity_rank;

-- Q: What are the top 10 products by total profit?
WITH product_profit AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category,
        SUM(s.profit)    AS total_profit,
        SUM(s.revenue)   AS total_revenue,
        SUM(s.quantity)   AS total_quantity,
        RANK() OVER (ORDER BY SUM(s.profit) DESC) AS profit_rank
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand, p.category
)
SELECT *
FROM product_profit
WHERE profit_rank <= 10
ORDER BY profit_rank;

-- =============================================================================
-- SECTION 2: BRAND PERFORMANCE
-- =============================================================================

-- Q: How does each brand perform in terms of revenue, quantity, and profit?
SELECT
    p.brand,
    COUNT(DISTINCT p.product_id) AS product_count,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS brand_rank
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.brand
ORDER BY total_revenue DESC;

-- Q: What is the average revenue per product for each brand?
WITH brand_product_revenue AS (
    SELECT
        p.brand,
        p.product_id,
        SUM(s.revenue) AS product_revenue
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.brand, p.product_id
)
SELECT
    brand,
    COUNT(product_id)                   AS num_products,
    ROUND(SUM(product_revenue), 2)      AS total_revenue,
    ROUND(AVG(product_revenue), 2)      AS avg_revenue_per_product
FROM brand_product_revenue
GROUP BY brand
ORDER BY avg_revenue_per_product DESC;

-- =============================================================================
-- SECTION 3: CATEGORY PERFORMANCE
-- =============================================================================

-- Q: How does each product category perform in revenue, quantity, and profit?
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS product_count,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS category_rank
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 4: COCOA PERCENTAGE ANALYSIS
-- =============================================================================

-- Q: Does cocoa percentage affect product revenue and profitability?
WITH cocoa_buckets AS (
    SELECT
        p.product_id,
        p.product_name,
        p.cocoa_percent,
        CASE
            WHEN p.cocoa_percent < 40  THEN 'Low (<40%)'
            WHEN p.cocoa_percent < 60  THEN 'Medium (40-59%)'
            WHEN p.cocoa_percent < 80  THEN 'High (60-79%)'
            ELSE 'Very High (80%+)'
        END AS cocoa_group,
        s.revenue,
        s.profit,
        s.quantity
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
)
SELECT
    cocoa_group,
    COUNT(DISTINCT product_id)   AS product_count,
    SUM(quantity)                 AS total_quantity,
    ROUND(SUM(revenue), 2)       AS total_revenue,
    ROUND(SUM(profit), 2)        AS total_profit,
    ROUND(AVG(revenue), 2)       AS avg_revenue_per_sale,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM cocoa_buckets
GROUP BY cocoa_group
ORDER BY total_revenue DESC;

-- Q: What are the top 10 products by revenue within each cocoa percentage group?
WITH ranked_products AS (
    SELECT
        p.product_id,
        p.product_name,
        p.cocoa_percent,
        CASE
            WHEN p.cocoa_percent < 40  THEN 'Low (<40%)'
            WHEN p.cocoa_percent < 60  THEN 'Medium (40-59%)'
            WHEN p.cocoa_percent < 80  THEN 'High (60-79%)'
            ELSE 'Very High (80%+)'
        END AS cocoa_group,
        SUM(s.revenue) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY CASE
                WHEN p.cocoa_percent < 40  THEN 'Low (<40%)'
                WHEN p.cocoa_percent < 60  THEN 'Medium (40-59%)'
                WHEN p.cocoa_percent < 80  THEN 'High (60-79%)'
                ELSE 'Very High (80%+)'
            END
            ORDER BY SUM(s.revenue) DESC
        ) AS rn
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.cocoa_percent
)
SELECT cocoa_group, product_id, product_name, cocoa_percent, total_revenue
FROM ranked_products
WHERE rn <= 10
ORDER BY cocoa_group, rn;

-- =============================================================================
-- SECTION 5: WEIGHT-WISE ANALYSIS
-- =============================================================================

-- Q: How does product weight affect revenue and profitability?
WITH weight_buckets AS (
    SELECT
        p.product_id,
        p.weight_g,
        CASE
            WHEN p.weight_g < 50   THEN 'Light (<50g)'
            WHEN p.weight_g < 100  THEN 'Medium (50-99g)'
            WHEN p.weight_g < 200  THEN 'Heavy (100-199g)'
            ELSE 'Very Heavy (200g+)'
        END AS weight_group,
        s.revenue,
        s.profit,
        s.quantity
    FROM sales s
    INNER JOIN products p ON s.product_id = p.product_id
)
SELECT
    weight_group,
    COUNT(DISTINCT product_id)   AS product_count,
    SUM(quantity)                 AS total_quantity,
    ROUND(SUM(revenue), 2)       AS total_revenue,
    ROUND(SUM(profit), 2)        AS total_profit,
    ROUND(AVG(revenue), 2)       AS avg_revenue_per_sale,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM weight_buckets
GROUP BY weight_group
ORDER BY total_revenue DESC;
