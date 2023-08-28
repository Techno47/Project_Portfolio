/* Answer 20 SQL Queries using a Real Dataset (120 years of Olympics History) */


-- 1. How many olympics games have been held?
SELECT COUNT(DISTINCT Games) 
FROM athlete_events;


-- 2. List down all Olympics games held so far.
SELECT DISTINCT Year,Season,city 
FROM athlete_events
ORDER BY Year;


-- 3. Mention the total no of nations who participated in each olympics game?
SELECT games, COUNT(DISTINCT region) AS total_countries
FROM athlete_events a
INNER JOIN noc_regions n 
ON a.NOC = n.NOC
GROUP BY games;


-- 4. Which year saw the highest and lowest no of countries participating in olympics?
WITH cte AS (
    SELECT DISTINCT Games, COUNT(DISTINCT region) as Countries
    FROM athlete_events a
    INNER JOIN noc_regions n 
    ON a.NOC = n.NOC
    GROUP BY Games
	)
SELECT 
    MIN(games) || ' - ' ||  MIN(Countries) AS lowest_countries,
    MAX(games) || ' - ' ||  MAX(Countries) AS highest_countries
FROM cte;


-- 5. Which nation has participated in all of the olympic games?
SELECT region AS country, COUNT(DISTINCT games) AS total_participated_games
FROM athlete_events a
INNER JOIN noc_regions n 
ON a.NOC = n.NOC
GROUP BY region
HAVING total_participated_games = (SELECT COUNT(DISTINCT games) 
FROM athlete_events);


-- 6. Identify the sport which was played in all summer olympics.
WITH cte AS (
	SELECT Sport, COUNT(DISTINCT games) as no_of_games, COUNT(DISTINCT games) AS total_games,
	RANK () OVER(ORDER BY COUNT(DISTINCT games)DESC) AS rank
	FROM athlete_events
	WHERE Season = 'Summer'
	GROUP BY sport
	ORDER BY no_of_games DESC
)
SELECT Sport, no_of_games, total_games 
FROM cte
WHERE rank = 1;


-- 7. Which Sports were just played only once in the olympics?
SELECT DISTINCT Sport, COUNT(DISTINCT Games) AS no_of_games, Games 
FROM athlete_events
GROUP BY 1
HAVING no_of_games = 1;


-- 8. Fetch the total no of sports played in each olympic games.
SELECT Games, COUNT(DISTINCT Sport) AS no_of_sport
FROM athlete_events
GROUP BY Games
ORDER by no_of_sport DESC, Games;


-- 9. Fetch details of the oldest athletes to win a gold medal.
WITH CTE AS (
	SELECT Name, Sex, Age, Team, Games, City, Sport, Event, Medal, 
	RANK() OVER(ORDER BY age DESC) AS rank
	FROM athlete_events
	WHERE Age NOT LIKE '%NA%' 
	AND Medal LIKE '%Gold%'
	)
SELECT *
FROM cte
WHERE rank = 1;


-- 10. Find the Ratio of male and female athletes participated in all olympic games.
WITH cte AS (
	 SELECT 
     ROUND(CAST(COUNT(CASE WHEN sex = 'M' THEN 1 END) AS REAL) / COUNT(CASE WHEN sex = 'F' THEN 1 END), 2) AS ratio
     FROM athlete_events
	 )
	SELECT '1:' || ratio AS ratio
	FROM cte;


-- 11. Fetch the top 5 athletes who have won the most gold medals.
SELECT Name, Team, COUNT(Medal) AS total_gold_medals
FROM athlete_events
WHERE Medal LIKE '%Gold%'
GROUP BY Name
ORDER BY total_gold_medals DESC
LIMIT 5;


-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
SELECT Name, Team, COUNT(Medal) AS total_medals
FROM athlete_events
WHERE Medal NOT LIKE '%NA%'
GROUP BY Name
ORDER BY total_medals DESC
LIMIT 5;


-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
WITH cte AS (
	SELECT region AS Country, COUNT(*) AS Total_Medal
	FROM athlete_events a
	INNER JOIN noc_regions n 
	ON a.Noc = n.NOC
	WHERE medal <> 'NA'
	GROUP BY region 
	ORDER BY total_medal DESC
	LIMIT 5
	)
SELECT country, Total_Medal,  
ROW_NUMBER() OVER (ORDER BY Total_Medal DESC) AS rank 
FROM cte;


