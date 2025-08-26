--create database for Retail Sales Analysis
CREATE DATABASE sql_project_p1


-- create table
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	);
    
    
-- rename Quantity column
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

    
-- count rows of data imported (MySQL has not imported NULL rows)
SELECT COUNT(*) FROM retail_sales;


-- Data Exporation

-- How many sales are there?
SELECT COUNT(*) as total_sales FROM retail_sales;


-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;


-- what product categories do we have?
SELECT DISTINCT category FROM retail_sales;


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND
    quantity >= 4;
    
    
-- Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
	category,
	SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;


-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY
	category,
    gender
ORDER BY 1;


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
    month,
    avg_sales
FROM
(
	SELECT
		YEAR(sale_date) as year,
		MONTH(sale_date) as month,
		AVG(total_sale) as avg_sales,
		RANK() OVER(
			PARTITION BY YEAR(sale_date) 
			ORDER BY AVG(total_sale) DESC
		) AS ranking
	FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE ranking = 1;


-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT
	customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales
AS
(
SELECT *, 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;


-- Write a SQL query to identify which age group contributes the most to total sales in each category?
SELECT category, 
       CASE 
         WHEN age < 25 THEN 'Under 25'
         WHEN age BETWEEN 25 AND 40 THEN '25–40'
         WHEN age BETWEEN 41 AND 60 THEN '41–60'
         ELSE '60+' 
       END AS age_group,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category, age_group
ORDER BY 2, 1;


-- Write a SQL query to identify which day of the week sees the highest number of transactions?
SELECT
	DAYNAME(sale_date) as day_of_week,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY day_of_week
ORDER BY total_orders DESC
LIMIT 1;


-- Write a SQL query to identify profit margins by category
SELECT 
  category,
  ROUND(AVG((total_sale - cogs) / total_sale), 2) AS avg_margin
FROM retail_sales
GROUP BY category
ORDER BY avg_margin DESC;


-- End of Project



