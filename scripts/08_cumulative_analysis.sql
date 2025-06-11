/*
===========================================================
Advanced Phase 08 - Cumulative Analysis
===========================================================

Purpose:
Understand whether the business is growing or declining over time by calculating cumulative sales
and tracking changes in average prices.

What It Does:
- Calculates total sales for each month
- Adds a running (cumulative) total of sales using window functions
- Computes the moving average of the monthly price to observe pricing trends

SQL Functions Used:
- SUM(), AVG()
- GROUP BY, ORDER BY
- DATETRUNC()
- Window functions: SUM() OVER (), AVG() OVER ()

NOTE on PARTITION BY:
- In this context, PARTITION BY is not required unless we want to reset the cumulative total or
  moving average by category (e.g., year, region).
- If used, it would group rows within each partition separately before applying the window function.

===========================================================
*/

-- 1. Monthly total sales
SELECT 
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
GO

-- 2. Cumulative (Running Total) of Monthly Sales
-- This shows how sales are increasing month over month over time
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM (
    SELECT 
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t
ORDER BY order_date;
GO

-- 3. Moving Average of Monthly Price
-- Smooths short-term fluctuations and highlights trends
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_average_price
FROM (
    SELECT 
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t
ORDER BY order_date;
GO
