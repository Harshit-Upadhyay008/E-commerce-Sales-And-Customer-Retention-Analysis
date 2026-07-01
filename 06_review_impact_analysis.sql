-- ============================================
-- Review Score & Retention Impact Analysis
-- ============================================

-- Review score distribution
SELECT 
    r.review_score,
    COUNT(DISTINCT o.order_id) AS num_orders
FROM olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;

-- Average review score: one-time vs repeat customers
SELECT 
    CASE WHEN purchase_count = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
    ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS purchase_count,
        AVG(r.review_score) AS avg_review_score
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t
GROUP BY customer_type;