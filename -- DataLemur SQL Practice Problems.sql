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