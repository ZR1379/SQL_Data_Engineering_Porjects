SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

DESCRIBE
SELECT
    job_title_short,
    salary_year_avg
FROM
    job_postings_fact;

SELECT CAST(123 AS VARCHAR);
SELECT CAST('123DEF' AS INTEGER); -- error
SELECT CAST('123' AS INTEGER);

SELECT
    job_id, --'more' unique identifier
    company_id,
    job_work_from_home, -- boolean
    job_posted_date, -- timestamp
    salary_year_avg -- double
FROM
    job_postings_fact
LIMIT 10;

SELECT
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR) AS unique_id,
    CAST(job_work_from_home AS INT) AS job_work_from_home,
    CAST(job_posted_date AS DATE) AS job_posted_date,
    CAST(salary_year_avg AS DECIMAL(10,0)) AS salary_year_avg
FROM
    job_postings_fact
WHERE 
    salary_year_avg is not null
LIMIT 10;

SELECT
    job_id::VARCHAR || '-' || company_id::VARCHAR AS unique_id,
    job_work_from_home::INT AS job_work_from_home,
    job_posted_date::DATE AS job_posted_date,
    salary_year_avg::DECIMAL(10,0) AS salary_year_avg
FROM
    job_postings_fact
WHERE 
    salary_year_avg is not null
LIMIT 10;