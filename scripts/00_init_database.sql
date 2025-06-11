/*
===========================================================
SQL Data Warehouse - EDA Layer Initialization Script
===========================================================

Purpose:
This script sets up a dedicated SQL database for Exploratory Data Analysis (EDA) by materializing the Gold-layer views from the main Data Warehouse project.

What It Does:
1. Drops the old `DataWarehouseAnalytics` database (if it exists) to ensure a clean start.
2. Creates a fresh `DataWarehouseAnalytics` database and switches context to it.
3. Creates the `gold` schema.
4. Defines DDL (structure) for three analytics-ready tables:
   - gold.dim_customers
   - gold.dim_products
   - gold.fact_sales
5. Loads each table using a Full Load strategy:
   - Truncates existing data
   - Inserts data from the corresponding Gold views in the `DataWarehouse` database

Assumptions:
- Already have a completed Data Warehouse with Gold views in the `DataWarehouse` database.
- These views are clean and analytics-ready (no further transformation needed).
- This EDA setup is read-optimized and ready for CSV export.
===========================================================
*/

-- Use the master context before database creation
USE master;
GO

-- Drop existing database if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create a fresh EDA database
CREATE DATABASE DataWarehouseAnalytics;
GO

-- Switch to the new database
USE DataWarehouseAnalytics;
GO

-- Create the gold schema only if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END;
GO

-- Create DDL for gold.dim_customers
CREATE TABLE gold.dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    country NVARCHAR(50),
    marital_status NVARCHAR(50),
    gender NVARCHAR(50),
    birthdate DATE,
    create_date DATE
);
GO

-- Create DDL for gold.dim_products
CREATE TABLE gold.dim_products (
    product_key INT,
    product_id INT,
    product_number NVARCHAR(50),
    product_name NVARCHAR(50),
    category_id NVARCHAR(50),
    category NVARCHAR(50),
    subcategory NVARCHAR(50),
    maintenance NVARCHAR(50),
    cost INT,
    product_line NVARCHAR(50),
    start_date DATE
);
GO

-- Create DDL for gold.fact_sales
CREATE TABLE gold.fact_sales (
    order_number NVARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);
GO

-- ============================
-- FULL LOAD GOLD TABLES FOR EDA
-- Source: DataWarehouse.gold views
-- Target: DataWarehouseAnalytics.gold tables
-- ============================

-- Load gold.dim_customers
TRUNCATE TABLE gold.dim_customers;
GO
INSERT INTO gold.dim_customers
SELECT * FROM DataWarehouse.gold.dim_customers;
GO

-- Load gold.dim_products
TRUNCATE TABLE gold.dim_products;
GO
INSERT INTO gold.dim_products
SELECT * FROM DataWarehouse.gold.dim_products;
GO

-- Load gold.fact_sales
TRUNCATE TABLE gold.fact_sales;
GO
INSERT INTO gold.fact_sales
SELECT * FROM DataWarehouse.gold.fact_sales;
GO
