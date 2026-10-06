--Find the latest order of each customer
with ranked_orders as(
select c.customer_unique_id,o.order_id,o.order_purchase_timestamp,
row_number() OVER(partition by c.customer_unique_id  order by o.order_purchase_timestamp desc) as row_num
from customers c 
join orders o on c.customer_id = o.customer_id 
)
select customer_unique_id, order_id, order_purchase_timestamp
from ranked_orders 
where row_num = 1
order by order_purchase_timestamp desc;

--RANK PRODUCT CATEGORY BY REVENUE
with category_revenue as (
select ct.product_category_name_english as category,
sum(oi.price) as total_revenue
from order_items oi 
join products p on oi.product_id = p.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by ct.product_category_name_english  
)
select category, round(total_revenue, 2) as total_revenue,dense_rank() over(order by total_revenue desc) as revenue_rank
from category_revenue 
order by revenue_rank ;

--divide customers into four spending groups
with customer_spending as(
select c.customer_unique_id,sum(op.payment_value) as total_spent
from customers c 
join orders o on c.customer_id = o.customer_id 
join order_payments op  on  o.order_id = op.order_id 
group by c.customer_unique_id 
), customer_quantiles as(
select customer_unique_id, total_spent, ntile(4) over(order by total_spent desc) as spending_group
from customer_spending 
)
select customer_unique_id, round(total_spent,2) as total_spend, spending_group,
case 
	when spending_group = 1 then 'Top 25%'
	when spending_group = 2 then 'Upper-Middle 25%'
	when spending_group = 3 then 'Lower-Middle 25%'
	else 'Bottom 25%'
end
from customer_quantiles 
order by spending_group, total_spent desc;
