/*
query- what are the most optimal skills to learn(aka it's in high demand and high-paying skill)?
- Identify skills in high demand and associated with high average salaries for data analyst role
- concentrates on remote positions with specified salaries
- why? target skills that offer job security (high demand) and financial benifits(high salaries),
    offering stratigic insights for career development in data analysis
*/

WITH skill_demands AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short='Data Analyst' 
        AND
        salary_year_avg IS NOT NULL
        AND
        job_postings_fact.job_work_from_home=TRUE
    GROUP BY
        skills_dim.skill_id
), avg_salary AS(
    SELECT 
        skills_job_dim.skill_id,
        round(avg(salary_year_avg),0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short='Data Analyst' 
        AND
        salary_year_avg IS NOT NULL
        AND
        job_work_from_home=TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skill_demands.skill_id,
    skill_demands.skills,
    demand_count,
    avg_salary
FROM
    skill_demands
INNER JOIN
    avg_salary ON skill_demands.skill_id=avg_salary.skill_id
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25