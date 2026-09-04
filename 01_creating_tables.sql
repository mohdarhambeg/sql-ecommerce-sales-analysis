create table customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
select * from customers;

select count(*)
from customers;

create table orders(
order_id VARCHAR(50),
customer_id VARCHAR(50),
order_status VARCHAR(50),
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);

select * from orders;

select count(*) from orders;

create table order_items(
order_id VARCHAR(50),
order_item_id INTEGER,
product_id VARCHAR(50),
seller_id VARCHAR(50),
shipping_limit_date TIMESTAMP,
price NUMARIC(10,2)
);

SELECT * FROM order_items;
select count(*) from order_items;

create table order_payments(
order_id VARCHAR(50),
payment_sequential INTEGER,
payment_type VARCHAR(30),
payment_installments INTEGER,
payment_value NUMERIC(10,2)
);

select * from order_payments;
select count(*) from order_payments;

create table order_reviews(
review_id VARCHAR(50),
order_id VARCHAR(50),
review_score INTEGER,
review_comment_title TEXT,
review_comment_message TEXT,
review_creation_date TIMESTAMP,
review_answer_timestamp TIMESTAMP
);
select * from order_reviews;
select count(*) from order_reviews;


create table products(
product_id VARCHAR(50),
product_category_name VARCHAR(100),
product_name_length INTEGER,
product_description_length INTEGER,
product_photos_qty INTEGER,
product_weight_g NUMERIC,
product_length_cm NUMERIC,
product_height_cm NUMERIC,
product_width_cm NUMERIC
);
select * from products;
select count(*) from products;

create table sellers(
seller_id VARCHAR(50),
seller_zip_code_prefix INTEGER,
seller_city VARCHAR(100),
seller_state VARCHAR(10)
);

select * from sellers;

select count(*) from sellers;

create table geolocation(
geolocation_zip_code_prefix INTEGER,
geolocation_lat NUMERIC,
geolocation_lng NUMERIC,
geolocation_city VARCHAR(100),
geolocation_state VARCHAR(10)
);

select * from geolocation;
select count(*) from geolocation;

create table category_translation(
product_category_name VARCHAR(100),
product_category_name_english VARCHAR(100)
);

select * from category_translation;
select count(*) from category_translation;