USE covid19;

/* vaccination_and_case
What is the relationship between booster doses and subsequent case trends?
How does the total number of boosters per hundred people vary across continents?
Is there a noticeable trend in new cases for countries with a high stringency_index?
*/


-- What is the relationship between booster doses and subsequent case trends?
WITH booster_and_cases AS (
    SELECT
        location,
        date,
        total_boosters_per_hundred,
        new_cases_per_million,
        LEAD(new_cases_per_million, 14) 
			OVER (PARTITION BY location ORDER BY date) AS cases_after_2_weeks
				-- effect of booster shots after 2 wks
    FROM covid_data
    WHERE total_boosters_per_hundred <> '' 
    AND new_cases_per_million <> ''
),
booster_and_cases_after_2wks AS
(
SELECT
    location AS country,
    total_boosters_per_hundred,
    cases_after_2_weeks,
    AVG(total_boosters_per_hundred) OVER() AS avg_boosters_per_hundred,
    AVG(cases_after_2_weeks) OVER() AS avg_cases_after_2_weeks
FROM booster_and_cases
ORDER BY avg_boosters_per_hundred DESC
)
SELECT 
    country,
    ROUND((SUM((total_boosters_per_hundred - avg_boosters_per_hundred) * (cases_after_2_weeks - avg_cases_after_2_weeks)) /
    (SQRT(SUM(POWER(total_boosters_per_hundred - avg_boosters_per_hundred, 2)) * SUM(POWER(cases_after_2_weeks - avg_cases_after_2_weeks, 2))))),2) AS correlation_coefficient
FROM booster_and_cases_after_2wks
WHERE cases_after_2_weeks IS NOT NULL
GROUP BY country
;

-- How does the total number of boosters per hundred people vary across continents?
-- Boosters to positive rate
SELECT 
    continent,
    AVG(total_boosters_per_hundred) AS avg_boosters_per_hundred,
    AVG(`positive_rate` * 100) AS avg_positive_rate
FROM 
    covid_data
WHERE 
    total_boosters_per_hundred <> ''
    AND `positive_rate` <> ''
GROUP BY 
    continent
ORDER BY 
    avg_boosters_per_hundred DESC
;

-- Is there a noticeable trend in new cases for countries with a high stringency_index?
WITH high_stringency_countries AS (
    SELECT 
        location, 
        date, 
        stringency_index, 
        new_cases
    FROM 
        covid_data
    WHERE 
        stringency_index >= 70
),
monthly_trends AS (
    SELECT 
        location, 
        DATE_FORMAT(date, '%Y-%m') AS yr_mo, 
        AVG(new_cases) AS avg_new_cases
    FROM 
        high_stringency_countries
    GROUP BY 
        location, yr_mo
)
SELECT 
    yr_mo, 
    AVG(avg_new_cases) AS global_avg_new_cases_high_stringency
FROM 
    monthly_trends
GROUP BY 
    yr_mo
ORDER BY 
    yr_mo
;
