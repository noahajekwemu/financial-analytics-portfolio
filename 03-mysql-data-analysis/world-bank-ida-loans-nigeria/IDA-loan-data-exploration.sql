-- Data Cleaning
-- 1. update statements for all date columns
/*
-- DAte Format
	-- %d	Day of the month as a numeric value (01 to 31)
    -- %b	Abbreviated month name (Jan to Dec)
    -- %Y	Year as a numeric, 4-digit value
    -- ifnull where str_to_date returns null, set date to 0000-00-00
*/
UPDATE loan_data_ida.loan_data 
SET 
    end_of_period = STR_TO_DATE((CASE
                WHEN end_of_period = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE end_of_period
            END),
            '%d-%b-%Y'),
    first_repayment_dat = STR_TO_DATE((CASE
                WHEN first_repayment_dat = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE first_repayment_dat
            END),
            '%d-%b-%Y'),
    last_repayment_date = STR_TO_DATE((CASE
                WHEN last_repayment_date = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE last_repayment_date
            END),
            '%d-%b-%Y'),
     agreement_signing_date = STR_TO_DATE((CASE
                WHEN agreement_signing_date = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE agreement_signing_date
            END),
            '%d-%b-%Y'),
     board_approval_date = STR_TO_DATE((CASE
                WHEN board_approval_date = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE board_approval_date
            END),
            '%d-%b-%Y'),
     effective_date_most_recent = STR_TO_DATE((CASE
                WHEN effective_date_most_recent = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE effective_date_most_recent
            END),
            '%d-%b-%Y'),
     closed_date_most_recent = STR_TO_DATE((CASE
                WHEN closed_date_most_recent = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE closed_date_most_recent
            END),
            '%d-%b-%Y'),
     last_disbursement_date = STR_TO_DATE((CASE
                WHEN last_disbursement_date = '' THEN '01-Jan-1900' -- replace empty cells with '01-Jan-1900' to parse str_to_date
                ELSE last_disbursement_date
            END),
            '%d-%b-%Y')
;


-- 2 Alter all date columns to date type
ALTER TABLE loan_data_ida.loan_data
MODIFY COLUMN end_of_period date,
MODIFY COLUMN first_repayment_dat date,
MODIFY COLUMN last_repayment_date date,
MODIFY COLUMN agreement_signing_date date,
MODIFY COLUMN board_approval_date date,
MODIFY COLUMN effective_date_most_recent date,
MODIFY COLUMN closed_date_most_recent date,
MODIFY COLUMN last_disbursement_date date
;


-- update table, replace where date is '1900-01-01' to NULL
UPDATE loan_data_ida.loan_data
SET 
    end_of_period = CASE
                WHEN end_of_period = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE end_of_period
            END,
	first_repayment_dat = CASE
                WHEN first_repayment_dat = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE first_repayment_dat
            END,
    last_repayment_date = CASE
                WHEN last_repayment_date = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE last_repayment_date
            END,
    agreement_signing_date = CASE
                WHEN agreement_signing_date = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE agreement_signing_date
            END,
    board_approval_date = CASE
                WHEN board_approval_date = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE board_approval_date
            END,
    effective_date_most_recent = CASE
                WHEN effective_date_most_recent = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE effective_date_most_recent
            END,
    closed_date_most_recent = CASE
                WHEN closed_date_most_recent = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE closed_date_most_recent
            END,
	last_disbursement_date = CASE
                WHEN last_disbursement_date = '1900-01-01' THEN NULL -- replace '1900-01-01' to NULL
                ELSE last_disbursement_date
            END
    ;


