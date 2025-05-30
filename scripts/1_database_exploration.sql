/*
===========================================================
Database Exploration
===========================================================

Goal:
Quickly explore and understand the structure of the analytics-ready Gold layer tables in the `DataWarehouseAnalytics` database.

What It Does:
1. Lists all available tables in the database
2. Inspects column structures for each table (dim_customers, dim_products, fact_sales)

Output:
- Table list for reference
- Column metadata for each Gold table to understand fields, types, and names before analysis

===========================================================
*/

-- Explore all tables in the database
SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Explore all columns in dim_customers
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
ORDER BY ORDINAL_POSITION;
GO

-- Explore all columns in dim_products
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
ORDER BY ORDINAL_POSITION;
GO

-- Explore all columns in fact_sales
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
ORDER BY ORDINAL_POSITION;
GO
