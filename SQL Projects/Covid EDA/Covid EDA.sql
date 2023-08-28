/* Covid-19 Exploratory Data Analysis */

-- Basic Overview
SELECT location, date, total_cases, new_cases, total_deaths, population
from Covid_Deaths
order by 1,2;


-- Total cases vs total deaths
SELECT location, date, total_cases, total_deaths, total_cases / total_deaths * 100 AS Death_Percentage
FROM Covid_Deaths
WHERE location LIKE '%India%';


-- Total cases vs population
SELECT location, date, population, CAST(total_cases as INT) as total_cases, total_cases / population * 100 AS Covid_Percentage
FROM Covid_Deaths
WHERE location LIKE '%India%';


-- Countries with highest infection rate vs population
SELECT location, population, 
SUM(new_cases) AS Infection_count, 
SUM((new_cases / population)) * 100 AS Infected_population
FROM Covid_Deaths
WHERE continent is not null
GROUP BY location, population
ORDER BY Infected_population DESC;


-- Countries with highest death count per population
SELECT location, MAX(CAST(Total_deaths AS INT)) AS Total_death_count
FROM Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC;


-- Contintents with the highest death count per population
SELECT continent, MAX(CAST(Total_deaths AS INT)) AS Total_death_count
FROM Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY  Total_death_count DESC;


-- Total global numbers
SELECT SUM(CAST(new_cases AS INT)) AS total_cases, 
SUM(CAST(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS death_percentage
FROM Covid_Deaths
WHERE continent IS NOT NULL;


-- Total Population vs Vaccinations
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations
FROM Covid_Deaths AS D
JOIN Covid_Vaccinations AS V
	ON D.location = V.location
	AND D.date = V.date
WHERE D.continent IS NOT NULL AND
new_vaccinations IS NOT NULL
ORDER BY 1,2;

------------------------------------------------------------------------------------------------------------------------------------------------------
