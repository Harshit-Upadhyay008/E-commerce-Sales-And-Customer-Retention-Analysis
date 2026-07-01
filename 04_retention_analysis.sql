-- ============================================
-- Customer Retention Analysis
-- ============================================

-- Repeat vs one-time customers
SELECT 
    purchase_count,
    COUNT(*) AS num_customers
FROM (
    SELECT 
        c.customer_unique_id, 
        COUNT(DISTINCT o.order_id) AS purchase_count
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t
GROUP BY purchase_count
ORDER BY purchase_count;

-- Repeat purchase rate
SELECT 
    SUM(CASE WHEN purchase_count = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    SUM(CASE WHEN purchase_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN purchase_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate_pct
FROM (
    SELECT 
        c.customer_unique_id, 
        COUNT(DISTINCT o.order_id) AS purchase_count
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t;

-- Cohort retention analysis
WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
orders_with_cohort AS (
    SELECT 
        c.customer_unique_id,
        fp.cohort_month,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN first_purchase fp ON c.customer_unique_id = fp.customer_unique_id
    WHERE o.order_status = 'delivered'
)
SELECT 
    cohort_month,
    order_month,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM orders_with_cohort
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;