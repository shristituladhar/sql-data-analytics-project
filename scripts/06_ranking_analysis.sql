
/*
===========================================================
EDA Phase 06 - Ranking Analysis
===========================================================

Purpose:
Identify the top and bottom performers across key metrics such as revenue, orders, and customer contributions using both simple and advanced SQL ranking techniques.

What It Does:
- Ranks products and subcategories by total revenue
- Finds the worst-performing products by sales
- Lists top 10 revenue-generating customers
- Finds customers with the fewest orders
- Demonstrates both basic and window-function-based ranking

SQL Functions Used:
- SUM(), COUNT()
- GROUP BY, ORDER BY, TOP
- ROW_NUMBER() OVER ()

===========================================================
*/

-- Top 5 products by total revenue (Simple ranking)
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
GO

-- Top 5 products by revenue using ROW_NUMBER() for flexible ranking
SELECT *
FROM (
    SELECT 
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.dim_products p
    LEFT JOIN gold.fact_sales f
        ON f.product_key = p.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;
GO

-- Top 5 subcategories by total revenue
SELECT TOP 5 
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
    ON f.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;
GO

-- Bottom 5 products by total revenue
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
    ON f.product_key = p.product_key
WHERE f.sales_amount IS NOT NULL
GROUP BY p.product_name
ORDER BY total_revenue;
GO

-- Top 10 customers by revenue
SELECT TOP 10 
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS highest_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY highest_revenue DESC;
GO

-- Bottom 3 customers by number of orders
SELECT TOP 3 
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS orders_placed
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY orders_placed;
GO
