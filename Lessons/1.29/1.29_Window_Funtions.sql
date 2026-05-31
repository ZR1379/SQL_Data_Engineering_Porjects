-- Count Rows -Aggergation Only
SELECT
    Count(*)
FROM
    job_postings_fact;

-- Count Rows -Window Function
SELECT
    job_id,
    COUNT(*) OVER()
FROM job_postings_fact;

-- PARTITION BY - Find hourly salary
SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 10;

-- ORDER BY - Ranking hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    rank() OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
-- ORDER BY salary_hour_avg DESC
LIMIT 10;

-- PARTITION BY & ORDER BY - Running Average Hourly Salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_by_title
FROM job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
    AND
    job_title_short = 'Data Engineer'
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;

-- PATTITION BY & ORDER BY - Ranking by job_title_short
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short 
LIMIT 10;

-- Ranking Functions - RANK() vs DENSE_RANK
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 140;

-- ROW_NUMBER() - Providing a new job_id
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    ROW_NUMBER() OVER(
        -- PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY salary_hour_avg DESC
LIMIT 20;

-- LAG() - Time Based Comparision of Company Yearly Salary
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_posting_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT 10;
