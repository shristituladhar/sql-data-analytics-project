# SQL Data Analytics Project

Welcome to my hands-on **SQL Data Analytics Project**, built on top of a fully structured Data Warehouse using Medallion Architecture (Bronze → Silver → Gold).
This repo focuses on **exploratory and advanced data analysis** using clean, analytics-ready data materialized from the Gold views of the companion project: [`sql-data-warehouse`](https://github.com/shristituladhar/sql-data-warehouse-project).

---

## Project Overview

- Source: `sql-data-warehouse` project (Gold layer views)
- This project:
  - Creates a new SQL database for analytics (`DataWarehouseAnalytics`)
  - Materializes Gold views into physical tables
  - Serves as the foundation for visual and statistical analysis
