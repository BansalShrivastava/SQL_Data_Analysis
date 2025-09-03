/* Query- What are the top paying data analyst job
-Identify the top 10 highest-paying data analyst roles that are availble remotely
- focuses on job postings with specified salaries (remove nulls)
- why? highlight the top paying job opportunities for data analysts, offering insights into employment opportunity 
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS Company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id
WHERE 
    job_title_short='Data Analyst'
    AND
    job_location='Anywhere'
    AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;