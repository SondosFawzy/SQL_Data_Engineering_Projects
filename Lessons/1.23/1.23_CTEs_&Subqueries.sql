WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_hour_avg IS NOT NULL 
    OR salary_year_avg IS NOT NULL
)
SELECT *
FROM valid_salaries;


SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_hour_avg IS NOT NULL 
    OR salary_year_avg IS NOT NULL
) AS valid_salaries
LIMIT 10;


--sc1: subquery in 'SELECT'
--Show each job salary next to the overall market median: 

SELECT 
    job_title_short, 
    MEDIAN(salary_year_avg) AS market_median_yearly_salary,
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 10;

SELECT 
    job_title_short, 
    MEDIAN(salary_year_avg) AS market_median_yearly_salary,
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY
    job_title_short
LIMIT 10;

SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT
            MEDIAN(salary_year_avg)
        FROM 
            job_postings_fact
    ) AS market_median_yearly_salary
FROM
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 10;



--sc2: subquery in 'FROM'
--Stage only jobs that are remote before aggregating to determine the remote median salary per job



SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
    SELECT
        MEDIAN(salary_year_avg)
    FROM 
        job_postings_fact
    ) AS market_median_yearly_salary
FROM 
    job_postings_fact
WHERE salary_year_avg IS NOT NULL AND job_work_from_home = TRUE
GROUP BY job_title_short
LIMIT 10;

SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
    SELECT
        MEDIAN(salary_year_avg)
    FROM 
        job_postings_fact
    WHERE
        job_work_from_home = TRUE
    ) AS market_median_yearly_salary
FROM 
(
    SELECT 
        job_title_short,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE 
        job_work_from_home = TRUE

) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;

--sc3: subquery in 'HAVING'
--keep only job titles whose median salary is above the overall median


SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT
            MEDIAN(salary_year_avg) 
        FROM
            job_postings_fact
        WHERE
            job_work_from_home = TRUE
    ) AS market_median_yearly_salary

FROM 
    job_postings_fact
WHERE
    job_work_from_home = TRUE
GROUP BY
    job_title_short
HAVING
    median_salary > market_median_yearly_salary;



--CTE Example
--compare how much more (or less) remote roles pay compared to onsite roles for each job title
--use a CTE to calculate the median salary by title and work arrangements, then compare those medians.

WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM 
        job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    o.median_salary AS onsite_median_salary,
    r.median_salary AS remote_meedian_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM 
    title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short = o.job_title_short
WHERE 
    r.job_work_from_home = TRUE
        AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;



SELECT *
FROM range(3) AS src(key); --table_name(column_name): alias in the case of creating a table using a function

SELECT *
FROM RANGE(2) AS tgt(key);


SELECT *
FROM range(3) AS src(key) 
WHERE EXISTS 
(

    SELECT 1
    FROM RANGE(2) AS tgt(key)
    WHERE
    src.key = tgt.key
);


SELECT *
FROM range(3) AS src(key) 
WHERE NOT EXISTS 
(

    SELECT 1
    FROM RANGE(2) AS tgt(key)
    WHERE
    src.key = tgt.key
);



--identify job postings that have no associated skills before loading them into data mart

SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT * 
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;


SELECT *
FROM job_postings_fact AS src
WHERE NOT EXISTS 
(
    SELECT 1
    FROM skills_job_dim AS tgt
    WHERE src.job_id = tgt.job_id
)
ORDER BY job_id;