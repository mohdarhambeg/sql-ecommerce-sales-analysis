-- 1. Calculate Total Revenue
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;


-- 2. Revenue by Payment Method
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;


-- 3. Average Payment Value per Payment Record
SELECT
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM order_payments;


-- 4. Monthly Revenue
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY month;


-- 5. Yearly Revenue
SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY EXTRACT(YEAR FROM o.order_purchase_timestamp)
ORDER BY year;


-- 6. Average Order Value (AOV)
WITH order_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM order_payments
    GROUP BY order_id
)
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM order_totals;


-- 7. Monthly Revenue Growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(op.payment_value) AS revenue
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
),
revenue_comparison AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_percentage
FROM revenue_comparison
ORDER BY month;
