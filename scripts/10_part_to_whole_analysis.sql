/*
===========================================================
Advanced Phase 10 - Part-to-Whole Analysis
===========================================================

Purpose:
Perform proportional (part-to-whole) analysis to identify which product categories
Contribute the most to overall business performance.

What it does:
- Calculates total sales per product category
- Computes each category's share of total sales as a percentage
- Sorts results to reveal top contributors
- Uses a CTE for cleaner grouping logic before final percentage calculation

SQL Functions Used:
- SUM(), ROUND(), CAST(), CONCAT()
- GROUP BY, ORDER BY
- Window function: SUM(...) OVER ()
- CTE (Common Table Expression): for modularizing category-level aggregation

===========================================================
*/

-- Part-to-whole analysis: Which categories contribute the most to overall sales?

WITH category_sales AS (
	SELECT 
		p.category,
		SUM(f.sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
	GROUP BY p.category
)

SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT(
		ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2),
		'%'
	) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
GO
