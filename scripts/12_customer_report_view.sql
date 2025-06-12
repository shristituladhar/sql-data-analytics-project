/*
===============================================================================
Advanced Phase 12 - Customer Report View
===============================================================================

Purpose:
Create a customer-level reporting view that consolidates transactional data,
customer details, and business KPIs into a single, queryable structure.

Highlights:
1. Gathers essential fields: names, ages, transaction data
2. Segment customers by:
   - Lifetime behavior (VIP, Regular, New)
   - Age brackets (Under 20, 20–29, etc.)
3. Aggregates:
   - Total orders
   - Total sales
   - Total quantity purchased
   - Unique products
   - Lifespan (months)
4. Calculates KPIs:
   - Recency (months since last order)
   - Average order value (AOV)
   - Average monthly spend

SQL Functions Used:
- COUNT(), SUM(), MAX(), MIN(), DATEDIFF(), CASE WHEN
- CTEs (modular logic)
- CREATE VIEW for reusability

===============================================================================
*/

-- Drop if it already exists
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

-- Create the product report view
CREATE VIEW gold.report_customers AS

-- Base CTE: Join core sales and customer data
WITH base_query AS (
	SELECT 
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATEDIFF(year, c.birthdate, GETDATE()) AS age
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
	WHERE f.order_date IS NOT NULL
),

-- Aggregation CTE: Aggregate customer-level stats
customer_aggregations AS (
	SELECT 
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY 
		customer_key,
		customer_number,
		customer_name,
		age
)

-- Final Select: Enriched customer report
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,

	-- Age segmentation
	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,

	-- Customer segmentation
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,

	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,

	-- Average Order Value (AOV)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,

	-- Average Monthly Spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_spend

FROM customer_aggregations;
GO

-- Sample usage: Analyze customer segments and total value contribution
SELECT 
	customer_segment,
	COUNT(customer_number) AS total_customers,
	SUM(total_sales) AS total_sales
FROM gold.report_customers
GROUP BY customer_segment;
GO

