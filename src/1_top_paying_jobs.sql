/* 
Question: What are the top paying data analyst jobs?
- To identify the top 10 highest paying data analyst roles that are available remotely
- Focus on job postings with specified salaries (removing nulls)
- why? highlighting the top paying opportunities for data analysts, offering insights into the skills required for the roles
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact