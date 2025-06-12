/*
===============================================================================
Advanced Phase 13 - Product Report View
===============================================================================

Purpose:
This report combines key product-level insights to provide an overall understanding of how each product is performing.

What It Does:
1. Extracts key fields, including product name, category, subcategory, and cost.
2. Segment products by total revenue:
   - High-Performer
   - Mid-Range
   - Low-Performer
3. Aggregates useful metrics for each product:
   - total orders
   - total quantity sold
   - total sales
   - total customers (unique)
   - lifespan (how long the product has been selling)
4. Calculates performance KPIs:
   - recency (months since last sale)
   - average order revenue (AOR)
   - average monthly revenue
   - average selling price

SQL Concepts Used:
- CTEs
- Aggregations
- CASE for segmentation
- NULLIF, ROUND, DATEDIFF
===============================================================================
*/

-- Drop if it already exists
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

-- Create the product report view
CREATE VIEW gold.report_products AS

WITH base_query AS (
    -- Step 1: Get core data from sales and products
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (
    -- Step 2: Aggregate product-level metrics
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost
)

-- Step 3: Final output with KPIs and segmentation
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,

    -- Segment product by total revenue
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
GO

