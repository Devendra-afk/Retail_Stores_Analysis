-- =============================================================================
-- 04_store_performance.sql
-- Store-level performance analysis by city, country, and store type
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: CITY-WISE PERFORMANCE
-- =============================================================================

-- Q: What is the revenue, profit, and store count for each city?
SELECT
    st.city,
    st.country,
    COUNT(DISTINCT st.store_id)  AS store_count,
    COUNT(DISTINCT s.order_id)   AS total_orders,
    SUM(s.quantity)               AS total_quantity,
    ROUND(SUM(s.revenue), 2)     AS total_revenue,
    ROUND(SUM(s.profit), 2)      AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT st.store_id), 2) AS revenue_per_store,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS city_rank
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.city, st.country
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 2: STORE TYPE COMPARISON
-- =============================================================================

-- Q: How do different store types compare in revenue, profit, and per-store metrics?
SELECT
    st.store_type,
    COUNT(DISTINCT st.store_id)  AS store_count,
    COUNT(DISTINCT s.order_id)   AS total_orders,
    SUM(s.quantity)               AS total_quantity,
    ROUND(SUM(s.revenue), 2)     AS total_revenue,
    ROUND(SUM(s.profit), 2)      AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT st.store_id), 2) AS revenue_per_store,
    ROUND(SUM(s.profit) / COUNT(DISTINCT st.store_id), 2)  AS profit_per_store,
    ROUND(SUM(s.quantity) / COUNT(DISTINCT st.store_id), 2) AS quantity_per_store,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_type
ORDER BY total_revenue DESC;

-- Q: What is the average order value by store type?
WITH store_type_orders AS (
    SELECT
        st.store_type,
        s.order_id,
        SUM(s.revenue) AS order_revenue
    FROM sales s
    INNER JOIN stores st ON s.store_id = st.store_id
    GROUP BY st.store_type, s.order_id
)
SELECT
    store_type,
    COUNT(*)                     AS total_orders,
    ROUND(AVG(order_revenue), 2) AS avg_order_value,
    ROUND(MIN(order_revenue), 2) AS min_order_value,
    ROUND(MAX(order_revenue), 2) AS max_order_value
FROM store_type_orders
GROUP BY store_type
ORDER BY avg_order_value DESC;

-- =============================================================================
-- SECTION 3: CITY-COUNTRY MISMATCH FLAGGING
-- =============================================================================

-- Q: Are there any stores where the same city appears under multiple countries (possible data quality issue)?
SELECT
    city,
    COUNT(DISTINCT country) AS country_count,
    GROUP_CONCAT(DISTINCT country ORDER BY country SEPARATOR ', ') AS countries
FROM stores
GROUP BY city
HAVING COUNT(DISTINCT country) > 1
ORDER BY city;

-- =============================================================================
-- SECTION 4: TOP STORES
-- =============================================================================

-- Q: What are the top 10 stores by total revenue?
SELECT
    st.store_id,
    st.store_name,
    st.city,
    st.country,
    st.store_type,
    COUNT(DISTINCT s.order_id)  AS total_orders,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS store_rank
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_id, st.store_name, st.city, st.country, st.store_type
ORDER BY total_revenue DESC
LIMIT 10;

-- Q: What are the top 10 stores by total profit?
SELECT
    st.store_id,
    st.store_name,
    st.city,
    st.country,
    st.store_type,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (ORDER BY SUM(s.profit) DESC) AS profit_rank
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_id, st.store_name, st.city, st.country, st.store_type
ORDER BY total_profit DESC
LIMIT 10;

-- Q: Which stores underperform relative to the average revenue per store in their city?
WITH store_revenue AS (
    SELECT
        st.store_id,
        st.store_name,
        st.city,
        st.store_type,
        ROUND(SUM(s.revenue), 2) AS total_revenue
    FROM sales s
    INNER JOIN stores st ON s.store_id = st.store_id
    GROUP BY st.store_id, st.store_name, st.city, st.store_type
),
city_avg AS (
    SELECT
        city,
        ROUND(AVG(total_revenue), 2) AS avg_city_revenue
    FROM store_revenue
    GROUP BY city
)
SELECT
    sr.store_id,
    sr.store_name,
    sr.city,
    sr.store_type,
    sr.total_revenue,
    ca.avg_city_revenue,
    ROUND(sr.total_revenue - ca.avg_city_revenue, 2) AS delta_from_avg
FROM store_revenue sr
INNER JOIN city_avg ca ON sr.city = ca.city
WHERE sr.total_revenue < ca.avg_city_revenue
ORDER BY delta_from_avg ASC;
