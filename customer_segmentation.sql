--Data segmentation
--Segment products into cost ranges and count how many products fall into each segment
WITH data_segmentation as (
select 
product_key,
product_name,
cost,
Case when cost < 100 then 'below 100'
when cost between 100 and 500 then '100-500'
when cost between 500 and 1000 then '500-1000'
else 'above 1000'
END cost_range
from dim_products)

select 
cost_range,
Count(product_key) as total_products
from data_segmentation
group by cost_range 
order by cost_range desc

--Group customers based on their spending behaviour :
-- Vip customers with at least 12 months of history and spending more than 5000
-- Regular customers with at least 12 months of history and spending less than 5000 
-- new customers with less than 12 months of history 
--And find the total number of customers by each group
WITH Data_segments as (
Select
c.customer_key,
SUM(s.sales_amount) AS Total_sp,
Min(s.order_date) AS First_order,
MAX(s.Order_date) AS Last_order,
DATEDIFF(month, Min(s.order_date), MAX(s.Order_date)) AS Lifespan
from fact_sales as s
left join dim_customers as c
ON s.customer_key = c.customer_key
group by c.customer_key)

select
case_segments,
count(customer_key) AS Total_customers
from (
Select
Customer_key,
Total_sp,
Case when Lifespan >= 12 and Total_sp >= 5000 then 'VIP'
when lifespan >= 12 and Total_sp <= 5000 then 'regular'
else 'NEW'
end Case_segments
from Data_segments)t
group by Case_segments
order by Total_customers DESC