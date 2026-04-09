USE covid19;

/* mortality_rate
What countries have the highest excess mortality rates per million people?

Is there a relationship between GDP per capita and COVID-19 death rates?
*/

-- What countries have the highest excess mortality rates per million people?
SELECT 
	`location` AS country, 
    MAX(`excess_mortality_cumulative_per_million`) AS excess_mortality_per_mil
FROM `covid19`.`covid_data`
GROUP BY country
ORDER BY excess_mortality_per_mil DESC
LIMIT 10
;

-- Quarterly trend between GDP per capita and COVID-19 death rates?

SELECT 
    YEAR(`date`) AS yr,
    QUARTER(`date`) AS qtr,
    AVG(gdp_per_capita) AS avg_gdp,
    AVG(new_deaths_per_million) AS avg_new_deaths
FROM 
    covid_data  
WHERE 
    gdp_per_capita IS NOT NULL 
    AND new_deaths_per_million IS NOT NULL
GROUP BY 1,2
;


-- Global correlation between gdp and covid deaths
SELECT
ROUND((SUM((gdp_per_capita - avg_gdp) * (new_deaths_per_million - avg_deaths)) /
    (SQRT(SUM(POWER(gdp_per_capita - avg_gdp, 2)) * SUM(POWER(new_deaths_per_million - avg_deaths, 2))))),2) AS correlation_coefficient
FROM
(
SELECT 
    gdp_per_capita,
    new_deaths_per_million,
    AVG(gdp_per_capita) OVER() AS avg_gdp,
    AVG(new_deaths_per_million) OVER() AS avg_deaths
FROM 
    covid_data  
WHERE 
    gdp_per_capita IS NOT NULL 
    AND new_deaths_per_million IS NOT NULL
) AS avg_gdp_deaths

;

-- correlation between gdp and covid deaths by continent
SELECT
continent, 
ROUND((SUM((gdp_per_capita - avg_gdp) * (new_deaths_per_million - avg_deaths)) /
    (SQRT(SUM(POWER(gdp_per_capita - avg_gdp, 2)) * SUM(POWER(new_deaths_per_million - avg_deaths, 2))))),2) AS correlation_coefficient
FROM
(
SELECT 
    continent,
    gdp_per_capita,
    new_deaths_per_million,
    AVG(gdp_per_capita) OVER() AS avg_gdp,
    AVG(new_deaths_per_million) OVER() AS avg_deaths
FROM 
    covid_data  
WHERE 
    gdp_per_capita IS NOT NULL 
    AND new_deaths_per_million IS NOT NULL
) AS avg_gdp_deaths
GROUP BY 1
ORDER BY 2 DESC
;
