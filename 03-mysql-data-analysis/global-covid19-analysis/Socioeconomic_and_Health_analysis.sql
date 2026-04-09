USE covid19;

/* Socioeconomic_and_Health_analysis
How do life expectancy and COVID-19 death rates correlate across countries?
	
Is there a trend between cardiovascular death rates and COVID-19 fatality rates?

What effect does population density appear to have on COVID-19 case rates?
*/

-- correlation between life_expectancy and COVID-19 death (total_deaths_per_million) by countries
SELECT 
    `continent`,
    country,
    ROUND((SUM((life_expectancy - avg_life_expectancy) * (new_deaths_per_million - avg_deaths_per_million)) /
    (SQRT(SUM(POWER(life_expectancy - avg_life_expectancy, 2)) * SUM(POWER(new_deaths_per_million - avg_deaths_per_million, 2))))),2) AS correlation_coefficient
FROM 
(
SELECT 
	`continent`,
    `location` AS country, 
    life_expectancy,
    new_deaths_per_million,
    AVG(`life_expectancy`) OVER() AS avg_life_expectancy, 
    AVG(`new_deaths_per_million`) OVER() AS avg_deaths_per_million
FROM `covid19`.`covid_data`
WHERE    
	life_expectancy <> ''
    AND total_deaths_per_million <> ''
) AS avg_life_exp_and_deaths
GROUP BY 1,2
ORDER BY continent, correlation_coefficient DESC
;


-- Is there a trend between cardiovascular death rates and COVID-19 fatality rates
SELECT 
    `continent`,
    `country`,
    ROUND((SUM((cardiovasc_death_rate - avg_cardiovasc_death_rate) * (covid_fatality_rate - avg_covid_fatality_rate)) /
    (SQRT(SUM(POWER(cardiovasc_death_rate - avg_cardiovasc_death_rate, 2)) * SUM(POWER(covid_fatality_rate - avg_covid_fatality_rate, 2))))),2) AS correlation_coefficient
FROM 
(
SELECT 
    continent,
    `location` AS country,
    cardiovasc_death_rate,
    (total_deaths / total_cases) * 100 AS covid_fatality_rate,  -- Percentage format
    AVG(cardiovasc_death_rate) OVER() AS avg_cardiovasc_death_rate,
    AVG((total_deaths / total_cases) * 100) OVER() AS avg_covid_fatality_rate
FROM 
    covid_data
WHERE  --  filtering out records with missing values
     cardiovasc_death_rate <> ''
    AND total_deaths <> ''
    AND total_cases <> ''
) AS avg_cadiovascula_and_deaths
GROUP BY 1,2
ORDER BY 1,3 DESC
;


-- Relationship betwee cadi_vascular rate, Strigency Index and Fatality rate
SELECT 
    CASE 
        WHEN cardiovasc_death_rate < 
			(select AVG(cardiovasc_death_rate) FROM covid_data) 
			THEN 'Low Cardio Death Rate'
        ELSE 'High Cardio Death Rate'
    END AS cardio_death_rate_category,
    CASE
        WHEN `stringency_index` < 
			(select AVG(`stringency_index`) FROM covid_data) 
			THEN 'Low stringency_index'
        ELSE 'High stringency_index'
    END AS stringency_index_category,
    AVG((total_deaths / total_cases) * 100) AS avg_covid_fatality_rate
FROM 
    covid_data
WHERE 
    cardiovasc_death_rate <> ''
    AND total_deaths <> ''
    AND total_cases <> ''
GROUP BY 
    cardio_death_rate_category,
    stringency_index_category
ORDER BY 
    cardio_death_rate_category
;

-- What effect does population density appear to have on COVID-19 case rates
-- Regions that requires more social distancing
SELECT 
	`continent`, 
    AVG(`population_density`) AS avg_population_density
FROM `covid19`.`covid_data`
GROUP BY 1
ORDER BY 2 DESC
;

SELECT 
    location AS country,
    population_density,
    total_cases_per_million
FROM 
    covid_data  -- Replace with your actual table name
WHERE 
    population_density IS NOT NULL
    AND total_cases_per_million IS NOT NULL;


-- relationship between population density and number of covid19 cases recorded
WITH max_cases_pop_dens AS (
SELECT 
    continent,
    location,
    MAX(total_cases_per_million) AS max_cases,
    MAX(population_density) AS avg_population_density
FROM
    `covid19`.`covid_data`
GROUP BY continent , location
HAVING max_cases > 0
    AND avg_population_density > 0
ORDER BY 4 DESC , 3 DESC
),
density_categoty AS (
SELECT 
	CASE
		WHEN avg_population_density > 
			(SELECT avg(avg_population_density) FROM max_cases_pop_dens)
            THEN 'above_average_pop_density' ELSE 'beow_average_pop_density'
	END AS pop_density_category,
    max_cases
FROM 
	max_cases_pop_dens
)
SELECT 
	pop_density_category,
    avg(max_cases) AS avg_cases
FROM density_categoty
GROUP BY pop_density_category
;


-- continental correlation between popuation density and covid19 cases

SELECT 
    `continent`,
    ROUND((SUM((population_density - avg_population_density) * (total_cases_per_million - avg_total_cases_per_million)) /
    (SQRT(SUM(POWER(population_density - avg_population_density, 2)) * SUM(POWER(total_cases_per_million - avg_total_cases_per_million, 2))))),2) AS correlation_coefficient
FROM 
(
SELECT 
    continent,
    population_density,
    total_cases_per_million,
    AVG(population_density) OVER() AS avg_population_density,
    AVG(total_cases_per_million) OVER() AS avg_total_cases_per_million
FROM 
    covid_data  
WHERE 
    population_density > 0
    AND total_cases_per_million > 0
) AS avg_pop_density_covid_cases
GROUP BY 1
ORDER BY 1,2 DESC
;
