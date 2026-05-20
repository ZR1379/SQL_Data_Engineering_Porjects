EXPLAIN
SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact as jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY COUNT(jpf.job_id) DESC
LIMIT 10;

--/////////////////////////////////

EXPLAIN Analyze
SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact as jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY COUNT(jpf.job_id) DESC
LIMIT 10;