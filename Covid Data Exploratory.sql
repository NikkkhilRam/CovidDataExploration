-- Calculating Death percentage in India

Select Location, date, total_cases, total_deaths, (CAST(total_deaths AS float)/CAST(total_cases AS float))*100 as DeathPercentage
from CovidDeaths
where Location like '%India%'
order by 1,2

-- Death percentage with respect to the population

Select Location, date, total_cases, Population, (CAST(total_cases AS float)/population)*100 as PopulationInfectedPercentage
from CovidDeaths
where Location like '%India%'
order by 1,2 

-- Highest infected rate compared with population

Select Location, Population ,MAX(total_cases) as PeakCaseCount, MAX((CAST(total_cases AS float)/population)*100) as PopulationInfectedPercentage
from CovidDeaths
group by Location, Population
order by PopulationInfectedPercentage DESC

-- Highest death rate compared with population

Select Location, Population ,MAX(CAST(total_deaths AS INT)) as PeakDeathCount, MAX((CAST(total_deaths AS float)/population)*100) as PopulationDeathPercentage
from CovidDeaths
where continent is not null
group by Location, Population
order by PopulationDeathPercentage DESC

--Total Death Count based on Continent

Select continent ,MAX(CAST(total_deaths AS INT)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC

--Global Numbers 

Select date, SUM(CAST(new_cases AS INT)) as Total_cases, SUM(CAST(new_deaths AS INT)) as Total_Deaths, 
(SUM(CAST(new_deaths AS FLOAT))/SUM(CAST(new_cases AS FLOAT)))*100 as DeathPercentage
from CovidDeaths
where continent is not null 
group by date
order by 1,2

-- Data Exploration including Vaccination data

Select * 
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date

-- Looking at Total Population vs Vaccination

with PopVsVac (Continent, Location, date, Population,new_vaccinations, RollingPeopleVaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage
from PopVsVac

