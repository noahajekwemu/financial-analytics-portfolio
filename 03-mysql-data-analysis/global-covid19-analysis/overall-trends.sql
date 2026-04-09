USE covid19;

/*	Overall Trends
	What are the top 10 countries with the highest total confirmed cases?
		To identify the top 10 countries with the highest total confirmed COVID-19 cases globally.
	
	Which continents have the highest and lowest total confirmed deaths per million people?
		To determine which continents have the highest and lowest total confirmed deaths per 
        million people, providing insights into regional disparities in the pandemic's impact.
    	
    What are the daily, weekly, and monthly trends in new COVID-19 cases globally?
		To explore the daily, weekly, and monthly trends in new COVID-19 cases globally, 
        providing insights into the pandemic's progression and seasonality
	
*/

-- top 10 countries with the highest total confirmed cases
SELECT 
    location AS country, MAX(total_cases) AS highest_total_cases
FROM
    covid_data
WHERE
    continent IS NOT NULL
        AND total_cases IS NOT NULL
GROUP BY location
ORDER BY highest_total_cases DESC
LIMIT 10;


-- continents with the highest and lowest total confirmed deaths per million people
SELECT 
    continent,
    SUM(total_deaths_per_million) AS total_deaths_per_million
FROM
    covid_data
WHERE
    total_deaths_per_million IS NOT NULL
GROUP BY continent
ORDER BY total_deaths_per_million DESC;


-- Daily Trends in new COVID-19 cases
SELECT 
    date, SUM(new_cases) AS daily_new_cases
FROM
    covid_data
WHERE
    new_cases IS NOT NULL
GROUP BY date
ORDER BY date;


-- Weekly Trends in new COVID-19 cases
SELECT 
    YEAR(date) AS year,
    WEEK(date) AS week_number,
    SUM(new_cases) AS weekly_new_cases
FROM
    covid_data
WHERE
    new_cases IS NOT NULL
GROUP BY YEAR(date) , WEEK(date)
ORDER BY year , week_number;


-- Monthly Trends in new COVID-19 cases
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(new_cases) AS monthly_new_cases
FROM
    covid_data
WHERE
    new_cases IS NOT NULL
GROUP BY YEAR(date) , MONTH(date)
ORDER BY year , month;
