--Array Intro

SELECT [1, 2, 3];


WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS ( --order by skill: sorted alphapetically
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills --LIST = ARRAY_AGG,
    FROM skills
    )
SELECT 
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;

--STRUCT

SELECT {skill: 'python', type: 'programming'} AS skill_struct;
--to access things wrap in a CTE

WITH skill_struct AS (
    SELECT
        STRUCT_PACK(
            skill:= 'python', 
            type:= 'programming',
            level:='expert', 
            years:= 3
            ) AS s
)
SELECT 
  s.skill, 
  s.type,
  s.level,
  s.years
FROM 
    skill_struct;


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)

SELECT 
    STRUCT_PACK (
        skill:= skills,
        type:= types
    )
FROM skill_table;

--Array of Structs

SELECT [
    {skill: 'python', type: 'programmming'},
    {sill: 'sql', type: 'query_language'}
] AS skills_array_of_structs;


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
),
skills_array_struct AS (
    SELECT 
    ARRAY_AGG( 
        STRUCT_PACK (
            skill:= skills,
            type:= types
        )
    ) AS array_struct
    FROM skill_table
)

SELECT 
    array_struct[1].skill,
    array_struct[1].type,
FROM skills_array_struct;

--Map, Dictionary, Object
WITH skill_map AS (
SELECT MAP {'skill': 'python', 'type': 'programming'} AS skill_type
) 

SELECT 
    skill_type['skill'],
    skill_type['type']
FROM skill_map;

--JSON
WITH raw_skill_json AS (
    SELECT 
        '{"skill":"python", "type":"programmming"}'::JSON AS skill_json
)
SELECT --structs are better in SQL, json often is received data
    STRUCT_PACK(
        skill:= JSON_EXTRACT_STRING(skill_json, '$.skill'), 
        type:= JSON_EXTRACT_STRING(skill_json, '$.type')
    )
FROM raw_skill_json;

--json to array of structs

WITH raw_json AS (
    SELECT 
    '[
    {"skill": "python", "type":"programming"},
    {"skill": "sql", "type":"query_language"},
    {"skill": "r", "type":"programming"}
    ]' ::JSON AS skills_json
)

SELECT 
  ARRAY_AGG(STRUCT_PACK(
        skill:= JSON_EXTRACT_STRING(e.value, '$.skill'),
        type:= JSON_EXTRACT_STRING(e.value, '$.type')
    ) 
    ORDER BY JSON_EXTRACT_STRING(e.value, '$.skill')
    ) AS skills
FROM raw_json, json_each(skills_json) AS e;

--Array - final example
/* Build a flat skill table for coworkers to access job titles, salary info, 
and skills in one table */

CREATE OR REPLACE TEMP TABLE job_skills_array AS 

    SELECT 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM 
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id
    GROUP BY ALL;

--FROM THE PERSPECTIVE AF A DATA ANALYST, analyze the median salary per skill
--using the temp table we just made

WITH flat_skills AS (
    SELECT
        job_id, 
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;

--Array of structs - final example
/* Build a flat skill and type table for coworkers to access job titles, salary info, type
and skills in one table */

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(STRUCT_PACK(
        skill:=sd.skills,
        type:=sd.type
        ) 
    )AS skills_type_array_struct
FROM 
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;