-- UPDATE - replace empty calls with null for columns with data type double
UPDATE loan_data_ida.loan_data 
SET 
    service_charge_rate = CASE
                WHEN service_charge_rate = '' THEN NULL 
                ELSE service_charge_rate
            END,
	original_principal_amount_us = CASE
                WHEN original_principal_amount_us = '' THEN NULL 
                ELSE original_principal_amount_us
            END,
    cancelled_amount_us = CASE
                WHEN cancelled_amount_us = '' THEN NULL 
                ELSE cancelled_amount_us
            END,
    undisbursed_amount_us = CASE
                WHEN undisbursed_amount_us = '' THEN NULL 
                ELSE undisbursed_amount_us
            END,
    disbursed_amount_us = CASE
                WHEN disbursed_amount_us = '' THEN NULL 
                ELSE disbursed_amount_us
            END,
    repaid_to_ida_us = CASE
                WHEN repaid_to_ida_us = '' THEN NULL 
                ELSE repaid_to_ida_us
            END,
    due_to_ida_us = CASE
                WHEN due_to_ida_us = '' THEN NULL 
                ELSE due_to_ida_us
            END,
    exchange_adjustment_us = CASE
                WHEN exchange_adjustment_us = '' THEN NULL 
                ELSE exchange_adjustment_us
            END,
    borrowers_obligation_us = CASE
                WHEN borrowers_obligation_us = '' THEN NULL 
                ELSE borrowers_obligation_us
            END,
    sold_3rd_party_us = CASE
                WHEN sold_3rd_party_us = '' THEN NULL 
                ELSE sold_3rd_party_us
            END,
    repaid_3rd_party_us = CASE
                WHEN repaid_3rd_party_us = '' THEN NULL 
                ELSE repaid_3rd_party_us
            END,
    due_3rd_party_us = CASE
                WHEN due_3rd_party_us = '' THEN NULL 
                ELSE due_3rd_party_us
            END,
    credits_held_us = CASE
                WHEN credits_held_us = '' THEN NULL 
                ELSE credits_held_us
            END, 
    `borrower` = CASE
        WHEN `borrower` = '' THEN `project_name`
        ELSE `borrower`
    END
;


-- update empty borrow cells
UPDATE loan_data_ida.ngr_cgg_tbl 
SET 
    `borrower` = CASE
        WHEN `borrower` = '' THEN `project_name`
        ELSE `borrower`
    END
;


-- Table Indexing
create index idx_dates
ON loan_data_ida.loan_data 
	(`end_of_period`, `first_repayment_dat`, 
    `last_repayment_date`, `agreement_signing_date`, 
    `board_approval_date`, `effective_date_most_recent`, 
    `closed_date_most_recent`, `last_disbursement_date`);
    

create index idx_region
on loan_data_ida.loan_data
	(`region`);
    
create index idx_country
on loan_data_ida.loan_data
	(`country`);
    
create index idx_end_of_period
on loan_data_ida.loan_data
	(`end_of_period`);
    
create index idx_credit_status
on loan_data_ida.loan_data
	(`credit_status`);

create index idx_project_id
on loan_data_ida.loan_data
	(`project_id`);

    create index idx_credit_status_country
on loan_data_ida.loan_data
	(credit_status, country);
    
    create index idx_end_of_period_country
on loan_data_ida.loan_data
	(end_of_period, country);
    
    create index idx_end_of_period_credit_number
on loan_data_ida.loan_data
	(end_of_period, credit_number);


   create index idx_board_approval_date
on loan_data_ida.loan_data
	(board_approval_date);


CREATE INDEX idx_country_credit_principal
ON loan_data (country, credit_number, original_principal_amount_us);



-- Temporary table for data relating only to Nigeria
create temporary table tmp_loan_data
SELECT DISTINCT
    *
FROM
    loan_data
WHERE
    country = 'Nigeria'
ORDER BY end_of_period, board_approval_date
;



-- DATA Exploration
-- How many credits, grants, or guarantees has IDA provided to Nigeria and other countries?
WITH credit_type AS (
SELECT 
    CASE
        WHEN
            credit_number LIKE ('IDAE%')
                || credit_number LIKE ('IDAD%')
                || credit_number LIKE ('IDAH%')
        THEN
            'Grants'
        WHEN
            credit_number LIKE ('IDAB%')
                || credit_number LIKE ('IDAG%')
        THEN
            'Guarantees'
        ELSE 'Credits'
    END AS credit_category -- categorizing credit type
FROM
    tmp_loan_data
)
SELECT 
    credit_category,
    COUNT(credit_category) AS no_of_ida_facility_issued
FROM
    credit_type
GROUP BY credit_category
ORDER BY no_of_ida_facility_issued DESC
;



-- What is the total principal amount committed to Nigeria compared to other countries?
SELECT 
    country, SUM(principal_amount) AS total_principal
FROM
    (SELECT DISTINCT
        country,
            credit_number,
            MAX(original_principal_amount_us) AS principal_amount
    FROM
        loan_data
    GROUP BY country , credit_number) gg
GROUP BY country
ORDER BY total_principal DESC
;

-- What is the distribution of credit statuses (e.g., "Disbursing," "Fully Repaid") for Nigeria versus other countries?
SELECT 
    country,
    credit_status,
    COUNT(DISTINCT credit_number) AS no_credit_number
FROM
    loan_data
WHERE
    end_of_period = '2024-09-30'
GROUP BY country , credit_status
;



-- Financial Metrics
-- 4 What is the total disbursed amount to Nigeria, and how much remains undisbursed?
SELECT 
    format(SUM(disbursed_amount_us),0) AS total_disbursed_amount,
    format(SUM(undisbursed_amount_us),0) AS total_undisbursed_amount
FROM
    tmp_loan_data
where end_of_period = '2024-09-30'
;

-- 5 What is the total amount repaid by Nigeria to IDA?
SELECT 
    format(SUM(repaid_to_ida_us),0) AS total_repaid_to_ida
FROM
    tmp_loan_data
where end_of_period = '2024-09-30'
;

-- 6 What is the current outstanding obligation (due to IDA) for Nigeria?
SELECT 
    format(SUM(due_to_ida_us),0) AS total_due_to_ida
FROM
    tmp_loan_data
where end_of_period = '2024-09-30'
;

-- 7 What is the total amount cancelled from credits issued to Nigeria?
SELECT 
    format(SUM(cancelled_amount_us),0) AS total_cancelled_amount
FROM
    tmp_loan_data
where end_of_period = '2024-09-30'
;



-- Project-Specific Insights
-- Which projects have received the highest funding in Nigeria?
SELECT 
    project_id,
    project_name,
    SUM(original_principal_amount_us) AS total_original_funding_amount,
    SUM(disbursed_amount_us) AS total_disbursed_amount_us
FROM
    tmp_loan_data
WHERE
    end_of_period = '2024-09-30'
GROUP BY project_id , project_name
ORDER BY total_disbursed_amount_us DESC
;

-- What is the average funding size for project in Nigeria?
SELECT 
    format(AVG(original_principal_amount_us),0) AS avg_original_funding_amount
FROM
    tmp_loan_data
WHERE
    end_of_period = '2024-09-30'
;

-- How many projects in Nigeria are currently active versus closed? today's date '2024-11-13'
WITH project_category AS (
SELECT distinct
    `project_id`,
    CASE
        WHEN `closed_date_most_recent` < '2024-11-13' THEN 1
    END AS project_closed,
    CASE
        WHEN `closed_date_most_recent` > '2024-11-13' THEN 1
    END AS project_open
FROM
    tmp_loan_data 
 where end_of_period = '2024-09-30'
)
SELECT 
    COUNT(project_closed) AS number_of_projects_closed,
    COUNT(project_open) AS number_of_projects_effective
FROM
    project_category
;


-- What sectors (e.g., health, education) have received the most funding in Nigeria?
SELECT distinct
    `borrower`,
    SUM(`original_principal_amount_us`) AS original_principal_amount_us,
    SUM(`disbursed_amount_us`) AS disbursed_amount_us
FROM
    tmp_loan_data 
where end_of_period = '2024-09-30'
GROUP BY borrower
;


-- What is the undisbursed amount for each project in Nigeria?
SELECT distinct
    project_id,
    SUM(`undisbursed_amount_us`) AS undisbursed_amount
FROM
    tmp_loan_data 
where end_of_period = '2024-09-30'
GROUP BY project_id
order by undisbursed_amount desc
;


-- Timeline Analysis
-- How has the total funding (commitments) to Nigeria changed over the years?
SELECT DISTINCT
    effective_date_most_recent,
    original_principal_amount_us AS original_principal_amount_us
FROM
    loan_data_ida.ngr_cgg_tbl
WHERE
    effective_date_most_recent IS NOT NULL
        AND end_of_period = '2024-09-30'
ORDER BY effective_date_most_recent;


-- What are the trends in disbursements to Nigeria over time?

WITH disbursed_trend AS (
SELECT DISTINCT
    last_disbursement_date,
    credit_number,
    disbursed_amount_us
FROM
    tmp_loan_data
WHERE
    last_disbursement_date IS NOT NULL
        AND effective_date_most_recent > '2011-04-30' -- data compilation starting period
        AND last_disbursement_date > '2011-04-30' -- disbursed amount before this period is static
ORDER BY last_disbursement_date
),
lagged_disbursed_trend AS (
SELECT 
    last_disbursement_date,
    credit_number,
    disbursed_amount_us,
    ifnull(lag(disbursed_amount_us, 1) over(partition by credit_number order by last_disbursement_date),0) AS lag_disbursed_amount_us,
    disbursed_amount_us - 
		ifnull(lag(disbursed_amount_us, 1) over(partition by credit_number order by last_disbursement_date),0) AS diff_disbursed_amount_us -- set null values from lag to zero
FROM
    disbursed_trend
-- ORDER BY last_disbursement_date
)
SELECT 
    YEAR(last_disbursement_date) AS disbursement_date,
    CONCAT('$', FORMAT(SUM(diff_disbursed_amount_us) / 1000000 ,0), 'm') AS disbursements
