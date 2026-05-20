SELECT *
FROM information_schema.tables;
WHERE table_catalog = 'data_jobs';

SELECT table_name, column_name, data_type
FROM information_schema.columns;
WHERE table_catalog = 'data_jobs';

SELECT *
FROM information_schema.table_constraints
where table_catalog = 'data_jobs';

PRAGMA show_tables_expanded;

DESCRIBE job_postings_fact;