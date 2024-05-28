
--SELECT * FROM Portifolio_Project.dbo.Covid_deaths

SELECT * FROM Portifolio_Project.dbo.Covid_deaths
ORDER BY 3,4

SELECT location,date, total_cases,new_cases,total_deaths, population
FROM Portifolio_Project.dbo.Covid_deaths
ORDER BY 1,2

-- Looking at total_cases vs total_deaths

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)* 100 as death_percentage
FROM Portifolio_Project.dbo.Covid_deaths
WHERE location = 'Brazil' AND total_cases IS NOT NULL AND total_deaths IS NOT NULL
ORDER BY 1,2 desc

--Looking at total_cases vs population
-- Showing what percentage of population got covid

SELECT location,date,population,total_cases, (total_cases/population)* 100 as cases_percentage
FROM Portifolio_Project.dbo.Covid_deaths
WHERE location = 'Brazil' AND total_cases IS NOT NULL
ORDER BY 1,2 


--Looking at Countries with highest infection rate compare to population

SELECT location, population, MAX(total_cases) AS highestInfectionRate, MAX((total_cases/population)* 100) as percentagePopulatinInfected
FROM Portifolio_Project.dbo.Covid_deaths
GROUP BY location, population 
ORDER BY percentagePopulatinInfected DESC

--Showing Countries with Highest Death count per population

SELECT location, population, MAX (total_deaths) AS highestDeathRate, MAX((total_deaths/population)* 100) as percentageOfDeath
FROM Portifolio_Project.dbo.Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY highestDeathRate desc

--Global numbers

SELECT continent, SUM(total_deaths)  AS TotalDeathCount
FROM Portifolio_Project.DBO.Covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc



