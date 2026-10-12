--9_Final business analysis
--create final KPI services
select (select count(*) from customers) as total_customer,
(select count(*) from orders) as total_orders,
(select count(*) from orders where order_status = 'delivered') as delivered_orders,
(select round(SUM(payment_value),2) from order_payments) as total_payment_value,
(select round(AVG(payment_value),2) from order_payments) as average_payment_value;

--Calculate the actual average order value
with order_totals as(
select order_id, SUM(payment_value) as order_value
from order_payments 
group by order_id
)
select round(AVG(order_value),2) as average_order_value
from order_totals ;

--customer repeated rate
with customer_orders as(
select c.customer_unique_id,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_unique_id
)
select count(*) as total_customer,count(*) filter(where total_orders >1) as repeated_customers,
round(100*count(*) filter(where total_orders >1)/count(*),2) as repeated_customers_percentage
from customer_orders;

--Delivery KPI
select count(*) as delivered_order,
round(AVG(extract(epoch from(order_delivered_customer_date-order_purchase_timestamp))/86400),2) as average_delivered_days,
count(*) filter(where order_delivered_customer_date > order_estimated_delivery_date) as late_orders,
round(100*count(*) filter(where order_delivered_customer_date > order_estimated_delivery_date)/count(*),2) as late_delivery_percentage
from orders
where order_status = 'delivered' and order_delivered_customer_date is not null;

-- Customer satisfaction vs delivery
WITH order_review_scores AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN order_review_scores r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;


--Top 10 product categories
select ct.product_category_name_english as category,
round(sum(oi.price),2) as revenue,
count(*) as unit_sold
from order_items oi 
join products p on oi.product_id  = p.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by ct.product_category_name_english
order by revenue desc limit 10;

--Top 10 sellers
select seller_id, round(SUM(price),2) as revenue,
count(distinct order_id ) as orders
from order_items 
group by seller_id 
order by revenue desc limit 10;

--Geographic Analysis
select c.customer_state,round(sum(op.payment_value),2) as revenue,
count(distinct o.order_id) as orders
from customers c 
join orders o on c.customer_id = o.customer_id 
join order_payments op  on o.order_id = op.order_id 
group by c.customer_state 
order by revenue desc;

-- Monthly performance table
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(op.payment_value) AS order_value
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    month,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(order_value), 2) AS revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM order_totals
GROUP BY month
ORDER BY month;
