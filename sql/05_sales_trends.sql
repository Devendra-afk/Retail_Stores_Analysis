-- =============================================================================
-- 05_sales_trends.sql
-- Time-based sales analysis: monthly trends, YoY comparisons, weekday and
-- holiday performance
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: MONTHLY REVENUE & PROFIT TRENDS
-- =============================================================================

-- Q: What are the monthly revenue and profit trends over time?
SELECT
    YEAR(s.order_date)  AS sales_year,
    MONTH(s.order_date) AS sales_month,
    COUNT(DISTINCT s.order_id)  AS total_orders,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin_pct
FROM sales s
GROUP BY YEAR(s.order_date), MONTH(s.order_date)
ORDER BY sales_year, sales_month;

-- Q: What is the month-over-month revenue growth rate?
WITH monthly_revenue AS (
    SELECT
        YEAR(s.order_date)  AS sales_year,
        MONTH(s.order_date) AS sales_month,
        ROUND(SUM(s.revenue), 2) AS total_revenue
    FROM sales s
    GROUP BY YEAR(s.order_date), MONTH(s.order_date)
    ORDER BY sales_year, sales_month
)
SELECT
    sales_year,
    sales_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY sales_year, sales_month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY sales_year, sales_month))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY sales_year, sales_month), 0) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY sales_year, sales_month;

-- =============================================================================
-- SECTION 2: 2023 vs 2024 YEAR-OVER-YEAR COMPARISON
-- =============================================================================

-- Q: How does 2024 compare to 2023 on a monthly basis with growth percentages?
WITH yearly_monthly AS (
    SELECT
        YEAR(s.order_date)  AS sales_year,
        MONTH(s.order_date) AS sales_month,
        ROUND(SUM(s.revenue), 2)  AS total_revenue,
        ROUND(SUM(s.profit), 2)   AS total_profit,
        SUM(s.quantity)            AS total_quantity,
        COUNT(DISTINCT s.order_id) AS total_orders
    FROM sales s
    WHERE YEAR(s.order_date) IN (2023, 2024)
    GROUP BY YEAR(s.order_date), MONTH(s.order_date)
),
pivoted AS (
    SELECT
        sales_month,
        MAX(CASE WHEN sales_year = 2023 THEN total_revenue END) AS revenue_2023,
        MAX(CASE WHEN sales_year = 2024 THEN total_revenue END) AS revenue_2024,
        MAX(CASE WHEN sales_year = 2023 THEN total_profit END)  AS profit_2023,
        MAX(CASE WHEN sales_year = 2024 THEN total_profit END)  AS profit_2024,
        MAX(CASE WHEN sales_year = 2023 THEN total_orders END)  AS orders_2023,
        MAX(CASE WHEN sales_year = 2024 THEN total_orders END)  AS orders_2024
    FROM yearly_monthly
    GROUP BY sales_month
)
SELECT
    sales_month,
    revenue_2023,
    revenue_2024,
    ROUND(
        (revenue_2024 - revenue_2023) / NULLIF(revenue_2023, 0) * 100, 2
    ) AS revenue_growth_pct,
    profit_2023,
    profit_2024,
    ROUND(
        (profit_2024 - profit_2023) / NULLIF(profit_2023, 0) * 100, 2
    ) AS profit_growth_pct,
    orders_2023,
    orders_2024
FROM pivoted
ORDER BY sales_month;

-- Q: What is the overall annual comparison between 2023 and 2024?
SELECT
    YEAR(s.order_date) AS sales_year,
    COUNT(DISTINCT s.order_id) AS total_orders,
    SUM(s.quantity)             AS total_quantity,
    ROUND(SUM(s.revenue), 2)   AS total_revenue,
    ROUND(SUM(s.profit), 2)    AS total_profit,
    ROUND(AVG(s.revenue), 2)   AS avg_revenue_per_sale
FROM sales s
WHERE YEAR(s.order_date) IN (2023, 2024)
GROUP BY YEAR(s.order_date)
ORDER BY sales_year;

-- =============================================================================
-- SECTION 3: WEEKDAY PERFORMANCE
-- =============================================================================

-- Q: Which day of the week generates the most revenue and orders?
SELECT
    ca.day_of_week,
    COUNT(DISTINCT s.order_id)  AS total_orders,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(AVG(s.revenue), 2)    AS avg_revenue_per_sale,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS day_rank
FROM sales s
INNER JOIN calendar ca ON s.order_date = ca.`date`
GROUP BY ca.day_of_week
ORDER BY total_revenue DESC;

-- Q: How does weekday vs weekend performance compare?
SELECT
    CASE
        WHEN ca.day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT s.order_id)  AS total_orders,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    ROUND(AVG(s.revenue), 2)    AS avg_revenue_per_sale
FROM sales s
INNER JOIN calendar ca ON s.order_date = ca.`date`
GROUP BY day_type
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 4: HOLIDAY PERIOD ANALYSIS
-- =============================================================================

-- Q: How does revenue perform during the Christmas period (Dec 20-26) compared to non-holiday December?
WITH december_sales AS (
    SELECT
        s.order_id,
        s.order_date,
        s.revenue,
        s.profit,
        s.quantity,
        CASE
            WHEN DAY(s.order_date) BETWEEN 20 AND 26 THEN 'Christmas (Dec 20-26)'
            ELSE 'Other December'
        END AS period
    FROM sales s
    WHERE MONTH(s.order_date) = 12
)
SELECT
    period,
    COUNT(DISTINCT order_id)  AS total_orders,
    SUM(quantity)              AS total_quantity,
    ROUND(SUM(revenue), 2)    AS total_revenue,
    ROUND(SUM(profit), 2)     AS total_profit,
    ROUND(AVG(revenue), 2)    AS avg_revenue_per_sale
FROM december_sales
GROUP BY period
ORDER BY period;

-- Q: How does Thanksgiving week (US: 4th Thursday of November, approx Nov 22-28) affect sales?
WITH november_sales AS (
    SELECT
        s.order_id,
        s.order_date,
        s.revenue,
        s.profit,
        s.quantity,
        CASE
            WHEN DAY(s.order_date) BETWEEN 22 AND 28 THEN 'Thanksgiving Week (Nov 22-28)'
            ELSE 'Other November'
        END AS period
    FROM sales s
    WHERE MONTH(s.order_date) = 11
)
SELECT
    period,
    COUNT(DISTINCT order_id)  AS total_orders,
    SUM(quantity)              AS total_quantity,
    ROUND(SUM(revenue), 2)    AS total_revenue,
    ROUND(SUM(profit), 2)     AS total_profit,
    ROUND(AVG(revenue), 2)    AS avg_revenue_per_sale
FROM november_sales
GROUP BY period
ORDER BY period;

-- Q: How do holiday months (November, December) compare to non-holiday months?
SELECT
    CASE
        WHEN MONTH(s.order_date) IN (11, 12) THEN 'Holiday Months (Nov-Dec)'
        ELSE 'Non-Holiday Months'
    END AS season,
    YEAR(s.order_date)              AS sales_year,
    COUNT(DISTINCT s.order_id)      AS total_orders,
    SUM(s.quantity)                  AS total_quantity,
    ROUND(SUM(s.revenue), 2)        AS total_revenue,
    ROUND(SUM(s.profit), 2)         AS total_profit,
    ROUND(AVG(s.revenue), 2)        AS avg_revenue_per_sale
FROM sales s
GROUP BY season, YEAR(s.order_date)
ORDER BY sales_year, season;
