select * from CovidDeaths


-- show likelihood of showing deaths in India

/*
select location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT))*100 as DeathPercentage
from CovidDeaths
where location = 'india'
order by 1,2,5 desc
*/

 -- total cases vs population 
 
 select Location, date, population, total_cases, (total_cases/population)*100 as AffectedPercentage from portfolioproject..CovidDeaths
 where location = 'India'
 order by 1,2,4
 
 -- Highest Infected Countries and its percentage 
 select Location, population, max(total_cases) as HighestInfectedCount, max((total_cases/population))*100 as HighestAffectedPercentage 
 from portfolioproject..CovidDeaths
 group by location, population
 order by 4 desc

 -- Showing countries with highest death rate per population 
 select Location, population, max(cast(total_deaths as int)) as HighestDeathCount, max((total_deaths/population))*100 as HighestDeathPercentage 
 from portfolioproject..CovidDeaths
 where continent is not null
 group by location, population
 order by 4 desc
 
 -- break down things according to continent 
Select location, max(total_deaths) as MaximumDeaths  from PortFolioProject..CovidDeaths
where continent is null
group by location
order by location 

select date, sum(new_cases) as TotalNewCases from PortFolioProject..CovidDeaths
where 2 is not null
group by date
order by 1,2

select CD.continent, cd.location, cd.date, CD.population, CV.new_vaccinations 
from PortFolioProject..CovidDeaths CD
inner join portfolioproject..covidvaccination CV
on CD.location = CV.location and CD.date = CV.date
where cd.continent is not null and cv.new_vaccinations is not null
order by 1,2,3

select cd. location, cd.date, cd.population, cv.new_vaccinations, 
sum(cast(cv.new_vaccinations as bigint))  over (partition by cd.location order by cd.date)  as TotalNewVaccination
from PortFolioProject..CovidDeaths cd
join PortFolioProject..CovidVaccination cv
on cd.location = cv.location and cd.date = cv.date
where cv.new_vaccinations is not null
order by 1,2

--Use CTE if you want to use or do something with new column created

with PopVsVac (location, date, population, new_vaccinations, TotalNewVaccination)
as
(
select cd. location, cd.date, cd.population, cv.new_vaccinations, 
sum(cast(cv.new_vaccinations as bigint))  over (partition by cd.location order by cd.date)  as TotalNewVaccination
from PortFolioProject..CovidDeaths cd
join PortFolioProject..CovidVaccination cv
on cd.location = cv.location and cd.date = cv.date
where cv.new_vaccinations is not null
)
select *, (TotalNewVaccination/population)*100 as RollingVaccinated
from PopVsVac
