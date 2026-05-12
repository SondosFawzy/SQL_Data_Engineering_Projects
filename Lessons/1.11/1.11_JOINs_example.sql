/*Show associated skills for job postings*/

SELECT 
    jpf.job_title_short,
    sjd.job_id,
    sjd.skill_id,
    sd.skills,
    sd.type
FROM 
  (job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id) 
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
lIMIT 200;


/*INS SOLUTION*/

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM 
    job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM 
    job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;