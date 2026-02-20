# Ecommerce-sales-data-warehouse
SQL-based Star Schema Data Warehouse built in PostgreSQL to transform raw e-commerce transactions into an analytics ready system with ETL processing, indexing, and business intelligence queries.

## The Story Behind This Project
Raw data tells you what happened.
A data warehouse tells you why it happened and what to do next.
This project began with a messy retail dataset loaded into a staging table (Ecommerce-Salesdb) the dataset contained:
- Cancelled invoices
- Missing customers
- Inconsistent country names
- Transaction-level noise

## The Problem
How do we transform raw e-commerce sales data into a scalable, analytics-ready data warehouse?

### Step 1: From Chaos to Structure
Instead of analyzing raw transactional data directly, I designed a Star Schema:
**FactSales** → Core fact table containing revenue data
**DimCustomer** → Customer information
**DimProduct** → Product catalog
**DimCountry** → Geographic segmentation
**DimDate** → Time-based analysis

            DimCustomer
                 |
DimCountry — FactSales — DimProduct
                 |
              DimDate
By separating facts from dimensions, this design enables faster, cleaner, and scalable analytics.

### Step 2: Data Cleaning (Reality of Real Data)
Before generating insights, the data had to be trusted:
- Removed cancelled invoices (InvoiceNo LIKE 'C%')
- Removed NULL customers
- Standardized country and product values
- Created DateKey in YYYYMMDD format
- Calculated TotalAmount = Quantity × UnitPrice
After cleaning, data flowed from:
**Staging → Dimension Tables → Fact Table**
This simulates a real-world ETL process.

### Step 3: ETL & Warehouse Implementation
Pipeline Flow:
### CSV → StagingRetail → Dimension Tables → FactSales
The FactSales table became the analytical engine, connected via foreign keys to all dimensions.
Performance Optimization
Indexes created on:
- ProductKey
- CustomerKey
- DateKey
This significantly improves join and aggregation performance on large datasets.

### Step 4: Business Intelligence Layer
Once structured, analytics became simple and powerful.
Key Insights Discovered
- A small subset of products contributes to a large portion of total revenue (Pareto effect)
- Revenue is concentrated in specific countries
- Some products show high sales velocity but low margins
- Certain items show declining monthly trends candidates for discounting or discontinuation

## Business Impact
This project demonstrates that:
- Raw transactional data can be transformed into strategic insights
- A well-designed data warehouse improves scalability and performance
- SQL alone can power strong business intelligence
- Indexing plays a crucial role in query optimization
The architecture is production-ready and can integrate with:
Power BI,Tableau

### Tech Stack
- PostgreSQL
- SQL (DDL, DML, Analytical Queries)
- Star Schema Modeling
- Index Optimization

### Conclusion
This project transforms unstructured e-commerce transactions into a scalable Star Schema data warehouse.

It highlights:
- Structured data engineering thinking
- Dimensional modeling best practices
- Performance optimization
- Business-oriented analytics design
