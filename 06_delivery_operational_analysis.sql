--how many orders have actually been delivered
select count(*) as delivered_orders
from orders 
where order_status = 'delivered';

--Calculate delivery time
select order_id,
order_purchase_timestamp,
order_delivered_customer_date,
round(extract(EPOCH from(order_delivered_customer_date - order_purchase_timestamp))/86400,2) as delivery_days
from orders
where order_status = 'delivered' and order_delivered_customer_date is not null 
limit 10;

--Average delivary time 
select order_id,round(EXTRACT(EPOCH from (order_delivered_customer_date - order_purchase_timestamp))/86400,2) as delivery_days
from orders
where order_status = 'delivered' and order_delivered_customer_date is not null;

--Identify late deliveries
select order_id,
order_purchase_timestamp,
order_delivered_customer_date
from orders 
where order_status = 'delivered' 
and order_delivered_customer_date is not null 
and order_delivered_customer_date > order_estimated_delivery_date ;

--Count late deliveries
select count(*) as late_orders
from orders 
where order_status = 'delivered' 
and order_delivered_customer_date is not null 
and order_delivered_customer_date > order_estimated_delivery_date ;

--Calculate late delivery percentage
select round(100.0 * count(*) filter(where order_delivered_customer_date > order_estimated_delivery_date)/count(*),2) as late_delivery_percentage
from orders 
where order_status = 'delivered' 
and order_delivered_customer_date is not null;

--Calculate on-time delivery percentage
select round(100.0 * count(*) filter(where order_delivered_customer_date <= order_estimated_delivery_date)/count(*),2) as on_time_delivery_percentage
from orders 
where order_status = 'delivered' 
and order_delivered_customer_date is not null;

--Delivery performance by state
select c.customer_state,count(o.order_id) as delivered_orders,
round(avg(extract(epoch from(o.order_delivered_customer_date - order_purchase_timestamp)))/86400,2) as average_delivary_days
from customers c 
join orders o on c.customer_id = o.customer_id
where order_status = 'delivered' 
and order_delivered_customer_date is not null
group by c.customer_state
order by average_delivary_days desc;

--Late delivery rate by state
select c.customer_state,count(*) as delivered_orders,
count(*) filter(where order_delivered_customer_date > order_estimated_delivery_date) as late_orders,
round(100.0 * count(*) filter(where order_delivered_customer_date > order_estimated_delivery_date)/count(*),2) as late_delivery_percentage 
from customers c 
join orders o on c.customer_id = o.customer_id
where order_status = 'delivered' 
and order_delivered_customer_date is not null
group by c.customer_state
order by late_delivery_percentage desc;

--Find the 10 most delayed orders
select order_id,order_delivered_customer_date,order_estimated_delivery_date,
round(extract(epoch from(order_delivered_customer_date - order_estimated_delivery_date))/86400,2) as delay_days
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null 
and order_delivered_customer_date > order_estimated_delivery_date
order by delay_days desc
limit 10;

--Delivery time by month
select date_trunc('month',order_purchase_timestamp) as month,
round(avg(extract(epoch from(order_delivered_customer_date - order_purchase_timestamp ))/86400),2) as average_delivery_day
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
group by month
order by month;

--Delivery performance vs review score
select 
	case 
		when o.order_delivered_customer_date > o.order_estimated_delivery_date
		then 'Late'
		else 'On Time'
	end as delivery_status,
	round(avg(r.review_score),2) as average_review_score,
	count(*) as total_orders
from orders o 
join order_reviews r on o.order_id = r.order_id
where o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT null
group by delivery_status;