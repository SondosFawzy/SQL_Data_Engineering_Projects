SELECT LENGTH('SQL');
SELECT CHAR_LENGTH('Sond_os');
SELECT UPPER('sql');
SELECT LOWER('SQl');
SELECT LEFT('SONDOS', 2);
SELECT RIGHT('SONDOS', 2);
SELECT SUBSTRING('SONDOS', 2,2);
SELECT CONCAT('SONDOS ', 'FAW',' SONDOS');
SELECT 'SONDOS ' || 'FAW' || ' SONDOS';
SELECT TRIM('SONDOS FAWZY '); --TRIMS WHITE SPACE AT THE START AND AT THE END OF A TEXT

--REPLACEMENT

SELECT REPLACE('SQL', 'Q', '_');
SELECT REGEXP_REPLACE('data.nerd@gmail.com','.*(@.*)$', '\1');

--final example - clean up this using text functions

WITH title_lower AS(
    SELECT 
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM
        job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%'
            THEN 'Data Analyst'
         WHEN  job_title_clean LIKE '%data%' AND job_title_clean LIKE '%engineer%'
            THEN 'Data Engineer'
        WHEN  job_title_clean LIKE '%data%' AND job_title_clean LIKE '%scientist%'
            THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category
FROM 
    title_lower
ORDER BY RANDOM()
LIMIT 20;

--Null functions
/*NULLIF ACCEPTS 2 ARGUMENTS, RETURN NULL IF THEY ARE EQUAL. 
RETURNS THE FIRST ONE IF THEY ARE NOT EQUAL
*/
SELECT NULLIF(10,10);
SELECT NULLIF(10,20);

SELECT --i.e: useful for eliminating zeroes, if we performed a median for example
    NULLIF(salary_year_avg,0), 
    NULLIF(salary_hour_avg,0)
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg
LIMIT 10;

--coalesce: returns first non-null value

SELECT
    salary_year_avg, 
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


--Null function final example



SELECT 
    job_title_short,
    salary_year_avg,
    salary_hour_avg, 
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardized_salary,
    CASE 
        WHEN standardized_salary IS NULL THEN 'Missing'
        WHEN standardized_salary < 75_000 THEN 'Low'
        WHEN standardized_salary < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;