--Build customers report
--Customer Report :
--Purpose : 
  ----This report consolidates key customer metrics and behaviour

  --Highlights :
  --1. Gather essential feilds such as names , ages and transaction details
  --2. segments customers into categories (VIP, Regular, New) and age groups
  --3. Aggregate customer-level metrics:
  ---Total orders
  ---Total sales
  ---Total quantity purchased
  ---Total products
  ---Lifespan (in months)
  --4. Calculate valuable KPIs
  ---recency (months since last order)
  ---average order value
  ---average monthly spend

  CREATE VIEW dbo.Customers_report AS
  WITH Base_query AS (
  --1. Base query : Retrives the core columns from tables
 Select
  f.order_number,
  f.product_key,
  F.order_date,
  f.sales_amount,
  f.quantity,
  c.customer_key,
  c.customer_number,
  Concat(c.first_name,' ',c.last_name) AS Customer_name,
  c.birthdate,
  DATEDIFF(year, c.birthdate, GETDATE()) AS Age
  FROM fact_sales as f
  left join dim_customers as c
  on f.customer_key = c.customer_key
  Where f.order_date is not null)

  --Customer aggregation : summarizes key metrics at the customer-level
  , Customer_aggregation AS (
  Select 
  customer_key,
  customer_number,
  customer_name,
  age,
  count(distinct order_number) AS Total_orders,
  SUM(sales_amount) AS Total_sales,
  SUM(quantity ) AS Total_quantity,
  Count(DISTINCT Product_key) AS Total_products,
  MAX(order_date) AS Last_order,
  DATEDIFF(month, Min(order_date), MAX(Order_date)) AS Lifespan
  from base_query
  group by 
  customer_key,
  customer_number,
  customer_name,
  age
  )
  

  select
  customer_key,
  customer_number,
  customer_name,
  age,
  Case when age < 20 then 'Below 20'
  when age between 20 and 29 then '20-29'
  when age between 30 and 39 then '30-39'
  when age between 40 and 49 then '40-49'
  else 'above 50'
  END age_group,
  Case 
  when Lifespan >= 12 and Total_sales > 5000 then 'VIP'
  when lifespan >= 12 and Total_sales <= 5000 then 'regular'
  else 'NEW'
  END AS customer_segments,
  -- compute Recency
  DATEDIFF (MONTH, last_order, getdate()) AS Recency,
  Total_orders,
  Total_sales,
  Total_quantity,
  Total_products,
  Last_order,
  Lifespan,
  --comoute average order value (AVO)
  Total_sales/Total_orders AS avg_order_value,
  --Averag monthly spend
  Case when lifespan = 0 then Total_sales
  else Total_sales/Lifespan
  end Monthly_spend
  from Customer_aggregation