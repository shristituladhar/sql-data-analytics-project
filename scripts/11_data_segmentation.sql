/*
===========================================================
Advanced Phase 11 - Data Segmentation
===========================================================

Purpose:
Break down data into meaningful customer or product groups based on defined rules, such as spending levels or product cost tiers.

What it does:
- Segments products into price-based ranges and counts how many fall into each tier
- Groups customers into behavioral categories (VIP, Regular, New) based on lifespan and total spending
- Shows both detailed segmentation and overall counts per segment

SQL Functions Used:
- SUM(), MIN(), MAX(), COUNT(), DATEDIFF()
- CASE WHEN for custom grouping
- GROUP BY, ORDER BY
- CTEs to modularize logic

===========================================================
*/

-- Segment products into cost ranges and count how many products fall into each segment

WITH product_segments AS (
	SELECT 
		product_key,
		product_name,
		cost,
		CASE 
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;
GO

-- Segment customers into three groups:
-- - VIP: lifespan ≥ 12 months and total spending > $5000
-- - Regular: lifespan ≥ 12 months and total spending ≤ $5000
-- - New: lifespan < 12 months

WITH customer_spending AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)

SELECT 
	customer_key,
	total_spending,
	lifespan,
	CASE 
		WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM customer_spending;
GO

-- Count the total number of customers in each segment

WITH customer_spending AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)

SELECT 
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT 
		customer_key,
		CASE 
			WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment
	FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
GO
