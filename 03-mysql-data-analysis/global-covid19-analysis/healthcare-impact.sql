USE covid19;

/* Healthcare Impact
	What is the average ICU occupancy rate per continent over the entire period?
		To calculate the average ICU occupancy rate for each continent over the 
		entire period of available data.
			
	Which countries have the highest and lowest average hospitalizations per million?
		To identify countries with the highest and lowest hospitalizations per million, 
        highlighting disparities in healthcare burden across regions.
        
	How does ICU admission vary with COVID-19 stringency index (lockdowns and restrictions)?
		this explores the relationship between government-imposed restrictions (as measured by the stringency_index) 
        and the rate or level of ICU admissions for COVID-19 patients
*/


-- average ICU_Occupancy rate per CONTINENT over the entire period?
SELECT 
    continent,
    AVG(icu_patients / population * 100) AS avg_icu_occupancy_rate
FROM
    covid_data
WHERE
    icu_patients IS NOT NULL
        AND population IS NOT NULL
GROUP BY continent
ORDER BY avg_icu_occupancy_rate DESC;



-- Which 'countries' have the 'highest' and 'lowest' 'hospitalizations per million'?
SELECT 
    location AS country,
    AVG(hosp_patients_per_million) AS avg_hospitalizations_per_million
FROM
    covid_data
WHERE
    hosp_patients_per_million IS NOT NULL
GROUP BY location
HAVING avg_hospitalizations_per_million <> 0
ORDER BY avg_hospitalizations_per_million DESC
;


-- Countries with no record of hospitalization or 0 hospitalization
SELECT 
    location AS country,
    SUM(hosp_patients_per_million) AS sum_hospitalizations_per_million
FROM
    covid_data
WHERE
    hosp_patients_per_million IS NOT NULL
GROUP BY location
HAVING sum_hospitalizations_per_million = 0
;


-- Weekly trends between ICU Admissions and stringency_index
SELECT 
    YEAR(date) AS year,
    WEEK(date) AS year,
    AVG(icu_patients_per_million) AS avg_icu_admission,
    AVG(stringency_index) AS avg_stringency_index
FROM
    `covid19`.`covid_data`
WHERE stringency_index IS NOT NULL
GROUP BY 1 , 2
;

--  Measure the correlation between the stringency_index and ICU admissions
-- using TEMPORARY TABLE
CREATE TEMPORARY TABLE avg_icu_patient_stringency_index AS
SELECT 
    continent,
    location AS country,
    icu_patients_per_million,
    stringency_index,
    AVG(icu_patients_per_million) OVER() AS avg_icu_patients_per_million,
    AVG(stringency_index) OVER() AS avg_stringency_index
FROM
    `covid19`.`covid_data`;

-- Global correlation between the stringency_index and ICU admissions
SELECT 
    ROUND((SUM((icu_patients_per_million - avg_icu_patients_per_million) * (stringency_index - avg_stringency_index)) / 
    (SQRT(SUM(POWER(icu_patients_per_million - avg_icu_patients_per_million, 2)) * SUM(POWER(stringency_index - avg_stringency_index, 2))))), 2) AS correlation_coefficient
FROM
    avg_icu_patient_stringency_index
;

-- Continental correlation between the stringency_index and ICU admissions
SELECT 
    continent,
    ROUND((SUM((icu_patients_per_million - avg_icu_patients_per_million) * (stringency_index - avg_stringency_index)) / 
    (SQRT(SUM(POWER(icu_patients_per_million - avg_icu_patients_per_million, 2)) * SUM(POWER(stringency_index - avg_stringency_index, 2))))), 2) AS correlation_coefficient
FROM
    avg_icu_patient_stringency_index
GROUP BY continent
;

-- Country correlation between the stringency_index and ICU admissions
SELECT 
    country,
    ROUND((SUM((icu_patients_per_million - avg_icu_patients_per_million) * (stringency_index - avg_stringency_index)) / 
    (SQRT(SUM(POWER(icu_patients_per_million - avg_icu_patients_per_million, 2)) * SUM(POWER(stringency_index - avg_stringency_index, 2))))), 2) AS correlation_coefficient
FROM
    avg_icu_patient_stringency_index
GROUP BY country
;


-- Trend showing 2weeks lag effect between stringency_index and ICU Admissions and 
SELECT 
    date,
    continent,
    location AS country,
    stringency_index,
    LEAD(icu_patients_per_million, 14) OVER(PARTITION BY location ORDER BY date) AS icu_admission_2wks
		-- icu_patients_per_million 2wks after strigency measure
FROM
    covid_data
WHERE stringency_index IS NOT NULL
;

-- Lead/Lag effect on correlation using CTE
WITH wks_2_lead_icu_patient_and_strigency AS (
SELECT 
    date,
    continent,
    location AS country,
    stringency_index,
    LEAD(icu_patients_per_million, 14) OVER(PARTITION BY location ORDER BY date) AS icu_admission_2wks
		-- icu_patients_per_million 2wks after strigency measure
FROM
    covid_data
WHERE stringency_index IS NOT NULL
),
avg_wks_2_lead_icu_patient_and_strigency AS (
SELECT
	stringency_index, 
    icu_admission_2wks,
    AVG(stringency_index) OVER() AS avg_stringency_index, 
    AVG(icu_admission_2wks) OVER() AS avg_icu_admission_2wks
FROM wks_2_lead_icu_patient_and_strigency
)
SELECT 
    ROUND((SUM((stringency_index - avg_stringency_index) * (icu_admission_2wks - avg_icu_admission_2wks)) / 
    (SQRT(SUM(POWER(stringency_index - avg_stringency_index, 2)) * SUM(POWER(icu_admission_2wks - avg_icu_admission_2wks, 2))))), 2) AS correlation_coefficient
FROM
    avg_wks_2_lead_icu_patient_and_strigency
;
