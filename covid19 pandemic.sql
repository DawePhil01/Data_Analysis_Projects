USE COVID_19;

/*

For this Project, I am analyzing the impact of covid 19 in Canada and the USA
I got the data from ourworldindata.org. It had data about covid 19 from different countries around the world
but I extracted only the data from Canada and the USA and transformed it.
I also cleaned the data by removing duplicates, and blank rows, so I could analyze it.

*/


-- The first table is the COVID-19 deaths
SELECT *
FROM covid_deaths_canada_usa;


-- Second table is the COVID vaccinations
SELECT * 
FROM covid_vaccine_canada_usa;

-- Looking at the Total Covid-19 Cases and Total Deaths
-- Comparing the percentage of people who died after getting COVID in Canada and the USA


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM covid_deaths_canada_usa
order by location, date;


-- Looking at the Total COVID-19 cases vs the Population
-- I want to see what is the percentage of the population got the covid 19 each
Select location, date, population,total_cases, (total_cases/population)*100 as Percentage_People_infected
FROM covid_deaths_canada_usa
order by location, date;

-- Looking which Country between Canada and the USA had the highest infection rate compared to the Population

Select Location, population, Max(total_cases) as total_Covid_19_Cases,MAX((total_cases/population)*100 )AS Percentage_People_infected
FROM covid_deaths_canada_usa
Group by location, population;


-- 	Looking at which Country had the Highest Death Counts per Population

Select Location, max(total_deaths) as Total_Deaths
FROM covid_deaths_canada_usa
Group by location;


-- Looking at the numbers

-- Here we are looking from the beginning, for each day, how many people caught COVID-19,
-- How many people died and the death percentage around Canada and the USA


select date, sum(new_cases) as total_case, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) as DeathPercentage
from covid_deaths_canada_usa
group by date
Order by date;

-- This is to look at how many people caught COVID-19, and how many died from it and the death Percentage

select sum(new_cases) as total_case, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) as DeathPercentage
from covid_deaths_canada_usa;


-- Perform a join between the 2 tables: covid death, Covid vaccinations

select deaths.location,deaths.date, deaths.total_cases, vaccine.new_tests
from covid_deaths_canada_usa as deaths inner join covid_vaccine_canada_usa as vaccine
on deaths.location=vaccine.location;

-- Looking at Population and How many vaccinations are there.
-- We are gonna look at their percentage as well

SELECT deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations as NEw_Vaccinated,
sum(new_vaccinations) over (Partition by deaths.location order by deaths.location, deaths.date) as total_Vaccination
FROM covid_deaths_canada_usa as deaths inner join covid_vaccine_canada_usa as vaccine
on deaths.location = vaccine.location and deaths.date = vaccine.date
order by 1,2;



-- Looking at the total number for the Covid 19 Pandemic, how many people got covid, how many people received the vaccination
-- and How many people died from covid 19 as well
SELECT deaths.location, max(deaths.population)as Population, max(deaths.total_cases) as Covid_Cases, Max(vaccine.total_vaccinations) as Vaccinations, Max(deaths.total_deaths) as Total_Deaths
from covid_deaths_canada_usa as deaths inner join covid_vaccine_canada_usa as vaccine
on deaths.location = vaccine.location 
group by deaths.location ;

-- CREATE A VIEW FOR THE total numbers
Create View Covid_19_Pandemic_Canada_USA as
SELECT deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations as NEw_Vaccinated,
sum(new_vaccinations) over (Partition by deaths.location order by deaths.location, deaths.date) as total_Vaccination
FROM covid_deaths_canada_usa as deaths inner join covid_vaccine_canada_usa as vaccine
on deaths.location = vaccine.location and deaths.date = vaccine.date
order by 1,2;

select *
from Covid_19_Pandemic_Canada_USA





