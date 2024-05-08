CREATE DATABASE apple;

/* Q. Give recommendations to the new and aspiring app developer to make the best app based on the Apple Store data analysis. */


/* DATA CLEANING */

ALTER TABLE applestore 
DROP COLUMN `MyUnknownColumn_[0]`,
DROP COLUMN `MyUnknownColumn_[1]`;

ALTER TABLE applestore 
RENAME COLUMN `MyUnknownColumn` TO `s/n`;


/* EDA */

-- 1. Check for missing values
SELECT COUNT(*) AS Missing_values
FROM applestore
WHERE track_name is null or user_rating is null or prime_genre is null;

-- 2. No. of apps per genre
SELECT prime_genre, count(*) as track_count
FROM applestore
GROUP BY prime_genre
ORDER BY track_count DESC;

-- 3. Overview of app ratings
SELECT min(user_rating) as min_rating
	  ,max(user_rating) as max_rating
      ,round(avg(user_rating), 2) as avg_rating
FROM applestore;

-- 4. Top 20 most popular apps
SELECT rank() over (order by rating_count_tot DESC) as ranking 
		,track_name
        ,rating_count_tot 
        ,user_rating 
        ,prime_genre
FROM applestore
LIMIT 20;


/* DATA ANALYSIS */

-- 1. Determine whether paid apps have better rating than free apps
SELECT
	CASE
		WHEN price = 0 then 'Free'
        ELSE 'Paid'
	END AS App_type,
    round(avg(user_rating), 2) as Avg_rating
FROM applestore
GROUP BY App_type;
  
-- 2. Check if app with more language support have higher ratings
SELECT
	 CASE
		WHEN lang_num < 10 THEN '< 10 languages'
		WHEN lang_num BETWEEN 10 and 20 THEN '10 languages'
        ELSE '> 30 languages'
	END as Language_range,
    round(avg(user_rating), 2) as Avg_rating
FROM applestore
GROUP BY Language_range
ORDER BY Avg_rating DESC;

-- 3. Check genres with low ratings
SELECT prime_genre,
	   round(avg(user_rating), 2) as Avg_rating
FROM applestore
GROUP By prime_genre
ORDER BY Avg_rating;

-- 4. Check highest rated app in each genre
SELECT
	 prime_genre
     ,track_name
     ,user_rating
FROM (
	  SELECT
	  prime_genre
      ,track_name
      ,user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as ranking
      FROM
      applestore
      ) AS a
WHERE a.ranking = 1;

-- 5. Check if size is correlated to user rating
SELECT size_bytes
FROM applestore
ORDER BY 1;

SELECT min(size_bytes) as min, max(size_bytes) as max
FROM applestore;

SELECT round(avg(user_rating), 2) as avg_rating,
	CASE
		WHEN size_bytes < 10000000 then 'Small'
        WHEN size_bytes between 10000000 and 100000000 then 'Medium'
        ELSE 'Large'
        END AS size
FROM applestore
GROUP BY size
ORDER BY avg_rating DESC;


/* Final Recs 

1. Paid apps have better ratings.
2. Apps supporting languages between 10 and 30 have better ratings.
3. Finance and Book apps have lowest ratings.
4. New apps should try for an avg rating > 3.5 .
5. Games and Entertainment have high competition. 
6. Larger apps generally have higher ratings. */


select * from applestore;

-------------------------------------------------------------------------------------------------------------------------------------------








