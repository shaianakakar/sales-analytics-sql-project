--Change over time
--Analyze sales performance over time
USE Data_warehouse_analytics
select
Year(order_date) AS Year,
Month(order_date) AS Month,
sum(sales_amount) as TOTAL_SALES,
Count(DISTINCT customer_key) AS Total_Customers,
SUM(Quantity) AS Total_Quantity
from fact_sales
where order_date is not null
Group by Year(order_date), Month(order_date)
order by Year(order_date), Month(order_date) DESC

--Cumulative Analysis
--Calculate the total sales of the month and the running sales over time 
SELECT 
ORDER_DATE,
TOTAL_SALES,
SUM(Total_sales) OVER (Partition by Order_date ORDER BY Order_date) AS Running_total_sales,
AVG(Total_sales) OVER (Order by order_date) AS Running_total_average
From 
(
Select 
DATETRUNC(month, order_date) AS Order_date,
SUM(sales_amount) AS Total_sales
from fact_sales
where Order_date IS NOT NULL
group by DATETRUNC(month, order_date)
)t

--Performance Analysis
--Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the previous years sales
;WITH Yearly_performance AS (
Select 
Year(s.Order_date) AS Order_year,
p.product_name,
SUM(s.sales_amount) Total_sales
from fact_sales as s
left join dim_products as p
on p.product_key = s.product_key
Where s.order_date IS NOT NULL
Group by Year(s.Order_date), p.product_name
)

Select 
Order_year,
Product_name,
Total_sales,
AVG(Total_sales) Over(Partition by Product_name) AVG_sales,
Total_sales - AVG(Total_sales) Over(Partition by Product_name) AS Diff_avg,
Case when Total_sales - AVG(Total_sales) Over(Partition by Product_name) > 0 Then 'ABOVE AVG'
when Total_sales - AVG(Total_sales) Over(Partition by Product_name) < 0 Then 'Below avg'
ELSE 'AVG'
END AVG_change,
LAG(Total_sales) OVER( partition by product_name order by order_year) AS previous_year_sales,
Total_sales - LAG(Total_sales) OVER( partition by product_name order by order_year) AS Diff_py,
CASE WHEN Total_sales - LAG(Total_sales) OVER( partition by product_name order by order_year) > 0 THEN 'Increase'
WHEN Total_sales - LAG(Total_sales) OVER( partition by product_name order by order_year) < 0 Then 'Decrease'
else 'No change'
End Diff_sales_py
from Yearly_performance

USE Data_warehouse_analytics
--Part-to-whole analysis
--which category contribute most to the overall sales?
WITH Category_sales AS (
select 
p.category,
SUM(s.sales_amount) AS total_sales
from fact_sales as s
left join dim_products as p
on s.product_key = p.product_key
Group by Category)

Select 
category,
Total_sales,
SUM(Total_sales) over () AS Overall_sales,
Concat(ROUND((Cast(Total_sales AS float) / SUM(Total_sales) over ())*100, 2), '%') AS Percentage
from Category_sales
Order by Total_sales DESC