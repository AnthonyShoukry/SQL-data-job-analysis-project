/* 
query 1: looked at the top paying jobs within my role requirments
query 2: looked at the top paying skills within my role requirments
query 3: looked at the most in demand skills within my role requirements
query 4: aim to look at the average salary for those skills - do they correlate with the the top paying jobs or the most in demand skills? UK focused
         but we can delve into what is the most financially rewarding skill to learn/improve? 
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 15


/* to find the average of the salaries in the UK verses remote jobs it was better to add a CASE statement to group any job that had
'UK' or 'United Kingdom' to ensure a fair avg was taken of all the jobs posted.
*/

SELECT
    CASE
        WHEN job_location LIKE '%UK%' THEN 'UK'
        WHEN job_location LIKE '%United Kingdom%' THEN 'UK'
        ELSE job_location
    END AS grouped_location,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%' OR job_location LIKE '%Anywhere%') AND
    salary_year_avg IS NOT NULL AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    grouped_location
ORDER BY
    avg_salary DESC


/* 
1. Used previous query but removed the skill count and instead did an average of the salary_year_avg to find the average salaries per skill

2. This was then rounded to 0 decimal places

3. Order by statement was corrected to order by the avg_salary and then limited to the top 15 paying skills as an average from all the job listings
in the UK

4. Interesting to note that there are programs and database management systems that are new to me on this list such as dax and oracle etc. 
However mysql, pyspark etc are still featured in the top 15 average salaries.

5. Second search shows that the average salary in the UK is considerably lower than those with remote jobs, added CASE statement as described above

