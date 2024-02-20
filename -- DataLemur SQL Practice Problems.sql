-- DataLemur SQL Practice Problems


-- 1. Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL. Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

SELECT DISTINCT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL') 
GROUP BY candidate_id
HAVING COUNT(candidate_id) = 3
ORDER BY candidate_id ASC

-- 2. Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket. In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

With CTE as (
  SELECT user_id, COUNT(tweet_id) AS tweets_num 
  FROM tweets 
  WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31' 
  GROUP BY user_id
)
SELECT DISTINCT(tweets_num) AS tweets_bucket,
COUNT(user_id) AS users_num
FROM CTE 
GROUP BY tweets_num;

-- 3. Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page"). Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

SELECT pages.page_id 
FROM pages
FULL OUTER JOIN page_likes ON pages.page_id = page_likes.page_id
WHERE liked_date IS NULL
ORDER BY pages.page_id ASC;

-- 4. Tesla is investigating production bottlenecks and they need your help to extract the relevant data. Write a query to determine which parts have begun the assembly process but are not yet finished. 
-- parts_assembly table contains all parts currently in production, each at varying stages of the assembly process. An unfinished part is one that lacks a finish_date.

SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

-- 5. Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.
-- Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.

WITH views AS (
  SELECT 
  CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END AS laptop_views,
  CASE WHEN device_type IN ('phone','tablet') THEN 1 ELSE 0 END AS mobile_views
  FROM viewership
)
SELECT SUM(laptop_views) as laptop_views, SUM(mobile_views) as mobile_views
FROM views;

-- 6. Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

SELECT user_id, MAX(CAST(post_date as DATE)) - MIN(CAST(post_date AS DATE)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT(user_id) >= 2

-- 7. Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.

SELECT DISTINCT sender_id, COUNT(sent_date) as message_count
FROM messages 
WHERE sent_date BETWEEN '08-01-2022' AND '08-31-2022'
GROUP BY sender_id, message_count
ORDER BY message_count DESC
LIMIT 2;

-- 8. Assume you're given a table containing job postings from various companies on the LinkedIn platform. Write a query to retrieve the count of companies that have posted duplicate job listings.

WITH CTE AS (
  SELECT company_id, title, description, COUNT(DISTINCT job_id)
  FROM job_listings
  GROUP BY company_id, title, description
  HAVING COUNT(DISTINCT job_id) > 1
)

SELECT COUNT(company_id) AS duplicate_companies FROM CTE;

-- 9. Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.
-- Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. Output the city name and the corresponding number of completed trade orders.

SELECT city, COUNT(order_id) as total_orders
FROM trades
JOIN users on trades.user_id = users.user_id
WHERE status = 'Completed'
GROUP BY city
ORDER BY total_orders DESC
LIMIT 3;

-- 10. Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.

SELECT DISTINCT(EXTRACT(MONTH from submit_date)) as mth, product_id, ROUND(AVG(stars), 2) as avg_stars
FROM reviews
GROUP by mth, product_id
ORDER BY mth ASC;

-- 11. Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

SELECT app_id,
ROUND(100.0 *
SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2)  AS ctr_rate
FROM events
WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY app_id;

-- 12. Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account. Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

SELECT DISTINCT user_id
FROM emails 
JOIN texts on emails.email_id = texts.email_id
WHERE signup_action = 'Confirmed' AND action_date = signup_date + INTERVAL '1 day';

-- 13. As a data analyst on the Oracle Sales Operations team, you are given a list of salespeople’s deals, and the annual quota they need to hit.
-- Write a query that outputs each employee id and whether they hit the quota or not ('yes' or 'no'). Order the results by employee id in ascending order.

SELECT DISTINCT deals.employee_id,
CASE WHEN SUM(deal_size) > quota THEN 'yes' ELSE 'no' END AS made_quota
FROM deals
JOIN sales_quotas ON deals.employee_id = sales_quotas.employee_id
GROUP BY deals.employee_id, quota
ORDER BY deals.employee_id ASC;

-- 14. Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights, you're analyzing how many credit cards were issued each month.
-- Write a query that outputs the name of each credit card and the difference in the number of issued cards between the month with the highest issuance cards and the lowest issuance. Arrange the results based on the largest disparity.

SELECT card_name, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

-- 15. You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (item_count table) and the corresponding number of orders for each item count (order_occurrences table).

/*
WITH CTE AS (
  SELECT SUM(item_count * order_occurrences) AS total_items, 
  SUM(order_occurrences) AS total_orders
  FROM items_per_order
)

SELECT ROUND(CAST(total_items/total_orders AS NUMERIC), 1) FROM CTE;
*/ 

SELECT ROUND(CAST(SUM(item_count * order_occurrences) / SUM(order_occurrences) AS NUMERIC), 1) AS mean
FROM items_per_order;

-- 16A. CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. Each drug can only be produced by one manufacturer.
-- Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that there are no ties in the profits. Display the result from the highest to the lowest total profit.

SELECT drug, total_sales - cogs AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC
LIMIT 3;

-- 16B. Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health and calculate the total amount of losses incurred.
-- Output the manufacturer's name, the number of drugs associated with losses, and the total losses in absolute value. Display the results sorted in descending order with the highest losses displayed at the top.

SELECT manufacturer, COUNT(drug) as drug_count, ABS(SUM(total_sales - cogs)) as total_loss
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loss DESC;