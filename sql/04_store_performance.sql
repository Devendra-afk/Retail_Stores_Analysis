-- =============================================================================
-- 04_store_performance.sql
-- Store Channel, Operating Model, & Geographical Performance Analysis
-- Retail Stores Sales Analysis (2023-2024)
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: STORE CHANNEL OPERATING MODEL COMPARISON
-- =============================================================================

-- Q: How do the four retail formats (Airport, Mall, Online, Retail) compare in total revenue,
--    profitability, and individual store productivity?
SELECT
    st.store_type,
    COUNT(DISTINCT st.store_id)                                   AS store_count,
    COUNT(DISTINCT s.order_id)                                    AS total_orders,
    SUM(s.quantity)                                                AS total_units_sold,
    ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
    ROUND(SUM(s.profit), 2)                                       AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)     AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT st.store_id), 2)        AS revenue_per_store,
    ROUND(SUM(s.profit) / COUNT(DISTINCT st.store_id), 2)         AS profit_per_store,
    ROUND(COUNT(DISTINCT s.order_id) * 1.0 / COUNT(DISTINCT st.store_id), 0) AS orders_per_store,
    ROUND(SUM(s.revenue) / 25486128.86 * 100, 2)                  AS pct_total_revenue
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_type
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 2: TOP & BOTTOM PERFORMING STORES
-- =============================================================================

-- Q: Which are the top 10 most profitable individual stores across the network?
WITH store_ranking AS (
    SELECT
        st.store_id,
        st.store_name,
        st.city,
        st.country,
        st.store_type,
        COUNT(DISTINCT s.order_id)                                AS total_orders,
        ROUND(SUM(s.revenue), 2)                                  AS total_revenue,
        ROUND(SUM(s.profit), 2)                                   AS total_profit,
        ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct,
        RANK() OVER (ORDER BY SUM(s.profit) DESC)                 AS profit_rank
    FROM sales s
    INNER JOIN stores st ON s.store_id = st.store_id
    GROUP BY st.store_id, st.store_name, st.city, st.country, st.store_type
)
SELECT *
FROM store_ranking
WHERE profit_rank <= 10
ORDER BY profit_rank ASC;

-- =============================================================================
-- SECTION 3: CITY-LEVEL SALES VOLUME (REPORTED STORE CITY)
-- =============================================================================

-- Q: What is the total sales volume, revenue, and store count for each metropolitan market?
SELECT
    st.city,
    COUNT(DISTINCT st.store_id)                                   AS store_count,
    COUNT(DISTINCT s.order_id)                                    AS total_orders,
    SUM(s.quantity)                                                AS total_units_sold,
    ROUND(SUM(s.revenue), 2)                                      AS total_revenue,
    ROUND(SUM(s.profit), 2)                                       AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT st.store_id), 2)        AS revenue_per_store,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC)                     AS city_revenue_rank
FROM sales s
INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY st.city
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 4: STORE FORMAT PERFORMANCE WITHIN EACH CITY
-- =============================================================================

-- Q: Which store formats generate the highest revenue within each city?
WITH city_format AS (
    SELECT
        st.city,
        st.store_type,
        COUNT(DISTINCT st.store_id)                                AS stores,
        ROUND(SUM(s.revenue), 2)                                  AS format_revenue,
        ROUND(SUM(s.profit), 2)                                   AS format_profit,
        RANK() OVER (PARTITION BY st.city ORDER BY SUM(s.revenue) DESC) AS rank_in_city
    FROM sales s
    INNER JOIN stores st ON s.store_id = st.store_id
    GROUP BY st.city, st.store_type
)
SELECT *
FROM city_format
ORDER BY city ASC, rank_in_city ASC;
