/*
===========================================================
EDA Phase 02 - Dimensions Exploration
===========================================================

Purpose:
Understand the key categorical fields (dimensions) within the Gold layer tables that will be used to slice and analyze the data.

What It Does:
1. Lists all unique countries represented by customers in the dataset
2. Lists all unique product categories and subcategories available in the product catalog

Output:
- Clean list of countries for customer-level grouping
- Structured view of product category hierarchy for sales analysis

SQL Concepts/Functions Used:
- DISTINCT
- ORDER BY

===========================================================
*/

-- Explore all countries that customers come from
SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country;
GO

-- Explore all product categories and subcategories
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
GO
