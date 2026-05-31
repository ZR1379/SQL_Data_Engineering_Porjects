-- .read Lessons/1.24/priority_jobs_snapshot.sql

-- CREATE TEMP Table
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.main.job_postings_fact AS jpf
LEFT JOIN data_jobs.main.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN jobs_mart.staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;

-- -- UPDATE statement
-- UPDATE jobs_mart.main.priority_jobs_snapshot AS tgt
-- SET 
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE tgt.job_id = src.job_id
--     AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;

-- -- INSERT statement
-- INSERT INTO jobs_mart.main.priority_jobs_snapshot(
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- )
-- SELECT
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE NOT EXISTS(
--     SELECT 1
--     FROM jobs_mart.main.priority_jobs_snapshot AS tgt
--     WHERE tgt.job_id = src.job_id
-- );

-- SELECT
--     job_title_short,
--     count(job_title_short),
--     MIN(priority_lvl) AS priority_lvl,
--     MIN(updated_at) AS updated_at
-- FROM src_priority_jobs
-- GROUP BY job_title_short;

-- -- DELETE statement
-- DELETE FROM jobs_mart.main.priority_jobs_snapshot AS tgt
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM src_priority_jobs AS src
--     WHERE src.job_id = tgt.job_id
-- );

-- MERGE INTO
MERGE INTO jobs_mart.main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN
    INSERT (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
VALUES (
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)

WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Final Check

SELECT
    job_title_short,
    count(job_title_short),
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM src_priority_jobs
GROUP BY job_title_short;