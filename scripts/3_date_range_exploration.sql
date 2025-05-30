/*
===========================================================
EDA Phase 03 – Measures Exploration
===========================================================

Purpose:
Explore key numeric and date-based fields (measures) to understand the scale and timeline of the dataset.

What It Does:
- Finds the first and last order dates
- Calculates the total range of sales coverage in years and months
- Identifies the youngest and oldest customers with age details

SQL Functions Used:
- MIN(), MAX()
- DATEDIFF()
- GETDATE()

===========================================================
*/

-- Find the date of the first and the last order
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM gold.fact_sales;
GO

-- How many years/months of sales are available
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;
GO

-- Find the youngest and oldest customer
SELECT 
    MIN(birthdate) AS oldest_customer,
    DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_customer,
    DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age,
    DATEDIFF(year, MIN(birthdate), MAX(birthdate)) AS age_difference
FROM gold.dim_customers;
GO
