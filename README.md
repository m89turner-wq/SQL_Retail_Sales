
# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `p1_retail_db`

This project showcased a range of SQL techniques I used to explore, clean, and analyze retail sales data. I structured the database from scratch, performed exploratory analysis, and answered business-critical questions through targeted queries. The work reflected my ability to combine technical precision with clear, readable code—serving as both a learning milestone and a portfolio piece that demonstrates my approach to data storytelling.

## Objectives

1. **Created and populated a structured retail sales database using SQL.**
2. **Cleaned and validated the dataset to ensure consistency and integrity.**
3. **Explored the data through descriptive queries and summary statistics.**
4. **Answered targeted business questions to uncover trends, customer behavior, and category performance.**

## Project Structure

### 1. Database Setup

- **Database Creation**: The project started by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` was created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount. I realised there was a typo in the quantity column, so corrected this.

```sql
CREATE DATABASE sql_project_p1;

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

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;
```

### 2. Data Exploration

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.


### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05.**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND
    quantity >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category,
	SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
	category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY
	category,
    gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales.**:
```sql
SELECT
	customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
	category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

11. **Write a SQL query to identify which age group contributes the most to total sales in each category.**:
```sql
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
```

12. **Write a SQL query to identify which day of the week sees the highest number of transactions.**:
```sql
SELECT
	DAYNAME(sale_date) as day_of_week,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY day_of_week
ORDER BY total_orders DESC
LIMIT 1;
```

13. **Write a SQL query to identify profit margins by category.**:
```sql
SELECT 
  category,
  ROUND(AVG((total_sale - cogs) / total_sale), 2) AS avg_margin
FROM retail_sales
GROUP BY category
ORDER BY avg_margin DESC;
```

## Findings

- **Customer Demographics**: Identified customer demographics and purchasing patterns across categories.
- **High-Value Transactions**: Flagged high-value transactions exceeding £1000, suggesting potential for loyalty targeting.
- **Sales Trends**: Analysed monthly sales trends to highlight seasonal peaks and operational planning opportunities. 
- **Customer Insights**: Ranked top-spending customers and revealed category preferences for segmentation strategies.

## Reports

- **Sales Summary**: A detailed report summarising total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Author - Michael Turner-Fitzgerald

Hi, I'm Michael Turner-Fitzgerald, a financial services professional pivoting into data analytics and visualisation. With a background in risk management and relationship strategy, I bring a unique blend of precision, creativity, and business acumen to every project. This SQL analysis is part of a broader portfolio that includes interactive dashboards, analysis, and data storytelling.

- **Website**: https://www.mturnfitz.co.uk/
- **LinkedIn**: https://www.linkedin.com/in/michael-turner-fitzgerald-624953197/

Thanks for exploring this project. I welcome feedback, collaboration, and conversation.
