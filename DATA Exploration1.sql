select * from PortfolioProject..CovidDeaths$
order by 3,4;

--select * from PortfolioProject..CovidVacinations$
--order by 3,4;

--Selecting  data that we are going to work with

Select Location,date, total_cases,new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2;

--Total Cases vs Total Deaths

Select Location,date, total_cases,new_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2;

--Total Cases vs Population
--Mostra a Percentagem de Pessoas que morreram por covid

Select Location,date, total_cases,new_cases, population, (total_deaths/population)*100 as Death_Percentage
from PortfolioProject..CovidDeaths$
where location like '%Mozambiq%'
order by 1,2;


-- Paises com maiores indice de infecao comprando pela polucao

Select Location,population, max(total_cases) as Highest_InfestionCount,max((total_deaths/population)*100) as PercentageOfPopulation_Infected
from PortfolioProject..CovidDeaths$
--where location like '%Mozambique%'
group by location, population
order by PercentageOfPopulation_Infected desc;


--Paises mior numero de mortos 

Select location,max(cast(total_deaths  as int)) as TotalDeathCount
from PortfolioProject ..CovidDeaths$
where continent is not null
group by location
order by  TotalDeathCount desc;

-- continenentes com maior numero de mortos

Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject ..CovidDeaths$
where continent is not null
group by location
order by  TotalDeathCount desc;

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject ..CovidDeaths$
where continent is not null
group by continent
order by  TotalDeathCount desc;

-- Continentes  com maiores mortes por popula��o

select continent,max(cast(total_deaths as int)) as TotalDeath
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeath desc;

-- N�meros globais
Select sum(new_cases) as novosCasos,sum(cast(new_deaths as int)) novasMortes,
sum(cast(new_deaths as int))/sum(new_cases)*100  as DeathPercentage
--total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1,2;


--Total das pessoas vacinadas

 with PopuvsVacinatios (Continent,Location, Date,Population,New_vacinatios, RollingVacinated) as (
  select deaths.continent,deaths.location,deaths.date,deaths.population,
 vaci.new_vaccinations,
 sum( cast(vaci.new_vaccinations as int))  over(partition by deaths.location order by 
 deaths.location,deaths.date) as Rolling_vaccintions
 from
 PortfolioProject..CovidDeaths$ as deaths
 join PortfolioProject..CovidVacinations$ as vaci
	on deaths.location= vaci.location
	and deaths.date=vaci.date
where deaths.continent is not null
--order by 2,3
 )
 select *,
(RollingVacinated/Population) *100  
 from PopuvsVacinatios;


 --using temp table

 create  table #PercentPopulationVacinated(
 Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vacinations numeric,
  RollingVacinated numeric
 )

 Insert into #PercentPopulationVacinated
 select deaths.continent,deaths.location,deaths.date,deaths.population,
 vaci.new_vaccinations,
 sum( cast(vaci.new_vaccinations as int))  over(partition by deaths.location order by 
 deaths.location,deaths.date) as Rolling_vaccintions
 from
 PortfolioProject..CovidDeaths$ as deaths
 join PortfolioProject..CovidVacinations$ as vaci
	on deaths.location= vaci.location
	and deaths.date=vaci.date
where deaths.continent is not null
--order by 2,3

Select *,(RollingVacinated/Population ) * 100
from #PercentPopulationVacinated;

-- Criando uma view para visualizacao de dados aposterior

create view PercentPopulationVacinated as
 select deaths.continent,deaths.location,deaths.date,deaths.population,
 vaci.new_vaccinations,
 sum( cast(vaci.new_vaccinations as int))  over(partition by deaths.location order by 
 deaths.location,deaths.date) as Rolling_vaccintions
 from
 PortfolioProject..CovidDeaths$ as deaths
 join PortfolioProject..CovidVacinations$ as vaci
	on deaths.location= vaci.location
	and deaths.date=vaci.date
where deaths.continent is not null