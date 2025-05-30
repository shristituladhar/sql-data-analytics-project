
/*
===========================================================
EDA Phase 03 – Measures Exploration
===========================================================

Purpose:
Explore key numeric metrics (measures) that describe the scale, activity, and financial aspects of the business data.

What It Does:
- Calculates total sales, quantity, and average price
- Counts unique orders, products, and customers
- Generates a consolidated metrics summary report

SQL Functions Used:
- SUM(), AVG(), COUNT(), DISTINCT
- UNION ALL

===========================================================
*/

-- Total sales
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;
GO

-- Total quantity sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;
GO

-- Average selling price
SELECT AVG(price) AS average_price
FROM gold.fact_sales;
GO

-- Total number of orders (non-unique and unique)
SELECT COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS total_unique_orders
FROM gold.fact_sales;
GO

-- Total number of products
SELECT COUNT(product_key) AS total_products
FROM gold.dim_products;

-- OR: Count distinct product names
SELECT COUNT(DISTINCT product_name) AS total_distinct_products
FROM gold.dim_products;
GO

-- Total number of customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM gold.dim_customers;
GO

-- Total number of customers who placed an order
SELECT COUNT(DISTINCT customer_key) AS active_customers
FROM gold.fact_sales;
GO

-- Consolidated business metrics report
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Products', COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Number of Customers', COUNT(DISTINCT customer_id) FROM gold.dim_customers;
GO
