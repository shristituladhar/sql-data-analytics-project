# SQL Data Analytics Project

Welcome to my hands-on **SQL Data Analytics Project**, built on top of a fully structured Data Warehouse using Medallion Architecture (Bronze → Silver → Gold).
This repo focuses on **exploratory and advanced data analysis** using clean, analytics-ready data materialized from the Gold views of the companion project: [`sql-data-warehouse`](https://github.com/shristituladhar/sql-data-warehouse-project).

---

## Project Stack

- **Source Systems**: CRM & ERP (CSV files)
- **ETL Pipeline**: SQL-based pipeline with transformations & dimensional modeling (see DWH repo)
- **Model**: Star Schema (`fact_sales`, `dim_products`, `dim_customers`)
- **This Repo**: Performs analytics on top of the Gold Layer using 13 modular SQL scripts
- **Output**: Business-ready SQL Views for dashboards and stakeholder reporting

---

## Folder Structure

```plaintext
/sql-data-analytics-project/
├── eda/
│   ├── 01_data_quality_checks.sql
│   ├── 02_basic_aggregations.sql
│   ├── ...
│   └── 07_change_over_time_analysis.sql
├── advanced/
│   ├── 08_cumulative_analysis.sql
│   ├── 09_performance_analysis.sql
│   ├── ...
│   └── 11_data_segmentation.sql
├── reports/
│   ├── 12_customer_report.sql
│   └── 13_product_report.sql
```

---

## Phase 1: Exploratory Data Analysis (EDA)

Initial exploration to assess data quality, business activity, and behavior patterns.

| Script                          | Description                                           |
|----------------------------------|-------------------------------------------------------|
| `01_data_quality_checks.sql`    | Null checks, duplicates, invalid records             |
| `02_basic_aggregations.sql`     | Overall sales, customers, order volume               |
| `03_top_bottom_entities.sql`    | Top/worst products and customers                     |
| `04_time_analysis.sql`          | Order trends by day, month, year                     |
| `05_customer_behavior.sql`      | Quantity & frequency per customer                    |
| `06_ranking_analysis.sql`       | Rank products/customers using window functions       |
| `07_change_over_time_analysis.sql` | Time series trends using `DATETRUNC()` and `FORMAT()` |

---

## Phase 2: Advanced Analytics

Advanced segmentation and trend analysis using window functions and business rules.

| Script                            | Description                                            |
|----------------------------------|--------------------------------------------------------|
| `08_cumulative_analysis.sql`     | Running totals and moving averages                    |
| `09_performance_analysis.sql`    | Compare current sales vs. average and last year       |
| `10_part_to_whole_analysis.sql`  | Category-wise % contribution to total sales           |
| `11_data_segmentation.sql`       | Segments customers (VIP/Regular/New) and cost tiers   |

---

## Phase 3: Business Reporting Views

Reusable SQL views built for dashboards and business users.

| Script                       | View Name                | Description                                             |
|-----------------------------|--------------------------|---------------------------------------------------------|
| `12_customer_report.sql`    | `gold.report_customers`  | Customer KPIs: Recency, AOV, segments, lifetime value  |
| `13_product_report.sql`     | `gold.report_products`   | Product KPIs: Revenue tier, avg price, sales lifespan  |

---

## SQL Concepts Demonstrated

- SQL Aggregations: `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
- Segmentation: `CASE WHEN`, revenue tiers, RFM-like logic
- Time Analysis: `DATETRUNC()`, `FORMAT()`, `DATEDIFF()`, `GETDATE()`
- Window Functions: `ROW_NUMBER()`, `LAG()`, `SUM() OVER`, `AVG() OVER`
- Reporting Views: `CREATE VIEW`, `IF OBJECT_ID`, reusable SELECT logic
- Clean structure: CTEs (`WITH`), nested subqueries, JOINs

---

## Sample Metrics and KPIs

| Customer Report KPI       | Product Report KPI           |
|---------------------------|------------------------------|
| Recency (Months)          | Recency (Months)             |
| Total Orders              | Total Orders                 |
| Total Sales               | Total Sales                  |
| Total Products Purchased  | Total Quantity Sold          |
| Average Order Value (AOV) | Average Order Revenue (AOR)  |
| Average Monthly Spend     | Average Monthly Revenue      |
| Customer Segment          | Product Segment              |

---

## Next Steps

This analytics layer can be used to power dashboard visualizations in:
- **Power BI**
- **Tableau**
- **Excel Pivot Dashboards**
These SQL views (`report_customers`, `report_products`) are optimized for direct BI connections and serve as the foundation for further exploration, visualization, or predictive modeling.

---

## About This Project

This project is inspired by the "SQL Bootcamp" series by Data With Baraa.
While the concepts and structure draw from the tutorials, all implementation, file organization, analysis logic, and documentation have been developed independently to deepen my understanding and create a polished, real-world portfolio project.

---

## Related Projects

- [SQL Data Warehouse](https://github.com/shristituladhar/sql-data-warehouse-project)
