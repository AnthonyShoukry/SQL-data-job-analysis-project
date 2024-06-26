/* 
Question: What are the top paying data analyst jobs within my set criteria?
- To identify the top 50 highest paying data analyst roles that are available within the UK
- Focus on job postings with specified salaries (removing nulls)
- why? highlighting the top paying opportunities for data analysts
*/


SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE,
    company_dim.name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
ORDER BY 
    salary_year_avg DESC
LIMIT 50;

/* 
1. Reviewed data to look for roles within the UK, noted that dataset had results for UK and United Kingdom
ensured both were included in where clause to capture all the jobs in the dataset within the intended area.

2. Next I removed any results that had NULL values for salaries.

3. Filtered for role that include the word 'Analyst' and removed those that included the word 'Senior' or 'Sr'
This is to make it more personal to my needs to reflect the type of roles I will look to apply for myself. 

4. Joined company_dim table to note the companies that lsited these roles.

5. Cast job_posted_date to DATE to remove time stamp.

6. Limited results to the top 50 jobs.
*/