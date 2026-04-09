USE covid19;

/* Vaccination Analysis
	What is the correlation between vaccination rates and total cases per million across countries?
	
    How do vaccination rates compare between continents, and how have they impacted new case rates?
	
    Which countries have the highest proportion of their population fully vaccinated?
*/


SELECT 
    country,
    ROUND((SUM((new_vaccinations_smoothed_per_million - avg_new_vaccinations_smoothed) * (new_cases_smoothed_per_million - avg_new_cases_per_million)) /
    (SQRT(SUM(POWER(new_vaccinations_smoothed_per_million - avg_new_vaccinations_smoothed, 2)) * SUM(POWER(new_cases_smoothed_per_million - avg_new_cases_per_million, 2))))),2) AS correlation_coefficient
FROM 
(
SELECT 
	location AS country, 
	new_vaccinations_smoothed_per_million,  
	new_cases_smoothed_per_million,
    AVG(new_vaccinations_smoothed_per_million) OVER() AS avg_new_vaccinations_smoothed,  
	AVG(new_cases_smoothed_per_million) OVER() AS avg_new_cases_per_million
FROM covid_data
) AS daily_avg_vacination_and_cases
GROUP BY 1
;


-- How do vaccination rates compare between continents, and how have they impacted new case rates?
-- COMPARE AVERAGE ACCROSS CONTINENTS
SELECT 
	continent, 
	AVG(new_vaccinations_smoothed_per_million) AS avg_vacination,  
	AVG(new_cases_smoothed_per_million) AS avg_cases
FROM covid_data
WHERE new_vaccinations_smoothed_per_million IS NOT NULL
	AND new_cases_smoothed_per_million IS NOT NULL
GROUP BY continent
;


 -- Top 10 countries with highest proportion of their population fully vaccinated?
 
SELECT 
    location AS country,
    MAX(people_fully_vaccinated_per_hundred) AS fully_vaccinated_percentage
FROM 
    covid_data  
WHERE 
    people_fully_vaccinated_per_hundred IS NOT NULL
GROUP BY country
ORDER BY 
    fully_vaccinated_percentage DESC
LIMIT 10
;
