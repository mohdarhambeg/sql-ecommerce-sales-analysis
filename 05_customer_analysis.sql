--How many customers are in each state
select c.customer_state,count(*) as total_customers
from customers c 
group by c.customer_state
order by total_customers desc;

--Top 10 customer cities
select c.customer_city,count(*) as total_customers
from customers c 
group by c.customer_city
order by total_customers desc
limit 10;

--Orders by state
select c.customer_state,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_state 
order by total_orders desc;

--Average orders per customer
select Count(o.order_id)::DECIMAL / count(distinct c.customer_unique_id)as average_order_per_customer
from customers c 
join orders o on c.customer_id = o.customer_id  ;

--Find repeat customers
select c.customer_unique_id,count(o.order_id) as total_order
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_unique_id
having count(order_id) > 1
order by total_order desc;

--Count the number of repeat customers
with customer_orders as (
select c.customer_unique_id,count(o.order_id) as total_order
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_unique_id
)
select  count(*) as repeated_customers
from customer_orders 
where total_order > 1;

--One-time vs repeated time 
with customer_orders as (
select c.customer_unique_id,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_unique_id 
)
select case when total_orders = 1 then 'One -time' else 'Repeated Customer'
end as customer_type, count(*) as customer_count 
from customer_orders 
group by customer_type; 

--calculate repeated customer pecentage 
with customer_orders as (
select c.customer_unique_id,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_unique_id 
)
select round(100.0*count(*) filter(where total_orders >1) / count(*),2) as repeat_customer_percentage
from customer_orders;

--Calculate Average Order Value Correctly 
with order_totals as (
select order_id, sum(payment_value) as order_value
from order_payments 
group by order_id
)
select round(avg(order_value)) as average_order_value
from order_totals;

--AOV by Customer state 
with order_totals as(
select order_id,sum(payment_value) as order_value
from order_payments 
group by order_id 
)
select c.customer_state,round(avg(ot.order_value),2) as average_order_value
from customers c 
join orders o  on c.customer_id = o.customer_id 
join order_totals ot on o.order_id = ot.order_id 
group by c.customer_state 
order by average_order_value desc;

--Top Customers by spending
select c.customer_unique_id,sum(op.payment_value) as total_spent
from customers c 
join orders o on c.customer_id = o.customer_id 
join order_payments op on o.order_id = op.order_id 
group by c.customer_unique_id  
order by total_spent  desc 
limit 10;

--Customers Segmentation 
with customer_spending as (
select c.customer_unique_id,sum(op.payment_value) as total_spent
from customers c 
join orders o on c.customer_id = o.customer_id 
join order_payments op on o.order_id = op.order_id 
group by c.customer_unique_id
)
select 
case 
	when total_spent >= 1000 then 'High Value'
	when total_spent >= 500 then 'Medium Value'
	else 'Low value'
end as customer_segment,count(*) as customer_count,round(AVG(total_spent),2) as average_spending
from customer_spending 
group by customer_segment
order by average_spending desc;