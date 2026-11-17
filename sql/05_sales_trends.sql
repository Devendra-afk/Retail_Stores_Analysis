-- =============================================================================
-- 05_sales_trends.sql
-- Temporal Analysis, Intra-Week Seasonality, YoY Growth, & Holiday Impact
-- Retail Stores Sales Analysis (2023-2024)
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: MONTHLY SALES TRENDS & YEAR-OVER-YEAR PACING
-- =============================================================================

-- Q: What are the monthly revenue, profit, order volume, and profit margin trends across 2023 and 2024?
SELECT
    YEAR(s.order_date)                                             AS sales_year,
    MONTH(s.order_date)                                            AS sales_month,
    COUNT(DISTINCT s.order_date)                                   AS days_in_month,
    COUNT(DISTINCT s.order_id)                                     AS total_orders,
    SUM(s.quantity)                                                 AS total_units,
    ROUND(SUM(s.revenue), 2)                                       AS total_revenue,
    ROUND(SUM(s.profit), 2)                                        AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)      AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.order_date), 2)        AS avg_daily_revenue
FROM sales s
GROUP BY YEAR(s.order_date), MONTH(s.order_date)
ORDER BY sales_year ASC, sales_month ASC;

-- Q: How does monthly performance compare Year-over-Year (2023 vs 2024) with growth rates?
WITH monthly_metrics AS (
    SELECT
        MONTH(s.order_date)  AS month_num,
        YEAR(s.order_date)   AS sales_year,
        SUM(s.revenue)       AS total_revenue,
        SUM(s.profit)        AS total_profit,
        COUNT(DISTINCT s.order_id) AS total_orders
    FROM sales s
    GROUP BY MONTH(s.order_date), YEAR(s.order_date)
),
pivoted_monthly AS (
    SELECT
        month_num,
        ROUND(MAX(CASE WHEN sales_year = 2023 THEN total_revenue END), 2) AS rev_2023,
        ROUND(MAX(CASE WHEN sales_year = 2024 THEN total_revenue END), 2) AS rev_2024,
        ROUND(MAX(CASE WHEN sales_year = 2023 THEN total_profit END), 2)  AS prof_2023,
        ROUND(MAX(CASE WHEN sales_year = 2024 THEN total_profit END), 2)  AS prof_2024,
        MAX(CASE WHEN sales_year = 2023 THEN total_orders END)            AS orders_2023,
        MAX(CASE WHEN sales_year = 2024 THEN total_orders END)            AS orders_2024
    FROM monthly_metrics
    GROUP BY month_num
)
SELECT
    month_num,
    rev_2023,
    rev_2024,
    ROUND(rev_2024 - rev_2023, 2) AS revenue_growth_dollars,
    ROUND((rev_2024 - rev_2023) / NULLIF(rev_2023, 0) * 100, 2) AS revenue_growth_pct,
    prof_2023,
    prof_2024,
    ROUND((prof_2024 - prof_2023) / NULLIF(prof_2023, 0) * 100, 2) AS profit_growth_pct,
    orders_2023,
    orders_2024
FROM pivoted_monthly
ORDER BY month_num ASC;

-- Q: What is the full-year comparison between 2023 and 2024?
SELECT
    YEAR(s.order_date)                                             AS sales_year,
    COUNT(DISTINCT s.order_date)                                   AS total_days,
    COUNT(DISTINCT s.order_id)                                     AS total_orders,
    SUM(s.quantity)                                                 AS total_units,
    ROUND(SUM(s.revenue), 2)                                       AS total_revenue,
    ROUND(SUM(s.profit), 2)                                        AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2)      AS profit_margin_pct,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.order_date), 2)        AS avg_daily_revenue,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.order_id), 2)          AS average_order_value
FROM sales s
GROUP BY YEAR(s.order_date)
ORDER BY sales_year ASC;

-- =============================================================================
-- SECTION 2: INTRA-WEEK SEASONALITY (DAY OF WEEK ANALYSIS)
-- Note: calendar.day_of_week is integer:
--   0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday, 5=Saturday, 6=Sunday
-- =============================================================================

-- Q: Which day of the week generates the highest daily revenue, profit, and order velocity?
--    Calculates average daily revenue (SUM / unique days) rather than line-item average.
SELECT
    ca.day_of_week,
    CASE ca.day_of_week
        WHEN 0 THEN 'Monday'
        WHEN 1 THEN 'Tuesday'
        WHEN 2 THEN 'Wednesday'
        WHEN 3 THEN 'Thursday'
        WHEN 4 THEN 'Friday'
        WHEN 5 THEN 'Saturday'
        WHEN 6 THEN 'Sunday'
    END AS day_name,
    COUNT(DISTINCT ca.`date`)                                      AS total_days_in_period,
    COUNT(DISTINCT s.order_id)                                     AS total_orders,
    SUM(s.quantity)                                                 AS total_units,
    ROUND(SUM(s.revenue), 2)                                       AS total_revenue,
    ROUND(SUM(s.profit), 2)                                        AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT ca.`date`), 2)           AS avg_daily_revenue,
    ROUND(SUM(s.profit) / COUNT(DISTINCT ca.`date`), 2)            AS avg_daily_profit,
    ROUND(COUNT(DISTINCT s.order_id) * 1.0 / COUNT(DISTINCT ca.`date`), 1) AS avg_daily_orders,
    RANK() OVER (ORDER BY SUM(s.revenue) / COUNT(DISTINCT ca.`date`) DESC) AS day_rank
