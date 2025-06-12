/*
===========================================================
Advanced Phase 09 - Performance Analysis
===========================================================

Purpose:
Evaluate yearly product performance by comparing each product's current sales
against two key targets:
1. The product's historical average (target benchmark)
2. The previous year's sales (trend direction)

What it does:
- Calculates total sales per product per year
- Compares yearly sales to average sales using window functions
- Computes year-over-year (YoY) change for each product
- Classifies performance as 'Above Avg', 'Below Avg', or 'Increase/Decrease'

SQL Functions Used:
- SUM(), AVG(), LAG()
- CASE WHEN
- GROUP BY, ORDER BY
- Window functions: OVER(), PARTITION BY, ORDER BY
===========================================================
*/

-- Compare each product's yearly sales to its average and the previous year

WITH yearly_product_sales AS (
	SELECT 
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	-- Average sales across all years for that product
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	-- Difference from average
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	-- Label above/below/avg
	CASE 
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,
	-- Previous year's sales for the same product
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
	-- Difference from pthe revious year
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py_sales,
	-- Year-over-year trend label
	CASE 
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;
GO
