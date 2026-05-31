-- Subquery
SELECT *
FROM (
    SELECT *
    FROM data_jobs.main.job_postings_fact
    WHERE salary_year_avg is not null
    OR
        salary_hour_avg is not null
) AS valid_salaries
LIMIT 10;

-- CTE
WITH valid_salaries AS(
    SELECT *
    FROM data_jobs.main.job_postings_fact
    WHERE salary_year_avg is not null
    OR
        salary_hour_avg is not null
)

SELECT *
FROM valid_salaries
LIMIT 10;

-- Scenario 1 - Subquery in 'SELECT'
-- Show each job's salary next to the overall market median;
SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
    ) AS median_salary
FROM job_postings_fact
WHERE salary_year_avg is not null
limit 10;

-- Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating;

SELECT
    job_title_short,
    median(salary_year_avg) AS median_salary,
    (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = True
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
limit 10;

-- Scenario 3 - Subquery in 'HAVING'
-- Keep only job titles whose median salary is above the overall medain;
SELECT
    job_title_short,
    median(salary_year_avg) AS median_salary,
    (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = True
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING median(salary_year_avg) > (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = True
)
limit 10;

-- CTE Example
-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
-- Use a CTE to calculate the median salary by title work arrangement, then compare those medians.
WITH title_median AS(
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INTEGER AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_Salary,
    (r.median_salary) - (o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE;

----------------------------------------------------------------------
SELECT * 
FROM range(3) AS src(key);

SELECT * 
FROM range(2) AS tgt(key);

SELECT * 
FROM range(3) AS src(key)
WHERE not EXISTS(
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);


-- Final Example
-- Identify job postings that have no associated skills before loading them into a data mart
SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT *
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;

SELECT *
FROM job_postings_fact AS tgt
WHERE EXISTS(
    SELECT *
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;