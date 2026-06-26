SELECT * FROM walmart

-- Find different payment methods and number if transactions, number of qty sold

SELECT 
	payment_method,
	COUNT(*) as no_payments,
	SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method


-- Identify the highest-rated category in each branch, displaying the branch, category, avg rating

SELECT *
FROM
(	SELECT
		branch, 
		category,
		AVG(rating) as avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
	FROM walmart
	GROUP BY 1,2
)
WHERE rank = 1


-- Identify the busiest day for each branch based on the number of transactions

SELECT *
FROM
	(SELECT
		branch,
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
		COUNT(*) as no_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1,2
	)
WHERE rank = 1


-- Determine the average, minimum and maximum rating of products for each city. List the city, average_rating, min_rating and max_rating.

SELECT
	city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1,2


-- Calculate the total profit for each category by considering total_profit as (unit_price* quantity * profit_margin). List the category and total_profit, ordered from highest to lowest profits.

SELECT 
	category,
	SUM(total) as total_revenue,
	SUM(total*profit_margin) as profit
FROM walmart
GROUP BY 1


-- Determine the most common payment method for each Branch, display Branch and the preferred payment method

WITH cte
AS
(SELECT
	branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart
GROUP BY 1,2
)
SELECT *
FROM cte
WHERE rank = 1


-- Categorize sales into 3 groups Morning, Afternoon, Evening. Find out each of the shift and number of invoices.

SELECT
	branch,
CASE
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC
