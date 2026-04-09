USE covid19;

/* trend_analysis_over_time
How did the reproduction rate change in each continent across different phases of the pandemic?
What were the peak hospitalization rates for the top 10 most affected countries?
*/
-- How did the reproduction rate change in each continent across different phases of the pandemic?
WITH pandemic_phases AS (
    SELECT 
        continent,
        reproduction_rate,
        CASE 
            WHEN date BETWEEN '2020-01-01' AND '2020-06-30' THEN 'Phase 1'
            WHEN date BETWEEN '2020-07-01' AND '2020-12-31' THEN 'Phase 2'
            WHEN date BETWEEN '2021-01-01' AND '2021-12-31' THEN 'Phase 3'
            WHEN date >= '2022-01-01' THEN 'Phase 4'
        END AS pandemic_phase
    FROM 
        covid_data
    WHERE 
        reproduction_rate <> ''
)
SELECT 
    continent,
    pandemic_phase,
    ROUND(AVG(reproduction_rate),2) AS avg_reproduction_rate
FROM 
    pandemic_phases
GROUP BY 
    continent, pandemic_phase
ORDER BY 
    continent, pandemic_phase
;



-- What were the peak hospitalization rates for the top 10 most affected countries?
    SELECT 
        location,
        MAX(total_cases) AS total_cases,
        MAX(hosp_patients_per_million) AS peak_hospitalization_rate
    FROM 
        covid_data
        Group by location
        ORDER BY 2 DESC
        LIMIT 10
   ;
