-- 1. Customers and Their Orders
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
LIMIT 20;


-- 2. Orders and Their Items
SELECT
    o.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
LIMIT 20;


-- 3. Orders, Items, and Products
SELECT
    o.order_id,
    oi.product_id,
    p.product_category_name,
    oi.price
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
LIMIT 20;


-- 4. Orders and Their Payments
SELECT
    o.order_id,
    o.order_status,
    op.payment_type,
    op.payment_value
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
LIMIT 20;


-- 5. Orders and Their Reviews
SELECT
    o.order_id,
    o.order_status,
    r.review_score,
    r.review_comment_title
FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id
LIMIT 20;

