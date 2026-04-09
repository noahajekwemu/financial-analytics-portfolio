USE covid19;

/* health_infrastructure
How do countries with high hospital beds per thousand compare in COVID-19 mortality rates?
Which countries have the lowest healthcare stringency index, and how do their case trends look?
Does the presence of handwashing facilities correlate with lower COVID-19 case rates?
*/

-- How do countries with high hospital beds per thousand compare in COVID-19 mortality rates?
WITH bed_categories AS (
    SELECT 
        location,
        hospital_beds_per_thousand,
        total_deaths_per_million,
        CASE 
            WHEN hospital_beds_per_thousand >= 5 THEN 'High Availability'
            WHEN hospital_beds_per_thousand BETWEEN 2 AND 4.99 THEN 'Moderate Availability'
            ELSE 'Low Availability'
        END AS bed_category
    FROM 
        covid_data
    WHERE 
        hospital_beds_per_thousand <> ''
        AND total_deaths_per_million <> ''
)
SELECT 
    bed_category,
    AVG(total_deaths_per_million) AS avg_mortality_rate
FROM 
    bed_categories
GROUP BY 
    bed_category
ORDER BY 
    avg_mortality_rate DESC
;


-- Which countries have the lowest healthcare stringency index, 
-- and how do their case trends look?
 
 SELECT location,
	AVG(stringency_index)
FROM covid_data
WHERE stringency_index BETWEEN 10 AND 30
GROUP BY location
ORDER BY 2
LIMIT 5
;
 
 -- annual trend analysis of covid19 cases when strigency index is belwo 30%
WITH low_stringency_countries AS (
    SELECT 
        location, 
        date, 
        stringency_index, 
        new_cases
    FROM 
        covid_data
    WHERE 
        stringency_index <= 30
),
annual_trends AS (
    SELECT 
        location, 
        YEAR(date) AS yr, 
        AVG(new_cases) AS avg_new_cases
    FROM 
        low_stringency_countries
    GROUP BY 
        location, yr
)
SELECT 
    yr, 
    location, 
    avg_new_cases
FROM 
    annual_trends
ORDER BY 
    yr, avg_new_cases DESC
;


-- annual trend analysis of covid19 cases when strigency index is belwo 30% pivot
WITH low_stringency_countries AS (
    SELECT 
        location, 
        date, 
        stringency_index, 
        new_cases
    FROM 
        covid_data
    WHERE 
        stringency_index <= 30
),
annual_trends AS (
    SELECT 
        location, 
        YEAR(date) AS yr, 
        AVG(new_cases) AS avg_new_cases
    FROM 
        low_stringency_countries
    GROUP BY 
        location, yr
)
SELECT
	location,
    MAX(ROUND(CASE WHEN yr = 2020 THEN avg_new_cases END)) AS '2020',
    MAX(ROUND(CASE WHEN yr = 2021 THEN avg_new_cases END)) AS '2021',
    MAX(ROUND(CASE WHEN yr = 2022 THEN avg_new_cases END)) AS '2022',
    MAX(ROUND(CASE WHEN yr = 2023 THEN avg_new_cases END)) AS '2023',
    MAX(ROUND(CASE WHEN yr = 2024 THEN avg_new_cases END)) AS '2024'
FROM annual_trends
GROUP BY location
;


-- Does the presence of handwashing facilities correlate with lower COVID-19 case rates?
SELECT 
    CASE 
		WHEN handwashing_facilities <= 50 THEN 'Low (0-50)'
        WHEN handwashing_facilities <= 75 THEN 'Mid (50.99-75)'
        ELSE 'High (75.99-100)'
	END AS handwashing_facilities_category,
    AVG(total_cases_per_million) AS avg_case_rate
FROM 
    covid_data
WHERE 
    handwashing_facilities <> ''
    AND total_cases_per_million <> ''
GROUP BY handwashing_facilities_category
ORDER BY 2 DESC
;

-- global correlation between handwashing facilities and cases
WITH avg_handwash_totalcases AS (
SELECT 
    handwashing_facilities,
    total_cases_per_million,
    AVG(handwashing_facilities) OVER() AS avg_handwashing_facilities,
    AVG(total_cases_per_million) OVER() AS avg_case_rate
FROM 
    covid_data
WHERE 
    handwashing_facilities <> ''
    AND total_cases_per_million <> ''
)
SELECT 
    ROUND((SUM((handwashing_facilities - avg_handwashing_facilities) * (total_cases_per_million - avg_case_rate)) /
    (SQRT(SUM(POWER(handwashing_facilities - avg_handwashing_facilities, 2)) * SUM(POWER(total_cases_per_million - avg_case_rate, 2))))),2) AS correlation_coefficient
FROM avg_handwash_totalcases
;
