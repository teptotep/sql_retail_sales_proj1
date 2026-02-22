-- SQL Retail Sales Analysis- P1

CREATE DATABASE sql_project_p2;


-- Creating Table

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id INT Primary Key,
sale_date date,
sale_time time,
customer_id int, 
gender varchar(15), 
age int, 
category varchar(15), 
quantiy int,
price_per_unit float, 
cogs float, 
total_sale float
);

SELECT * FROM retail_sales
LIMIT 10;

-- 
SELECT COUNT(*) FROM retail_sales;


------  DATA CLEANING -------

-- find columns with NULL as the input
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--- Change the column name from quantiy to quantity. 

ALTER TABLE retail_sales
RENAME quantiy TO quantity;

-- Now continue the process of finding columns with NULL values.

SELECT * FROM retail_sales
WHERE quantity IS NULL;

-- Deleting rows that contain the value NULL

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


----- DATA EXPLORATION---


-- How many sales or transactions do we have?
SELECT COUNT(*) AS total_sales FROM retail_sales;

--- How many customers do we have?
SELECT COUNT(customer_id) AS total_customers FROM retail_sales;

--- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

--- What are the unique categories in the data?
SELECT DISTINCT category FROM retail_sales;



----- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS----
	-- Analysis & Findings
	-- 1. Write a SQL query to retrieve all columns for sales made in November 5, 2022.
	-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3
	-- in the month of November 2022.
	-- 3.Write a SQL query to calculate the total sales for each category
	-- 4. Find the average age of customers who purchased items from the 'Beauty' category.
	-- 5. Find all transactions where the total sale is greater than 1000
	-- 6.  Find the total number of transactions made by each gender in each category.
	-- 7. Calculate the average sale for each month. Find out the best selling month in each year.
	-- 8. Find the top 5 customers based on the highest total sales.
	-- 9.Find the number of unque customers who purchased items from each category
	-- 10. Create each shift and number of orders (Ex. morning <= 12, afternoon between 12 and 17, evening >17)



--------- SOLUTIONS -----
-- 1. Write a SQL query to retrieve all columns for sales made in November 5, 2022.
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3
-- in the month of November 2022.
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
	AND quantity>=4;
-- Another approach would be to change the formatting of the date.
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
	AND TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND quantity>=4;

-- 3.Write a SQL query to calculate the total sales for each category
SELECT category, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY category;


-- 4. Find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS average_age FROM retail_sales
WHERE category= 'Beauty';


-- 5. Find all transactions where the total sale is greater than 1000.
SELECT * FROM retail_sales 
WHERE total_sale>1000;

-- 6.  Find the total number of transactions made by each gender in each category.
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. Calculate the average sale for each month. Find out the best selling month in each year.
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	ROUND(AVG(total_sale)::numeric,2) AS average_sale
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;


-- 8. Find the top 5 customers based on the highest total sales.
SELECT customer_id, 
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- 9.Find the number of unque customers who purchased items from each category
SELECT 
category,
COUNT(DISTINCT customer_id) AS count_unique_customers 
FROM retail_sales
GROUP BY category;

-- 10. Create each shift and number of orders (Ex. morning <= 12, afternoon between 12 and 17, evening >17)
---first, create a shiting column.
SELECT *, 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales;

--- next would be to integrate the number of orders and then minimize the number of columns based on the requirement.
WITH hourly_sale
AS
(
SELECT *, 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


------ END OF PROJECT-------