FROM sales s
INNER JOIN calendar ca ON s.order_date = ca.`date`
GROUP BY ca.day_of_week
ORDER BY ca.day_of_week ASC;

-- Q: How does weekend (Saturday & Sunday) performance compare against weekdays (Monday-Friday)?
SELECT
    CASE
        WHEN ca.day_of_week IN (5, 6) THEN 'Weekend (Sat-Sun)'
        ELSE 'Weekday (Mon-Fri)'
    END AS day_type,
    COUNT(DISTINCT ca.`date`)                                      AS total_calendar_days,
    COUNT(DISTINCT s.order_id)                                     AS total_orders,
    SUM(s.quantity)                                                 AS total_units,
    ROUND(SUM(s.revenue), 2)                                       AS total_revenue,
    ROUND(SUM(s.profit), 2)                                        AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT ca.`date`), 2)           AS avg_daily_revenue,
    ROUND(SUM(s.profit) / COUNT(DISTINCT ca.`date`), 2)            AS avg_daily_profit,
    ROUND(COUNT(DISTINCT s.order_id) * 1.0 / COUNT(DISTINCT ca.`date`), 1) AS avg_daily_orders
FROM sales s
INNER JOIN calendar ca ON s.order_date = ca.`date`
GROUP BY day_type
ORDER BY day_type ASC;

-- =============================================================================
-- SECTION 3: HOLIDAY WINDOW IMPACT ANALYSIS (CHRISTMAS & THANKSGIVING)
-- Methodology:
-- - Christmas Window: Dec 20 to Dec 26 (7 days/yr = 14 total days across 2023 & 2024)
-- - Thanksgiving Window: 7-day window centered on US Thanksgiving (date ± 3 days):
--     * 2023 Thanksgiving (Nov 23): Nov 20 to Nov 26 (7 days)
--     * 2024 Thanksgiving (Nov 28): Nov 25 to Dec 01 (7 days)
-- - Regular Days: All remaining 703 calendar days
-- Metrics compared via Average Daily Revenue and Average Daily Orders.
-- =============================================================================

-- Q: Do Christmas and Thanksgiving windows produce a measurable sales uplift compared
--    to regular operating days?
WITH daily_sales_aggregated AS (
    SELECT
        s.order_date,
        COUNT(DISTINCT s.order_id) AS daily_orders,
        SUM(s.quantity)             AS daily_quantity,
        SUM(s.revenue)              AS daily_revenue,
        SUM(s.profit)               AS daily_profit,
        CASE
            -- Christmas Window (Dec 20 - Dec 26 in 2023 and 2024)
            WHEN (s.order_date BETWEEN '2023-12-20' AND '2023-12-26')
              OR (s.order_date BETWEEN '2024-12-20' AND '2024-12-26')
            THEN 'Christmas Window (Dec 20-26)'

            -- Thanksgiving Window (7-day window: Thanksgiving ± 3 days)
            WHEN (s.order_date BETWEEN '2023-11-20' AND '2023-11-26')
              OR (s.order_date BETWEEN '2024-11-25' AND '2024-12-01')
            THEN 'Thanksgiving Window (+/- 3 days)'

            ELSE 'Regular Operating Days'
        END AS period_type
    FROM sales s
    GROUP BY s.order_date
)
SELECT
    period_type,
    COUNT(DISTINCT order_date)                                     AS total_days_in_period,
    ROUND(SUM(daily_revenue), 2)                                   AS total_period_revenue,
    ROUND(SUM(daily_profit), 2)                                    AS total_period_profit,
    ROUND(AVG(daily_revenue), 2)                                   AS avg_daily_revenue,
    ROUND(AVG(daily_profit), 2)                                    AS avg_daily_profit,
    ROUND(AVG(daily_orders), 1)                                    AS avg_daily_orders,
    ROUND(AVG(daily_quantity), 1)                                  AS avg_daily_units,
    ROUND((AVG(daily_revenue) - 34904.38) / 34904.38 * 100, 2)     AS uplift_vs_regular_pct
FROM daily_sales_aggregated
GROUP BY period_type
ORDER BY avg_daily_revenue DESC;
