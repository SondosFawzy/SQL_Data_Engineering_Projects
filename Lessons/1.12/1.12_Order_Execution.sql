/*find the top 10 companies for posting jobs, they must have > 3000 postings*/

SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS number_of_jobs
FROM 
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON cd.company_id = jpf.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY number_of_jobs DESC;