-- =============================================================================
-- 03_customer_analysis.sql
-- Customer Demographics, Segmentation, & Loyalty Program Analysis
-- Retail Stores Sales Analysis (2023-2024)
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: CUSTOMER AGE COHORT SEGMENTATION
-- =============================================================================

-- Q: How do customer age brackets (18-25, 26-35, 36-45, 46-55, 56-70) contribute
--    to revenue, orders, basket sizes (AOV), and 2-year spend per customer?
WITH customer_cohorts AS (
    SELECT
        c.customer_id,
        CASE
            WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
            WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
            WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
            WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
            WHEN c.age BETWEEN 56 AND 70 THEN '56-70'
            ELSE 'Other'
        END AS age_cohort,
        s.order_id,
        s.quantity,
        s.revenue,
        s.profit
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
)
SELECT
    age_cohort,
    COUNT(DISTINCT customer_id)                                  AS unique_customers,
    COUNT(DISTINCT order_id)                                    AS total_orders,
    SUM(quantity)                                                AS total_units,
    ROUND(SUM(revenue), 2)                                      AS total_revenue,
    ROUND(SUM(profit), 2)                                       AS total_profit,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2)        AS avg_spend_per_customer,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2)           AS average_order_value,
    ROUND(COUNT(DISTINCT order_id) * 1.0 / COUNT(DISTINCT customer_id), 1) AS orders_per_customer,
    ROUND(SUM(revenue) / 25486128.86 * 100, 2)                  AS pct_total_revenue
FROM customer_cohorts
GROUP BY age_cohort
ORDER BY age_cohort ASC;

-- =============================================================================
-- SECTION 2: GENDER PURCHASING PATTERNS
-- =============================================================================

-- Q: How do purchasing behavior, basket size, and revenue compare across recorded customer genders?
SELECT
    c.gender,
    COUNT(DISTINCT c.customer_id)                                AS unique_customers,
    COUNT(DISTINCT s.order_id)                                  AS total_orders,
    SUM(s.quantity)                                              AS total_units,
    ROUND(SUM(s.revenue), 2)                                    AS total_revenue,
    ROUND(SUM(s.profit), 2)                                     AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT c.customer_id), 2)      AS avg_spend_per_customer,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.order_id), 2)         AS average_order_value,
    ROUND(COUNT(DISTINCT s.order_id) * 1.0 / COUNT(DISTINCT c.customer_id), 1) AS orders_per_customer,
    ROUND(SUM(s.revenue) / 25486128.86 * 100, 2)                AS pct_total_revenue
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.gender
ORDER BY total_revenue DESC;

-- =============================================================================
-- SECTION 3: LOYALTY MEMBERSHIP PROGRAM EVALUATION
-- =============================================================================

-- Q: Does enrollment in the loyalty program drive higher spending, larger orders (AOV),
--    or increased purchasing frequency compared to non-members?
SELECT
    CASE 
        WHEN c.loyalty_member = 1 THEN 'Loyalty Member'
        ELSE 'Non-Member'
    END AS membership_status,
    COUNT(DISTINCT c.customer_id)                                AS unique_customers,
    COUNT(DISTINCT s.order_id)                                  AS total_orders,
    SUM(s.quantity)                                              AS total_units,
    ROUND(SUM(s.revenue), 2)                                    AS total_revenue,
    ROUND(SUM(s.profit), 2)                                     AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT c.customer_id), 2)      AS avg_spend_per_customer,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.order_id), 2)         AS average_order_value,
    ROUND(COUNT(DISTINCT s.order_id) * 1.0 / COUNT(DISTINCT c.customer_id), 1) AS orders_per_customer,
    ROUND(AVG(s.discount) * 100, 2)                             AS avg_discount_received
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.loyalty_member
ORDER BY c.loyalty_member DESC;

-- =============================================================================
-- SECTION 4: RFM-STYLE CUSTOMER VALUE DISTRIBUTION
-- =============================================================================

-- Q: What is the distribution of total 2-year spending across individual customers?
WITH customer_spending AS (
    SELECT
        s.customer_id,
        COUNT(DISTINCT s.order_id) AS total_orders,
        SUM(s.revenue)             AS total_spend
    FROM sales s
    GROUP BY s.customer_id
)
SELECT
    CASE
        WHEN total_spend < 300 THEN '1. Under $300'
        WHEN total_spend BETWEEN 300 AND 449.99 THEN '2. $300 - $449'
        WHEN total_spend BETWEEN 450 AND 599.99 THEN '3. $450 - $599'
        WHEN total_spend BETWEEN 600 AND 749.99 THEN '4. $600 - $749'
        ELSE '5. $750 and Above'
    END AS spending_tier,
    COUNT(*)                                AS customer_count,
    ROUND(COUNT(*) / 50000.0 * 100, 2)      AS pct_of_customers,
    ROUND(SUM(total_spend), 2)              AS total_tier_revenue,
    ROUND(AVG(total_orders), 1)             AS avg_orders_per_customer
FROM customer_spending
GROUP BY spending_tier
ORDER BY spending_tier ASC;