-- 14. List down total gold, silver and broze medals won by each country.
SELECT DISTINCT region AS Country, 
	SUM(Medal = 'Gold') AS Gold,
	SUM(Medal = 'Silver') AS Silver, 
	SUM(Medal = 'Bronze') AS Bronze
FROM athlete_events a
INNER JOIN noc_regions n 
ON a.NOC = n.NOC
WHERE medal <> 'NA'
GROUP BY Country	
ORDER BY Gold DESC;


-- 15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.
SELECT Games, region AS Country,
    SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
    SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
    SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM athlete_events a
INNER JOIN noc_regions n ON a.NOC = n.NOC
GROUP BY Games, region;


-- 16.	Identify which country won the most gold, most silver and most bronze medals in each olympic games.
WITH cte AS (
SELECT Games, region AS Country,
     SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
     SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
     SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
FROM athlete_events a
INNER JOIN noc_regions n
ON a.NOC = n.NOC
GROUP BY Games, Country
)
SELECT
    cte.Games,
    MAX(CASE WHEN cte.gold = (SELECT MAX(gold) FROM cte sub WHERE sub.Games = cte.Games) THEN cte.Country || ' - ' || CAST(cte.gold AS TEXT) END) AS max_gold,
    MAX(CASE WHEN cte.silver = (SELECT MAX(silver) FROM cte sub WHERE sub.Games = cte.Games) THEN cte.Country || ' - ' || CAST(cte.silver AS TEXT) END) AS max_silver,
    MAX(CASE WHEN cte.bronze = (SELECT MAX(bronze) FROM cte sub WHERE sub.Games = cte.Games) THEN cte.Country || ' - ' || CAST(cte.bronze AS TEXT) END) AS max_bronze
FROM cte
GROUP BY cte.Games;
	
	
-- 17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
WITH cte AS (
    SELECT Games,
        region AS Country,
        SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
        SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
        SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
    FROM athlete_events a
    INNER JOIN noc_regions n ON a.NOC = n.NOC
    GROUP BY Games, Country
)
SELECT
    cte.Games,
    MAX(CASE WHEN cte.gold = (SELECT MAX(gold) FROM cte sub WHERE sub.Games = cte.Games) THEN cte.Country || ' - ' || CAST(cte.gold AS TEXT) END) AS max_gold,
    MAX(CASE WHEN cte.silver = (SELECT MAX(silver) FROM cte sub WHERE sub.Games = cte.Games) THEN cte.Country || ' - ' || CAST(cte.silver AS TEXT) END) AS max_silver,
    MAX(CASE WHEN cte.bronze = (SELECT MAX(bronze) FROM cte sub WHERE sub.Games = cte.Games) THEN cte.Country || ' - ' || CAST(cte.bronze AS TEXT) END) AS max_bronze,
    MAX(cte.Country || ' - ' ||
        CASE 
            WHEN cte.gold + cte.silver + cte.bronze = (SELECT MAX(gold + silver + bronze) FROM cte sub WHERE sub.Games = cte.Games)
            THEN CAST(cte.gold + cte.silver + cte.bronze AS TEXT)
        END) AS max_medals
FROM cte
GROUP BY cte.Games;


-- 18.	Which countries have never won gold medal but have won silver/bronze medals?
SELECT region as Country,
	COUNT(CASE WHEN medal = 'Gold' THEN medal END) AS Gold,
	COUNT(CASE WHEN medal = 'Silver' THEN medal END) AS Silver,
	COUNT(CASE WHEN medal = 'Bronze' THEN medal END) AS Bronze
FROM athlete_events AS a
JOIN noc_regions AS n ON a.NOC = n.NOC
GROUP BY region
HAVING Gold = 0
ORDER BY Silver DESC;


-- 19.	In which Sport/event, India has won highest medals.
SELECT sport, COUNT(medal) AS total_medals
FROM athlete_events a
INNER JOIN noc_regions n 
ON a.NOC = n.NOC
WHERE region LIKE '%India%'
AND medal NOT LIKE '%NA%'
GROUP BY Sport
ORDER BY total_medals DESC
LIMIT 1;


-- 20. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT Team, Sport, Games, Medal, 
COUNT(medal) AS total_medals
FROM athlete_events
WHERE Team = 'India'
AND Sport = 'Hockey'
AND Medal <> 'NA'
AND Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Games
ORDER BY total_medals DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------------------

