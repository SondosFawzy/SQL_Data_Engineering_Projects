--.read Lessons/1.21/1.21_DDL_DML_p1.sql
USE data_jobs;
DROP DATABASE IF EXISTS jobs_mart;

CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

--DROP DATABASE IF EXISTS jobs_mart;

SHOW DATABASES;

SELECT *
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;





SELECT * FROM
information_schema.tables
WHERE table_catalog = 'jobs_mart';  

CREATE TABLE IF NOT EXISTS staging.preffered_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);


INSERT INTO staging.preffered_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
     (3, 'Software Engineer');

SELECT *
FROM staging.preffered_roles;

ALTER TABLE staging.preffered_roles 
ADD COLUMN preffered_role BOOLEAN;

INSERT INTO staging.preffered_roles (preffered_role)
VALUES
    (TRUE),
    (TRUE),
    (FALSE);
   
UPDATE staging.preffered_roles
SET preffered_role = TRUE 
WHERE role_name = 'Data Engineer' OR role_name = 'Senior Data Engineer';


UPDATE staging.preffered_roles
SET preffered_role = FALSE 
WHERE role_name = 'Software Engineer';

--CHANGE THE NAME OF THE table

ALTER TABLE staging.preffered_roles
RENAME TO priority_roles;


SELECT *
FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preffered_role TO role_priority;

ALTER TABLE staging.priority_roles
ALTER COLUMN role_priority TYPE INTEGER;

UPDATE staging.priority_roles
SET role_priority = 1
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.priority_roles
SET role_priority = 3
WHERE role_id = 3;

