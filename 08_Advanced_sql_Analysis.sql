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

--Monthly revenue using a CTE
with monthly_revenue as(
select date_trunc('month', o.order_purchase_timestamp) as month,
SUM(op.payment_value) as revenue
from orders o 
join order_payments op on o.order_id = op.order_id 
group by date_trunc('month', o.order_purchase_timestamp)
)
select month,round(revenue,2) as revenue
from monthly_revenue 
order by month;

--Compare revenue with the previous month
with monthly_revenue as(
select date_trunc('month', o.order_purchase_timestamp) as month,
SUM(op.payment_value) as revenue
from orders o 
join order_payments op on o.order_id = op.order_id 
group by date_trunc('month', o.order_purchase_timestamp)
),
revenue_comparision as(
select month, revenue, lag(revenue) over(order by month) as previous_month_revenue
from monthly_revenue 
) 
select month, round(revenue) as revenue, round(previous_month_revenue) as previous_month_revenue,
round(100*(revenue-previous_month_revenue)/nullif(previous_month_revenue,0),2) as revenue_growth_percentage
from revenue_comparision 
order by month;

--Calculate the cumilative revenue
with monthly_revenue as(
select date_trunc('month', o.order_purchase_timestamp) as month,
SUM(op.payment_value) as revenue
from orders o 
join order_payments op on o.order_id = op.order_id 
group by date_trunc('month', o.order_purchase_timestamp)
)
select month, round(revenue,2) as monthy_revenue,
round(sum(revenue) over(order by month rows between unbounded preceding and current row ),2) as cumilative_revenue
from monthly_revenue 
order by month;

--Compare each category with the overall average 
with category_revenue as(
select ct.product_category_name_english as category, SUM(oi.price) as total_revenue
from order_items oi 
join products p on oi.product_id  = p.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by ct.product_category_name_english 
)
select category, round(total_revenue,2) as total_revenue,
round(AVG(total_revenue) over() ,2) as overall_average_revenue,
round(total_revenue-AVG(total_revenue) over() ,2) as defference_between_average
from category_revenue 
order by total_revenue desc;

--Find the customer with increasing order activity
select c.customer_unique_id, MIN(o.order_purchase_timestamp) as first_order_date,
MAX(o.order_purchase_timestamp) as last_order_date, count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_unique_id
having count(order_id)>1
order by total_orders desc;