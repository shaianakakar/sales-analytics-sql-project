--Product Report
  -- This report consolidates the key metrics and behaviour
  --Highlights :
  --1. Gather essential feilds such as Product names ,category, subcategory and cost 
  --2. segments customers into categories High performers, Mid-Range and Low-performers
  --3. Aggregate product-level metrics:
  ---Total orders
  ---Total sales
  ---Total quantity sold
  ---Lifespan (in months)
  --4. Calculate valuable KPIs
  ---recency (months since last order)
  ---average order value
  ---average monthly spend

CREATE VIEW dbo.product_report AS
WITH Base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM fact_sales AS f
    LEFT JOIN dim_products AS p
        ON p.product_key = f.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number) AS Total_orders,
        SUM(sales_amount) AS Total_sales,
        SUM(quantity) AS Total_quantity,
        MAX(order_date) AS Last_sale_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Lifespan,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS Avg_selling_price
    FROM Base_query
    GROUP BY 
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    Last_sale_date,
    DATEDIFF(MONTH, Last_sale_date, GETDATE()) AS Recency,
    CASE 
        WHEN Total_sales > 5000 THEN 'High performer'
        WHEN Total_sales >= 1000 THEN 'Mid-Range'
        ELSE 'Low-performer'
    END AS product_segment,
    Lifespan,
    Total_orders,
    Total_sales,
    Total_quantity,
    CAST(Total_sales AS FLOAT) / NULLIF(Total_orders, 0) AS avg_order_revenue,
    CASE 
        WHEN Lifespan = 0 THEN Total_sales
        ELSE Total_sales / Lifespan
    END AS avg_monthly_revenue
FROM product_aggregations;