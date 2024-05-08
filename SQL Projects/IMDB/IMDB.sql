/* Q. FIND THE BEST OF THE BEST */

/* I. DATA CLEANING */

SELECT movie_title, count(*) as count
FROM movies
GROUP BY 1
HAVING count > 1;

DELETE t1 FROM movies t1
INNER JOIN movies t2 
WHERE t1.id < t2.id AND 
      t1.movie_title = t2.movie_title;
      
ALTER TABLE movies
MODIFY duration INT;

UPDATE movies
SET duration = 0
WHERE duration = '';;

UPDATE movies
SET duration = 0
WHERE ID = 466;

WITH cte AS
(SELECT ROW_NUMBER() OVER (ORDER BY id) as roww, movies.*
FROM movies)
SELECT * 
FROM CTE
WHERE roww = 462;

ALTER TABLE movies
CHANGE COLUMN `duration` `duration` INT NULL DEFAULT 0 ;

SELECT * FROM movies;


/* II. EDA */

-- 1. Total records
SELECT count(*) as count
FROM movies;

-- 2. Check for nulls
SHOW COLUMNS FROM movies;

-- 3. Count of Movies per year
SELECT title_year, count(*) as count
FROM movies
GROUP BY 1
ORDER BY 1;


/* III. DATA ANALYSIS */
-- 1. Highest rated movies
SELECT DENSE_RANK() OVER (ORDER BY imdb_score DESC) AS ranking, movies.*
FROM movies
ORDER BY imdb_score DESC;

-- 2. Best Genre
SELECT genres, count(genres) as count,  round(avg(imdb_score), 2) as avg_rating
FROM movies
GROUP BY genres
HAVING count >= 20
ORDER BY 3 DESC;

-- 3. Best director
SELECT director_name, count(*) as movie_count, round(avg(imdb_score), 2) as avg_rating
FROM movies
GROUP BY director_name
HAVING movie_count >= 10
ORDER BY avg_rating DESC;

-- 4. Lowest grossing movies
SELECT movie_title, title_year, director_name, genres, duration, imdb_score, budget, gross
FROM movies
WHERE gross < budget
AND gross != 0
ORDER BY gross
LIMIT 20;

-- 5. Highest grossing movies
SELECT movie_title, title_year, director_name, genres, duration, imdb_score, budget, gross
FROM movies
WHERE gross > budget
AND budget != 0
ORDER BY budget
LIMIT 20;

-- 6. Year with highest ratings
SELECT title_year, count(*) AS count, round(avg(imdb_score),2) as avg_score
FROM movies
GROUP BY 1
HAVING count >= 20
ORDER BY 3 DESC;

-- 7. Best Duration
SELECT count(*) AS count, round(avg(imdb_score),2) as avg_score,
	CASE
		WHEN duration <= 90 then 'Short'
        WHEN duration > 90 and duration <= 120 then 'Medium'
        WHEN duration > 120 and duration <= 150 then 'Long'
		ELSE 'Longest'
	END AS agg_duration
FROM movies
GROUP BY agg_duration
ORDER BY avg_score DESC;

SELECT * FROM movies;

---------------------------------------------------------------------------


