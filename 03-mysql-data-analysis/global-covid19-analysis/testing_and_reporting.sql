USE covid19;

/* testing_and_reporting
How do testing rates compare across continents, and which countries have the highest tests per case ratio?
What are the trends in positive test rates over time across different continents?
How has the availability of tests (e.g., tests_units) impacted case identification rates?
*/


-- Compare Testing Rates Across Continents
SELECT 
    continent,
    AVG(total_tests_per_thousand) AS avg_tests_per_thousand
FROM 
    covid_data
WHERE 
    total_tests_per_thousand IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    avg_tests_per_thousand DESC
;

-- Countries with the Highest Tests per Case Ratio
SELECT 
    location AS country,
    continent,
    tests_per_case
FROM 
    covid_data
WHERE 
    tests_per_case IS NOT NULL
ORDER BY 
    tests_per_case DESC
LIMIT 10
;


-- What are the trends in positive test rates over time across different continents?
-- USING sub_query
SELECT
	yr_mo,
    MAX(ROUND(CASE WHEN continent = 'Africa' THEN avg_positive_rate END, 2)) AS Africa,
    MAX(ROUND(CASE WHEN continent = 'Asia' THEN avg_positive_rate END, 2)) AS Asia,
    MAX(ROUND(CASE WHEN continent = 'Europe' THEN avg_positive_rate END, 2)) AS Europe,
    MAX(ROUND(CASE WHEN continent = 'North America' THEN avg_positive_rate END, 2)) AS North_America,
    MAX(ROUND(CASE WHEN continent = 'South America' THEN avg_positive_rate END, 2)) AS South_America
FROM
(
SELECT 
    date_format(date, '%Y-%m') AS yr_mo,
    continent,
    -- DATE_FORMAT(date, '%Y-%m') AS yr_mon, -- Group data by month
    AVG(positive_rate) AS avg_positive_rate
FROM 
    covid_data
WHERE date < '2022-07-01'
GROUP BY 2,1
) AS test
GROUP BY yr_mo
;



-- USING CTEs
WITH avg_positive_rate_trend AS
(
SELECT 
    continent,
    DATE_FORMAT(date, '%Y-%m') AS yr_mon, -- Group data by month
    AVG(positive_rate) AS avg_positive_rate
FROM 
    covid_data
GROUP BY 
    continent, yr_mon
ORDER BY 
    yr_mon
)
	SELECT
	yr_mon,
    MAX(ROUND(CASE WHEN continent = 'Africa' THEN avg_positive_rate END, 2)) AS Africa,
    MAX(ROUND(CASE WHEN continent = 'Asia' THEN avg_positive_rate END, 2)) AS Asia,
    MAX(ROUND(CASE WHEN continent = 'Europe' THEN avg_positive_rate END, 2)) AS Europe,
    MAX(ROUND(CASE WHEN continent = 'North America' THEN avg_positive_rate END, 2)) AS North_America,
    MAX(ROUND(CASE WHEN continent = 'South America' THEN avg_positive_rate END, 2)) AS South_America
    FROM avg_positive_rate_trend
    GROUP BY 
    yr_mon
;
