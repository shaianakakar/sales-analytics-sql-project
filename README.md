# 📊 SQL Sales Analytics & Data Warehouse Project

## 🔗 Project Summary
This project demonstrates SQL-based sales analytics using a star schema data model. It includes KPI development, customer segmentation, product performance analysis, and business reporting using views.

---
# 📊 SQL Sales Analytics & Data Warehouse Project

## 📌 Project Overview

This project is a complete SQL-based data analytics solution built on a sales data warehouse. It transforms raw transactional data into structured business insights using SQL techniques such as CTEs, joins, aggregations, window functions, and KPI calculations.

The project focuses on analyzing **customers, products, and sales performance** to support data-driven decision-making.

---

## 🎯 Business Objectives

The main goals of this project are:

* Understand overall business performance using key metrics
* Analyze customer behavior and segmentation
* Evaluate product performance across categories
* Track sales trends over time
* Build reusable reporting views for analytics

---

## 🧱 Data Sources

The analysis is based on a star-schema model:

* **fact_sales** → transactional sales data
* **dim_customers** → customer demographics
* **dim_products** → product details

---

## 🔍 Exploratory Data Analysis (EDA)

The project begins with database exploration:

* Schema inspection using `INFORMATION_SCHEMA`
* Understanding table structures and relationships
* Checking distinct values (country, category, subcategory)
* Time range analysis of orders
* Customer age distribution
* Basic business metrics (sales, quantity, orders, customers, products)

---

## 📈 Key Business Metrics

The following KPIs were calculated:

* Total Sales
* Total Quantity Sold
* Average Price
* Total Orders
* Total Customers
* Total Products
* Revenue by Customer
* Revenue by Category

---

## 📊 Analytical Breakdown

### 1. Magnitude Analysis

* Customers by country and gender
* Products by category
* Average cost per category
* Revenue contribution by category

---

### 2. Ranking Analysis

* Top 5 best-performing products
* Bottom 5 worst-performing products

---

### 3. Time Series Analysis

* Monthly sales trends
* Customer activity over time
* Quantity and revenue trends

---

### 4. Cumulative Analysis

* Running total sales over time
* Running average sales performance

---

### 5. Performance Analysis

* Year-over-year product performance
* Comparison against product averages
* Growth/decline tracking using LAG functions

---

### 6. Advanced Segmentation

#### Customer Segmentation

Customers are grouped into:

* **VIP** → High spenders with long activity history
* **Regular** → Moderate spenders with history
* **New** → Recent customers

#### Product Segmentation

Products are categorized as:

* High Performers
* Mid-Range Products
* Low Performers

---

## 🧮 Advanced SQL Techniques Used

This project demonstrates strong SQL capabilities:

* Common Table Expressions (CTEs)
* Window Functions (LAG, AVG OVER, SUM OVER)
* CASE statements for segmentation
* Data aggregation and grouping
* Date functions (DATEDIFF, DATETRUNC)
* NULL handling and safe division
* Views for reusable reporting layers

---

## 📊 Final Reporting Layer

### Customer Report (`dbo.Customers_report`)

A structured view that includes:

* Customer demographics (age, name, ID)
* Segmentation (VIP, Regular, New)
* KPIs:

  * Recency
  * Total orders
  * Total sales
  * Average order value
  * Monthly spend

---

### Product Report (`dbo.product_report`)

A structured view that includes:

* Product attributes (category, subcategory, cost)
* Performance segmentation
* KPIs:

  * Total sales
  * Total orders
  * Average order revenue
  * Recency
  * Monthly revenue
  * Lifespan

---

## 📌 Key Insights

* A small group of customers contributes a large portion of revenue (VIP segment)
* Certain product categories consistently outperform others in sales
* Product performance varies significantly over time
* Customer behavior can be effectively segmented using SQL-based KPIs

---

## 🛠️ Tools & Technologies

* SQL Server
* T-SQL
* SQL Server Management Studio (SSMS)

---

## 🚀 Project Outcome

This project demonstrates how raw transactional data can be transformed into a structured analytics system capable of supporting:

* Business reporting
* Customer segmentation
* Product performance tracking
* KPI-driven decision-making

---

## 📂 Future Improvements

* Add profit margin analysis
* Build Power BI dashboard on top of views
* Optimize queries using indexing
* Add cohort analysis for customers
