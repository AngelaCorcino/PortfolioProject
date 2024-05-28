

SELECT * FROM Portifolio_Project.dbo.Covid_deaths as dea
JOIN Portifolio_Project.dbo.Covid_vaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date

--Looking at vaccinations per day by location, sum day by day.

SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,-- vaccinations per day
SUM(vac.new_vaccinations)  OVER (Partition by dea.location ORDER BY dea.location,dea.date) -- people vaccinated per day by location
FROM Portifolio_Project.dbo.Covid_deaths as dea
JOIN Portifolio_Project.dbo.Covid_vaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
Order by 2,3

--CTE TABLE - Looking at  Percentage of Total Population vs Vaccinations

WITH PopvsVac (continent, location,date,population,new_vaccinations, SumOfPeopleVaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,-- vaccinations per day
SUM(vac.new_vaccinations)  OVER (Partition by dea.location ORDER BY dea.location,dea.date) -- people vaccinated per day by location
AS SumOfPeopleVaccinated
FROM Portifolio_Project.dbo.Covid_deaths as dea
JOIN Portifolio_Project.dbo.Covid_vaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--Order by 2,3
)

SELECT *, (SumOfPeopleVaccinated/population)*100
FROM PopvsVac
Where new_vaccinations IS NOT NULL

--TEMP TABLE

CREATE TABLE #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date date,
population float,
new_vaccinations decimal(18,0),
SumOfPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,-- vaccinations per day
SUM(vac.new_vaccinations)  OVER (Partition by dea.location ORDER BY dea.location,dea.date) -- people vaccinated per day by location
AS SumOfPeopleVaccinated
FROM Portifolio_Project.dbo.Covid_deaths as dea
JOIN Portifolio_Project.dbo.Covid_vaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--Order by 2,3

SELECT *, (SumOfPeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated
Where new_vaccinations IS NOT NULL

--Creating View to store data for later visualizations

CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,-- vaccinations per day
SUM(vac.new_vaccinations)  OVER (Partition by dea.location ORDER BY dea.location,dea.date) -- people vaccinated per day by location
AS SumOfPeopleVaccinated
FROM Portifolio_Project.dbo.Covid_deaths as dea
JOIN Portifolio_Project.dbo.Covid_vaccinations as vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--Order by 2,3

SELECT *, (SumOfPeopleVaccinated/population)*100
FROM PercentagePopulationVaccinated
Where new_vaccinations IS NOT NULL