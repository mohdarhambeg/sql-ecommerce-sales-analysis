select c.customer_id,c.customer_city,c.customer_state,o.order_id,o.order_status
from customers c join orders o on c.customer_id = o.customer_id limit 20;

select o.order_id,oi.product_id,oi.seller_id,oi.price
from orders o join order_items oi on o.order_id = oi.order_id limit 20;

select o.order_id,oi.product_id,p.product_category_name ,oi.price
from orders o join order_items oi on o.order_id = oi.order_id join products p on oi.product_id = p.product_id 
limit 20;

select count(*) as total_customers
from customers;

select count(*) as total_orders
from orders;

select distinct order_status 
from orders;

--how many orders in each states
select order_status,count(*) as order_count
from orders 
group by order_status 
order by order_count desc;

select customer_state, count(*) as customer_count 
from customers
group by customer_state 
order by customer_count desc;

select customer_city,count(*) as customer_count
from customers 
group by customer_city 
order by customer_count desc;

select distinct payment_type
from order_payments;

select payment_type,count(*) as payment_count
from order_payments
group by payment_type 
order by payment_count desc;

select sum(payment_value) as total_payment_value
from order_payments;

select avg(payment_value) as average_payment_value
from order_payments;
