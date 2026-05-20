-- LEFT JOIN PRACTICE
SELECT
    COUNT(*)
FROM
    job_postings_fact;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

-- RIGHT JOIN PRACTICE

SELECT
    COUNT(*)
FROM
    job_postings_fact;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
RIGHT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

-- INNER JOIN PRACTICE
SELECT
    COUNT(*)
FROM
    job_postings_fact;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

--FULL OUTER JOIN PRACTICE
SELECT
    COUNT(*)
FROM
    job_postings_fact;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
FULL OUTER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM skill_dim
LIMIT 10;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim as sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;