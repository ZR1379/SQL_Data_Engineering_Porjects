-- .read ./Lessons/1.21/1.21_DDL_DML_Pt1.sql

USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart;

CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

SELECT *
FROM information_schema.schemata;

CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;
-- DROP SCHEMA if exists jobs_mart.staging;

CREATE TABLE IF NOT exists jobs_mart.staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

-- DROP TABLE IF EXISTS main.preferred_roles;

INSERT INTO jobs_mart.staging.preferred_roles(role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');

SELECT *
FROM jobs_mart.staging.preferred_roles;

ALTER TABLE jobs_mart.staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;
-- ALTER TABLE jobs_mart.staging.preferred_roles
-- DROP COLUMN preferred_role;

UPDATE jobs_mart.staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE jobs_mart.staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3;

ALTER TABLE jobs_mart.staging.preferred_roles
RENAME TO priority_roles;

SELECT *
FROM jobs_mart.staging.priority_roles;

ALTER TABLE jobs_mart.staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

SELECT *
FROM jobs_mart.staging.priority_roles;

ALTER TABLE jobs_mart.staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

SELECT *
FROM jobs_mart.staging.priority_roles;

UPDATE jobs_mart.staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

SELECT *
FROM jobs_mart.staging.priority_roles;