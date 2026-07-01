-- ============================================
-- Data Quality Checks
-- Verify all tables loaded correctly
-- ============================================

SELECT 
  (SELECT COUNT(*) FROM olist_customers) AS customers,
  (SELECT COUNT(*) FROM olist_orders) AS orders,
  (SELECT COUNT(*) FROM olist_order_items) AS order_items,
  (SELECT COUNT(*) FROM olist_order_payments) AS payments,
  (SELECT COUNT(*) FROM olist_order_reviews) AS reviews,
  (SELECT COUNT(*) FROM olist_products) AS products,
  (SELECT COUNT(*) FROM olist_sellers) AS sellers,
  (SELECT COUNT(*) FROM olist_geolocation) AS geolocation;