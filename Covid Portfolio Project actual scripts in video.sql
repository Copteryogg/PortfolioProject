--Select * From PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4


--Select * From PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be useing


--Looking at Total Cases vs Total Deaths
--Show Likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpersentage
From PortfolioProject..CovidDeaths
where location like 'Thailand'
order by 1,2


--Looking at the total cases vs Population
select Location, population, total_cases, (total_cases/population)*100 as Populationpersentage
From PortfolioProject..CovidDeaths
where location like 'Thailand'
order by 1,2


--Looking at Coutries with Highest infection rate compared to poplation
select Location, population, max(total_cases) as Highestinfectioncount,Max((total_cases/population))*100 as Perenthighest
From PortfolioProject..CovidDeaths
where continent is not null
Group by Location, Population
--where location like 'Thailand'
order by Highestinfectioncount desc


--LET'S BREAK THINGS DOWN BY CONTINENT 
select location, Max(cast(total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
where continent is null
Group by location
--where location like 'Thailand'
order by TotalDeathcount desc


--Showing Countries with Highest Death Count per Population
select Location, Max(cast(total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
where continent is not null
Group by Location
--where location like 'Thailand'
order by TotalDeathcount desc


--Showing continents with the highest death count per population (The 2nd)
select location, Max(cast(total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
where continent is not null
Group by location
--where location like 'Thailand'
order by TotalDeathcount desc

--Global Numbers
select Sum(new_cases) as total_ncases, Sum(cast(new_deaths as int)) as total_ndeaths, 
Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathnpersentage
From PortfolioProject..CovidDeaths
--where location like 'Thailand'
where continent is not null
--Group by date
order by 1,2


-- Looking at total; Population vs Vaccinations
Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE 
Drop table if exists #PercentPopulationsVaccinated1
Create table #PercentPopulationsVaccinated1
(Continent nvarchar(255),
Location nvarchar(255),
date datetime,
population Numeric,
new_vaccinations Numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationsVaccinated1
Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationsVaccinated1


--Create View PercentPopulationsVaccinated1
Create View PercentPopulationVaccinated1 as
Select dea.continent, dea.Location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * From PercentPopulationVaccinated1








