SELECT 
    jpf.job_id,
    cd.name AS company_name,
    job_title_short
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

SELECT

    jpf.*,
    cd.*
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd 
    ON cd.company_id = jpf.company_id
LIMIT 10;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
RIGHT JOIN company_dim AS cd 
    ON cd.company_id = jpf.company_id
LIMIT 10;

SELECT * FROM company_dim
LIMIT 10;

SELECT * 
FROM information_schema.tables
WHERE table_catalog = 'data_jobs';

SELECT 
column_name
FROM information_schema.columns
WHERE table_name = 'company_dim';


SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf
INNER JOIN company_dim AS cd 
    ON cd.company_id = jpf.company_id
LIMIT 10;