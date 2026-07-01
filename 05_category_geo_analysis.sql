-- ============================================
-- Category & Geography Analysis
-- ============================================

-- Top 10 categories by revenue
SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS num_orders,
    SUM(oi.price) AS total_revenue
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- Average order value and delivery time
SELECT 
    ROUND(AVG(order_total), 2) AS avg_order_value,
    ROUND(AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))), 1) AS avg_delivery_days
FROM (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        SUM(oi.price + oi.freight_value) AS order_total
    FROM olist_orders o
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id, o.order_purchase_timestamp, o.order_delivered_customer_date
) sub;

-- Revenue by state (Top 10)
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS num_customers,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM olist_customers c
JOIN olist_orders o ON c.customer_id = o.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;