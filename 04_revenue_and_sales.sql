--CALCULATE TOTAL REVENUE
select sum(payment_value) as total_revenue
from order_payments;
--CALCULATE REVENUE BY PAYMENT METHOD
select payment_type,sum(payment_value) as total_revenue
from order_payments
group by payment_type 
order by total_revenue desc;
--AVERAGE PAYMENT VALUE
select avg(payment_value) as average_payment_value
from order_payments;
--CALCULATE REVENUE BY MONTH
select date_trunc('month',o.order_purchase_timestamp) as month,sum(op.payment_value) as revenue
from orders o 
join order_payments op on o.order_id = op.order_id 
group by month
order by month;
--CALCULATE REVENUE BY YEAR 
select EXTRACT(year from o.order_purchase_timestamp)as year,sum(op.payment_value) as revenue
from orders o 
join order_payments op on o.order_id = op.order_id 
group by year
order by year;

--TOP 10 PRODUCT BY REVENUE
select oi.product_id ,SUM(oi.price) as revenue
from order_items as oi
group by oi.product_id
order by revenue desc
limit 10;

--REVENUE BY PRODUCT CATEGORY
select p.product_category_name,sum(oi.price) as revenue 
from order_items oi 
join products p on oi.product_id = p.product_id
group by p.product_category_name
order by revenue desc;

--REVENUE BY PRODUCT CATEGORY NAME ENGLISH(top 10)
select ct.product_category_name_english as category,sum(oi.price) as revenue 
from order_items oi 
join products p on p.product_id = oi.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by category
order by revenue desc
limit 10;

--NUMBER OF PRODUCTS SOLD BY CATEGORY
select ct.product_category_name_english as category,count(*) as unit_sold 
from order_items oi 
join products p on p.product_id = oi.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by category
order by unit_sold desc
limit 10;
--AVERAGE PRODUCT PRICE BY CATEGORY
select ct.product_category_name_english as category, round(avg(oi.price),2) as average_price
from order_items oi 
join products p on p.product_id = oi.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by category
order by average_price desc
limit 10;