FROM
    lagged_disbursed_trend
WHERE
    diff_disbursed_amount_us > 1
GROUP BY disbursement_date
ORDER BY disbursement_date
;

-- What is the average time between project approval and the first disbursement for projects in Nigeria?
WITH approval_effective_date AS (
SELECT 
    project_id,
    MAX(effective_date_most_recent) AS effective_date_most_recent,
	MAX(board_approval_date) AS board_approval_date
FROM
    tmp_loan_data
GROUP BY project_id
) , 
days_btw_app_eff AS (
SELECT 
    `project_id`,
    DATEDIFF(effective_date_most_recent,
            board_approval_date) AS days
FROM
    approval_effective_date
ORDER BY project_id
)
SELECT AVG(days) from days_btw_app_eff
;


-- What is the timeline of key events (e.g., approval, signing, disbursement) for credits to Nigeria?
WITH event_dates AS (
SELECT distinct
    credit_number,
    project_name,
    MAX(agreement_signing_date) AS agreement_signing_date,
	MAX(board_approval_date) AS board_approval_date,
    MAX(effective_date_most_recent) AS effective_date_most_recent
FROM
    tmp_loan_data
WHERE effective_date_most_recent IS NOT NULL
	AND agreement_signing_date IS NOT NULL
GROUP BY credit_number, project_name
)
SELECT 
    credit_number,
    project_name,
    DATEDIFF(agreement_signing_date,
            board_approval_date) AS approval_to_signing_days,
    DATEDIFF(effective_date_most_recent,
            agreement_signing_date) AS signing_to_disbursement_days
FROM
    event_dates
ORDER BY project_name
;



-- Repayment and Obligations
-- What are the trends in repayments from Nigeria to IDA over the years?
WITH repayments_to_ida AS (
SELECT DISTINCT
    end_of_period, credit_number, repaid_to_ida_us
FROM
    tmp_loan_data
WHERE
	repaid_to_ida_us > 0
		AND effective_date_most_recent > '2011-04-30' -- data compilation starting period
        AND last_disbursement_date > '2011-04-30' -- disbursed amount before this period is static
ORDER BY credit_number , end_of_period
),
lag_diff_repayments_to_ida AS (
SELECT
	end_of_period AS payment_date, 
    credit_number, 
    repaid_to_ida_us -
		IFNULL(lag(repaid_to_ida_us, 1) OVER(PARTITION BY credit_number ORDER BY end_of_period), 0) AS payments_diff_lag_payment
FROM repayments_to_ida
)
SELECT 
    payment_date,
    FORMAT(SUM(payments_diff_lag_payment),0) AS repaid_to_ida
FROM
    lag_diff_repayments_to_ida
GROUP BY payment_date
HAVING repaid_to_ida > 0
ORDER BY payment_date
;



-- What is the timeline of Nigeria's repayment obligations (e.g., first and last repayment dates)?
SELECT 
    credit_number,
    MAX(first_repayment_dat) AS first_repayment_dat,
    MAX(last_repayment_date) AS last_repayment_date,
    CONCAT(FORMAT(MAX(DATEDIFF(last_repayment_date, first_repayment_dat)),0), ' days') AS timeline
FROM
    tmp_loan_data
GROUP BY credit_number, project_name
HAVING timeline IS NOT NULL
ORDER BY first_repayment_dat, credit_number
;


-- Which credits have the highest outstanding balances owed by Nigeria?
SELECT 
    credit_number,
    MIN(due_to_ida_us) AS due_to_ida_us
FROM
    tmp_loan_data
GROUP BY credit_number
HAVING due_to_ida_us > 0
ORDER BY due_to_ida_us DESC

;


-- How much of Nigeria's obligation has been repaid versus the total due?
SELECT 
    credit_number,
    original_principal_amount_us,
    MAX(repaid_to_ida_us) AS repaid_to_ida_us,
    MAX(repaid_to_ida_us) / original_principal_amount_us * 100 AS percent_repaid_to_ida,
    MIN(due_to_ida_us) AS due_to_ida_us,
    MIN(due_to_ida_us) / original_principal_amount_us * 100 AS percent_due_to_ida_us
