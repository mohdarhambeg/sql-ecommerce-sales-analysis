# Olist E-commerce SQL Analysis

## Project Overview

This project analyzes e-commerce order data from the Brazilian Olist marketplace using SQL and PostgreSQL. The goal is to explore business performance, identify trends, and generate insights that can support data-driven decision-making.

The analysis covers sales and revenue, customer behavior, seller performance, product categories, delivery operations, and customer satisfaction.
## Dataset

This project uses the Brazilian E-Commerce Public Dataset by Olist. It contains information about customers, orders, order items, payments, reviews, products, sellers, and product categories.

The dataset supports analysis of sales performance, customer purchasing behavior, seller activity, delivery operations, and customer satisfaction.

## Tools and Technologies

- **SQL:** Data querying, aggregation, joins, CTEs, and window functions
- **PostgreSQL:** Relational database management and analysis
- **Visual Studio Code:** SQL script editing and project organization
- **Git and GitHub:** Version control and project hosting
## Project Structure

```text
sql-ecommerce-sales-analysis/
│
├── 01_creating_tables.sql
├── 02_basic_data_exploration.sql
├── 03_data_relationships.sql
├── 04_revenue_and_sales.sql
├── 05_customer_analysis.sql
├── 06_delivery_operational_analysis.sql
├── 07_seller_performance_analysis.sql
├── 08_Advanced_sql_Analysis.sql
├── 09_final_business_analysis.sql
└── README.md
```

### SQL Analysis Modules

| File | Description |
|---|---|
| `01_creating_tables.sql` | Defines the database table structures |
| `02_basic_data_exploration.sql` | Explores records, order statuses, locations, and payments |
| `03_data_relationships.sql` | Examines relationships between tables using joins |
| `04_revenue_and_sales.sql` | Analyzes sales, revenue, and monthly performance |
| `05_customer_analysis.sql` | Studies customer spending and repeat purchases |
| `06_delivery_operational_analysis.sql` | Measures delivery times and late deliveries |
| `07_seller_performance_analysis.sql` | Compares seller revenue, orders, and review scores |
| `08_Advanced_sql_Analysis.sql` | Uses CTEs, window functions, rankings, and segmentation |
| `09_final_business_analysis.sql` | Combines key business metrics and KPIs |
## Business Objectives

The main objectives of this project are:

- Analyze overall sales and revenue performance.
- Identify monthly revenue trends and changes in business performance.
- Understand customer purchasing behavior and repeat purchase patterns.
- Evaluate seller performance based on revenue, order volume, and customer reviews.
- Analyze product categories based on revenue and units sold.
- Measure delivery times and identify late deliveries.
- Examine customer satisfaction in relation to delivery performance.
- Develop key business performance indicators (KPIs) to support data-driven decisions.

## Key SQL Concepts Used

- SELECT statements and filtering
- Aggregate functions such as SUM, AVG, COUNT, MIN, and MAX
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- Common Table Expressions (CTEs)
- Window functions such as ROW_NUMBER, RANK, DENSE_RANK, LAG, and NTILE
- CASE statements
- Date and time functions
- Conditional aggregation using FILTER
## How to Run the Project

### Prerequisites

- PostgreSQL installed
- A PostgreSQL client, such as pgAdmin
- The Olist Brazilian E-Commerce dataset

### Setup Instructions

1. Download the Olist dataset and extract the CSV files.
2. Create a PostgreSQL database for the project.
3. Import the CSV data into the corresponding database tables.
4. Connect to the database using pgAdmin or another PostgreSQL client.
5. Open the SQL files in this repository.
6. Execute the analysis queries in sequence, starting with basic data exploration and continuing through the final business analysis.

**Note:** The table-creation script defines the database structure. If your tables already exist and contain data, do not run the script again unless it is designed to handle existing tables safely.

## Author

**Mohd Arham Beg**

Computer Science Engineering Student | Aspiring Data Analyst
