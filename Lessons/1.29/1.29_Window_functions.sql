--Count rows - Aggregation only

SELECT 
    COUNT(*)
FROM 
    job_postings_fact;


--Count rows - Window Functions: preserving the individuality of eaach row (row-level data)

SELECT 
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact;

--calculate average of salary_hour_avg by job_title short


SELECT
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg)
FROM
    job_postings_fact
GROUP BY
    job_title_short, salary_hour_avg;

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER () --not providing a partion by function calculates over the entire data set
FROM
    job_postings_fact;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
    ) AS avg_hourly_by_title
FROM
    job_postings_fact;


SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short, company_id
    )
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY company_id;

--Order by - Ranking hourly salary

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
/*ORDER BY 
    salary_hour_avg DESC;*/ --however it's always a good practice to keep the order by
LIMIT 10;

--PARTIOTION BY & ORDER BY: Running average hourly salary

SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_by_title
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    job_title_short,
    job_posted_date;

--PARTION BY & ORDER BY: Ranking by job_title_short

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC,
    job_title_short;
    