FROM
    tmp_loan_data
WHERE disbursed_amount_us > 0
GROUP BY credit_number, original_principal_amount_us
ORDER BY percent_repaid_to_ida DESC, percent_due_to_ida_us DESC
;


-- Historical Trends and Patterns
-- What is the trend in the number of new credit agreements signed by Nigeria annually?
SELECT 
    year(agreement_signing_date) AS agreement_signing_year, COUNT(distinct `credit_number`) AS num_signed
FROM
    tmp_loan_data
WHERE
    agreement_signing_date IS NOT NULL
GROUP BY agreement_signing_year
ORDER BY agreement_signing_year;


-- What is the proportion of fully disbursed versus partially disbursed credits in Nigeria over the last decade?
WITH credit_disburse_category AS (
SELECT 
    credit_number,
    CASE
        WHEN MIN(undisbursed_amount_us) > 0 THEN 'partially disbursed'
        ELSE 'fully disbursed'
    END AS disburse_category
FROM
    tmp_loan_data
WHERE
    agreement_signing_date IS NOT NULL
        AND agreement_signing_date > DATE_SUB((SELECT 
                MAX(end_of_period)
            FROM
                ngr_cgg_tbl),
        INTERVAL 10 YEAR)
GROUP BY credit_number
),
credit_disburse_category_pivot AS (
SELECT 
    credit_number,
    CASE
        WHEN disburse_category = 'fully disbursed' THEN disburse_category
    END AS fully_disbursed,
    CASE
        WHEN disburse_category = 'partially disbursed' THEN disburse_category
    END AS partially_disbursed
FROM
    credit_disburse_category
-- GROUP BY credit_number
)
SELECT 
    COUNT(fully_disbursed) / COUNT(credit_number) AS prop_fully_disbursed,
    COUNT(partially_disbursed) / COUNT(credit_number) AS prop_undisbursed
FROM
    credit_disburse_category_pivot
;


-- Operational Metrics
-- What is the average service charge rate applied to credits in Nigeria?
SELECT 
    AVG(service_charge_rate) AS avg_service_charge_rate
FROM
    (SELECT 
        credit_number,
            MAX(service_charge_rate) AS service_charge_rate
    FROM
        tmp_loan_data
    GROUP BY credit_number
    HAVING service_charge_rate IS NOT NULL) AS service_charge;

-- What percentage of Nigeria's credits have reached the "Fully Repaid" status?

SELECT COUNT(paid_credit_status) / COUNT(credit_number) AS percent_credit_fully_repaid
FROM (
SELECT 
    credit_number,
    MAX(CASE
        WHEN credit_status = 'Fully Repaid' THEN credit_status
    END) AS paid_credit_status
FROM
    tmp_loan_data
GROUP BY credit_number) fr;

-- What is the approval rate of credits in Nigeria?
SELECT COUNT(approved_credit_status) / COUNT(credit_number) AS percent_credit_approved
FROM (
SELECT 
    credit_number,
    MAX(CASE
        WHEN credit_status = 'Approved' THEN credit_status
    END) AS approved_credit_status
FROM
    tmp_loan_data
GROUP BY credit_number) ap;

SELECT yr, COUNT(project_id) AS no_of_credits
FROM (
SELECT DISTINCT
    MAX(YEAR(board_approval_date)) AS yr,
    project_id,
    MAX(project_name) project_name
FROM
    tmp_loan_data
GROUP BY project_id
ORDER BY project_id
) credits_per_yr
GROUP BY yr
-- ORDER BY no_of_credits DESC
;



-- VISUALIZATION
-- View exported to Tableau for visualizations
CREATE view ida_oan_ngr_20240930_snapshot AS 
SELECT DISTINCT
	board_approval_date AS 'Approval Date',
    credit_number,
    project_id,
    project_name AS 'Project Name',
    original_principal_amount_us AS 'Funding',
    disbursed_amount_us AS 'Disbursed Amount',
    repaid_to_ida_us AS 'Repayments',
    due_to_ida_us AS 'Balance',
    credit_status AS 'Status'
FROM loan_data
WHERE end_of_period = '2024-09-30'
	AND original_principal_amount_us > 0
    AND country = 'Nigeria'
ORDER BY 'Approval Date', credit_number, project_id
;
