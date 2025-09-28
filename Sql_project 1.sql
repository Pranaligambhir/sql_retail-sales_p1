CREATE DATABASE sql_project;


---data query----

CREATE TABLE retail_sales(
transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
    customer_id	INT,
    gender VARCHAR(15),
    age INT,	
    category VARCHAR(50), 
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
    );
	
----

SELECT * FROM retail_sales
LIMIT 10; 

SELECT 
    COUNT(*)
FROM retail_sales

-----DATA CLEANING----

SELECT * FROM retail_sales
WHERE sale_date is NULL


SELECT * FROM retail_sales
WHERE transactions_id is NULL


SELECT * FROM retail_sales
WHERE transactions_id is NULL

-----

SELECT * FROM retail_sales
WHERE
      transactions_id IS NULL 
	  OR
	  sale_date IS NULL 
	  OR 
      sale_time IS NULL 
	  OR
	  gender IS NULL 
	  OR 
      category IS NULL 
	  OR
	  quantiy IS NULL 
	  OR 
      cogs IS NULL 
	  OR
	  total_sale IS NULL;
	  
-------

DELETE FROM retail_sales
WHERE
   transactions_id IS NULL 
	  OR
	  sale_date IS NULL 
	  OR 
      sale_time IS NULL 
	  OR
	  gender IS NULL 
	  OR 
      category IS NULL 
	  OR
	  quantiy IS NULL 
	  OR 
      cogs IS NULL 
	  OR
	  total_sale IS NULL;

	  ---data exploration---
	  
--How many sales do we have ?--

SELECT COUNT(*)as total_sales FROM retail_sales


--How many customers do we have ?--

SELECT COUNT(customer_id)as total_sales FROM retail_sales

--How many categories do we have ?--

SELECT Distinct category as total_sales FROM retail_sales



----DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS---


-- My Analysis & Findings--

--DATA EXPLORATIOIN--

--Q.1 Write a sql query to view first 10 rows 
--Q.2 Write a sql query to count total number of transactions 
--Q.3 Write a sql query to find the number of unique customers
--Q.4 Write a SQL query to retrieve all columns for sales made on '2022-11-05
--Q.5 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

--SALES AND REVENUE ANALYSIS--

--Q.1 Write a SQL query to calculate total revenue 
--Q.2 Write a SQL query to calculate total sales by category
--Q.3 Write a SQL query to find top 5 customers by purchase value
--Q.4 Write a SQL query to calculate the total sales (total_sale) for each category.
--Q.5 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--Q.6 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

--CUSTOMER DEMOGRAPHICS--

--Q.1 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--Q.2 Write a SQL query to Calculate daily sales trend
--Q.3 Write a SQL query to Calculate monthly sales trend
--Q.4 Write a SQL query to find th best selling day

--TIME BASED ANALYSIS--

--Q.1 calculate aversge sale for each month and find best selling month
--Q.2 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--Q.3 Write a SQL query to find the number of unique customers who purchased items from each category.
--Q.4 Write a SQL query to find the top 5 customers based on the highest total sales 
--Q.5 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

--DATA EXPLORATION--

--1.Write a sql query to view first 10 rows 
SELECT * 
FROM retail_sales
LIMIT 10;

--2.write a sql query to count total number of transactions 

SELECT COUNT(*)AS total_transactions 
FROM retail_sales;

--3.Write a sql query to find the number of unique customers

SELECT COUNT(DISTINCT customer_id)AS 
unique_customers 
FROM retail_sales;

--4.Write a sql query to retrive all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--5.Retrive all transactions where the category is clothing and the quantity sold is more than 10 in the month of nov-2022

SELECT
  *
FROM retail_sales
WHERE category = 'Clothing'
 AND
 TO_CHAR(sale_date,'YYYY-MM')='2022-11'

 
 --Sales and Revenue Analysis--

 --1.calculate total revenue 
 
 SELECT SUM(total_sale)AS
 total_revenue
 FROM retail_sales;

--2.calculate total sales by category

SELECT category,SUM(total_sale)AS
total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

--3.find top 5 customers by purchase value

SELECT customer_id,SUM(total_sale)AS
total_spent 
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

--4.calculate total sales for each category

SELECT 
      category,
	  SUM(total_sale) AS net_sales,
	  COUNT(*)as total_orders
FROM retail_sales
GROUP BY 1;

--5.sql query to find total number of transactions (transactions_id) made by each gender in each category

SELECT 
   category, 
   gender,
   COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, 
         category
ORDER BY 1;

--6.Write a sql query to find the number of unique customers who purchased items from each category


SELECT 
    category, 
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

--Customer Demographics--

--1.Find average age of customers--

SELECT AVG(age)AS avg_customer_age
FROM retail_sales
WHERE age IS NOT NULL;

--2.find total sales by gender--

SELECT gender,SUM(total_sale)AS
total_sales
FROM retail_sales
GROUP BY gender;

--3.find average transaction value by  gender

SELECT gender,AVG(total_sale)AS
total_sales
FROM retail_sales
GROUP BY gender;


--4.find the average age of customers who purchased items from the 'beauty' category.---

SELECT 
AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Time-Based Analysis-- 

--1.calculate daily sales trends--

SELECT sale_date, SUM(total_sale) AS daily_sales
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;

--2.calculate monthly sales trend--

SELECT EXTRACT(YEAR FROM sale_date) AS year, 
       EXTRACT(MONTH FROM sale_date) AS month,
	   SUM(total_sale) AS monthly_sales
FROM retail_sales
GROUP BY 1,2
ORDER BY year, month;

--3.Find best selling day--

SELECT sale_date, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY sale_date
ORDER BY total_sales DESC
LIMIT 1;

--4.write the sql query to calculate the average sale for each month .Find out best selling month in each year--


SELECT
    year,
	month,
	avg_sale
FROM 
( 
SELECT 
   EXTRACT(YEAR FROM sale_date) as year,
   EXTRACT(MONTH FROM sale_date) as month,
   AVG(total_sale) AS avg_sale,
   RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC)as rank
FROM retail_sales
GROUP BY 1,2
)as t1
WHERE rank=1

--Performance and Insights--

---1.sql query to find all transactions where the total_sale is greater than 1000.---

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;


--2.Write a sql query to find the top 5 customers based on the highest total sales --

SELECT 
     customer_id, 
	 SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--3.write a sql query to create each shift and number of orders(Example Morning<=12,Afternoon Between 12&17,Evening>17)--


WITH hourly_sale
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
	 COUNT(*) as total_orders
	 FROM hourly_sale
	 GROUP BY shift;
	 
---END OF PROJECT---