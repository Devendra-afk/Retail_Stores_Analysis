-- =============================================================================
-- 03_customer_analysis.sql
-- Customer segmentation and behavior analysis
-- =============================================================================

USE retail_store_analysis;

-- =============================================================================
-- SECTION 1: AGE GROUP SEGMENTATION
-- =============================================================================

-- Q: How do different age groups contribute to revenue, quantity, and profit?
WITH customer_segments AS (
    SELECT
        c.customer_id,
        c.age,
        CASE
            WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
            WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
            WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
            WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
            WHEN c.age BETWEEN 56 AND 70 THEN '56-70'
            ELSE 'Other'
        END AS age_group,
        s.revenue,
        s.profit,
        s.quantity
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
)
SELECT
    age_group,
    COUNT(DISTINCT customer_id) AS customer_count,
    SUM(quantity)               AS total_quantity,
    ROUND(SUM(revenue), 2)     AS total_revenue,
    ROUND(SUM(profit), 2)      AS total_profit,
    ROUND(AVG(revenue), 2)     AS avg_revenue_per_sale,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM customer_segments
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Q: Which age group has the highest average order value?
WITH customer_orders AS (
    SELECT
        CASE
            WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
            WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
            WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
            WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
            WHEN c.age BETWEEN 56 AND 70 THEN '56-70'
            ELSE 'Other'
        END AS age_group,
        s.order_id,
        s.revenue
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
)
SELECT
    age_group,
    COUNT(DISTINCT order_id)         AS total_orders,
    ROUND(SUM(revenue), 2)          AS total_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM customer_orders
GROUP BY age_group
ORDER BY avg_order_value DESC;

-- =============================================================================
-- SECTION 2: GENDER ANALYSIS
-- =============================================================================

-- Q: How does revenue, profit, and quantity differ by gender?
SELECT
    c.gender,
    COUNT(DISTINCT c.customer_id)  AS customer_count,
    COUNT(DISTINCT s.order_id)     AS total_orders,
    SUM(s.quantity)                 AS total_quantity,
    ROUND(SUM(s.revenue), 2)       AS total_revenue,
    ROUND(SUM(s.profit), 2)        AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT s.order_id), 2)    AS avg_order_value
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.gender
ORDER BY total_revenue DESC;

-- Q: How does gender interact with age group for revenue contribution?
SELECT
    c.gender,
    CASE
        WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
        WHEN c.age BETWEEN 56 AND 70 THEN '56-70'
        ELSE 'Other'
    END AS age_group,
    COUNT(DISTINCT c.customer_id)  AS customer_count,
    ROUND(SUM(s.revenue), 2)       AS total_revenue,
    ROUND(SUM(s.profit), 2)        AS total_profit
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.gender, age_group
ORDER BY c.gender, total_revenue DESC;

-- =============================================================================
-- SECTION 3: LOYALTY MEMBER IMPACT
-- =============================================================================

-- Q: How much more revenue do loyalty members generate compared to non-members?
SELECT
    c.loyalty_member,
    COUNT(DISTINCT c.customer_id)  AS customer_count,
    COUNT(DISTINCT s.order_id)     AS total_orders,
    SUM(s.quantity)                 AS total_quantity,
    ROUND(SUM(s.revenue), 2)       AS total_revenue,
    ROUND(SUM(s.profit), 2)        AS total_profit,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer,
    ROUND(AVG(s.revenue), 2)       AS avg_revenue_per_sale,
    ROUND(AVG(s.discount), 4)      AS avg_discount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.loyalty_member
ORDER BY total_revenue DESC;

-- Q: Do loyalty members buy more frequently and at higher quantities?
WITH customer_purchase_freq AS (
    SELECT
        c.customer_id,
        c.loyalty_member,
        COUNT(DISTINCT s.order_id) AS order_count,
        SUM(s.quantity)            AS total_quantity,
        SUM(s.revenue)             AS total_revenue
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
    GROUP BY c.customer_id, c.loyalty_member
)
SELECT
    loyalty_member,
    COUNT(*)                            AS customer_count,
    ROUND(AVG(order_count), 2)          AS avg_orders_per_customer,
    ROUND(AVG(total_quantity), 2)       AS avg_quantity_per_customer,
    ROUND(AVG(total_revenue), 2)        AS avg_revenue_per_customer
FROM customer_purchase_freq
GROUP BY loyalty_member
ORDER BY avg_revenue_per_customer DESC;

-- =============================================================================
-- SECTION 4: REVENUE PER CUSTOMER BY SEGMENT
-- =============================================================================

-- Q: Who are the top 20 customers by total revenue?
SELECT
    c.customer_id,
    c.age,
    c.gender,
    c.loyalty_member,
    COUNT(DISTINCT s.order_id)  AS total_orders,
    SUM(s.quantity)              AS total_quantity,
    ROUND(SUM(s.revenue), 2)    AS total_revenue,
    ROUND(SUM(s.profit), 2)     AS total_profit,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS customer_rank
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.age, c.gender, c.loyalty_member
ORDER BY total_revenue DESC
LIMIT 20;

-- Q: What is the revenue distribution per customer across age-loyalty segments?
SELECT
    CASE
        WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
        WHEN c.age BETWEEN 56 AND 70 THEN '56-70'
        ELSE 'Other'
    END AS age_group,
    c.loyalty_member,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    ROUND(SUM(s.revenue), 2)      AS total_revenue,
    ROUND(SUM(s.revenue) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer,
    ROUND(SUM(s.profit) / COUNT(DISTINCT c.customer_id), 2)  AS profit_per_customer
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY age_group, c.loyalty_member
ORDER BY age_group, c.loyalty_member;
