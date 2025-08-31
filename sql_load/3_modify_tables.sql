/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

Possible Errors: 
- ERROR >>  duplicate key value violates unique constraint "company_dim_pkey"
- ERROR >> could not open file "C:\Users\...\company_dim.csv" for reading: Permission denied

1. Drop the Database 
            DROP DATABASE IF EXISTS sql_course;
2. Repeat steps to create database and load table schemas
            - 1_create_database.sql
            - 2_create_tables.sql
3. Open pgAdmin
4. In Object Explorer (left-hand pane), navigate to `sql_course` database
5. Right-click `sql_course` and select `PSQL Tool`
            - This opens a terminal window to write the following code
6. Get the absolute file path of your csv files
            1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
7. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '/Users/bansalshrivastava/Desktop/SQL_Data_Analysis/csv_files/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '/Users/bansalshrivastava/Desktop/SQL_Data_Analysis/csv_files/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '/Users/bansalshrivastava/Desktop/SQL_Data_Analysis/csv_files/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '/Users/bansalshrivastava/Desktop/SQL_Data_Analysis/csv_files/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- */

-- -- NOTE: This has been updated from the video to fix issues with encoding
-- COPY company_dim
-- FROM '/Users/bansalshrivastava/Desktop/SQL_Data_Analysis/csv_files/company_dim.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- COPY skills_dim
-- FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\skills_dim.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- COPY job_postings_fact
-- FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\job_postings_fact.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- COPY skills_job_dim
-- FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\skills_job_dim.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


-- SELECT
--     job_title_short,
--     job_location,
--     job_posted_date::DATE,
--     job_posted_date::TIME,
--     job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS timezone,
--     EXTRACT(MONTH from job_posted_date) as date_month,
--     EXTRACT(YEAR from job_posted_date) as YEAR
-- FROM
--     job_postings_fact LIMIT 100;


-- SELECT
--     count(job_id),
--     EXTRACT(MONTH from job_posted_date) as Month
-- FROM 
--     job_postings_fact
-- WHERE
--     job_title_short='Data Analyst'
-- GROUP BY
--     MONTH
-- ORDER BY 
--     MONTH;


-- CREATE TABLE January_jobs AS
--     SELECT * FROM job_postings_fact
--     WHERE EXTRACT(MONTH from job_posted_date)=1;

-- CREATE TABLE february_jobs AS
--     SELECT * FROM job_postings_fact
--     WHERE EXTRACT(MONTH from job_posted_date)=2;

-- CREATE TABLE march_jobs AS
--     SELECT * FROM job_postings_fact
--     WHERE EXTRACT(MONTH from job_posted_date)=3;


-- SELECT job_posted_date FROM january_jobs;


-- SELECT
--     count(job_id) as number_of_jobs,
--     CASE
--         WHEN job_location= 'Anywhere' THEN 'Remote'
--         WHEN job_location= 'New York, NY' THEN 'Local'
--         ELSE 'Onsite'
--     END AS location_category
-- FROM
--     job_postings_fact
-- WHERE job_title_short='Data Analyst'
-- GROUP BY 
--     location_category;


-- SELECT 
--     company_id, 
--     name as Company_name 
-- FROM
--     company_dim
-- WHERE company_id IN (
--     SELECT 
--         company_id 
--     from 
--         job_postings_fact 
--     WHERE 
--         job_no_degree_mention=TRUE
--     ORDER BY
--         company_id);


-- SELECT 
--     company_id, count(*)

-- FROM
--     job_postings_fact
-- GROUP BY
--     company_id


-- WITH company_job_count AS(
--     SELECT company_id,
--         count(*) as job_count
--     FROM 
--         job_postings_fact
--     GROUP BY
--         company_id
-- )

-- SELECT
--     company_dim.name as Company_name,
--     company_job_count.job_count
-- from company_dim LEFT JOIN company_job_count
-- ON company_job_count.company_id=company_dim.company_id
-- ORDER BY 
    -- job_count DESC;


-- SELECT 
--     skill_id,
--     count(*) as skill_count
-- FROM
--     skills_job_dim AS skills_to_job
-- INNER JOIN 
--     job_postings_fact AS job_postings
-- ON
--     job_postings.job_id=skills_to_job.job_id
-- WHERE job_work_from_home=TRUE
-- GROUP BY skill_id;


-- WITH remote_job_skills AS(
-- SELECT 
--     skill_id,
--     count(*) as skill_count
-- FROM
--     skills_job_dim AS skills_to_job
-- INNER JOIN 
--     job_postings_fact AS job_postings
-- ON
--     job_postings.job_id=skills_to_job.job_id
-- WHERE job_work_from_home=TRUE
-- AND job_postings.job_title_short='Data Analyst'
-- GROUP BY skill_id)

-- select 
--     skills.skill_id,
--     skills as skill_name,
--     skill_count
-- from remote_job_skills
-- INNER JOIN skills_dim AS skills 
-- ON skills.skill_id=remote_job_skills.skill_id
-- ORDER BY
--     skill_count DESC
-- LIMIT 10;


