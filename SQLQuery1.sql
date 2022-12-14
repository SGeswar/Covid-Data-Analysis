
Select *
From Portfolioproject..CovidDeaths
order by 1,2,3,4




Select location, date,total_cases,new_cases,total_deaths,population
From Portfolioproject..CovidDeaths
order by 1,2


Select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
From Portfolioproject..CovidDeaths
order by 1,2


Select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
From Portfolioproject..CovidDeaths
where location like '%India%'
order by 1,2


Select location, date,population,total_cases,(total_cases/population)*100 as Percent_Infected
From Portfolioproject..CovidDeaths
where location like '%India%'
order by 1,2


Select location,population,MAX(total_cases) as Highest_rate,Max(total_cases/population)*100 as Percent_Infected
From Portfolioproject..CovidDeaths
Group by location,population
order by Percent_Infected desc





select *
From Portfolioproject..CovidDeaths
where continent is not null
order by 3,4



Select location,population,MAX(total_cases) as High_inf_count, MAX((total_cases/population))*100 as percentpopul
From Portfolioproject..CovidDeaths
where continent is not null
Group by location, population
order by percentpopul desc



Select location,population,MAX(cast(total_deaths as int)) as Deaths
From Portfolioproject..CovidDeaths
where continent is not null
Group by location, population
order by Deaths desc



Select location, MAX(cast(total_deaths as int)) as Deaths
From Portfolioproject..CovidDeaths
where (continent is null and iso_code != 'OWID_WRL'and iso_code != 'OWID_HIC' and iso_code != 'OWID_UMC' and iso_code != 'OWID_EUR' and iso_code != 'OWID_LMC' and iso_code != 'OWID_LIC' and iso_code != 'OWID_INT' )
Group by location, population,iso_code
order by Deaths desc




Select location, MAX(cast(total_deaths as int)) as Deaths, max(cast(total_deaths as int)/population)*100 as deathrate
From Portfolioproject..CovidDeaths
where (continent is not null and continent != 'OWID_WRL'and iso_code != 'OWID_HIC' and iso_code != 'OWID_UMC' and iso_code != 'OWID_EUR' and iso_code != 'OWID_LMC' and iso_code != 'OWID_LIC' and iso_code != 'OWID_INT' )
Group by location, population,iso_code
order by Deaths desc



select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as deathpercent
From Portfolioproject..CovidDeaths
where (continent is not null and (continent = 'North America' or continent = 'Asia' or continent = 'South America' or continent = 'European Union' or continent = 'Africa' or continent = 'Oceania'))
order by 1,2




select *
From Portfolioproject..CovidDeaths det
join Portfolioproject..CovidVaccins vac
on det.location = vac.location and det.date =vac.date




Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%india%'
and continent is not null 
order by 1,2


-- Total Cases vs Population


Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT


Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2



-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

