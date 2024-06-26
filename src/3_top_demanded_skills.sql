/* following on from the previous query, having looked at the top paid skills, I will now delve a bit deeper and review the most "in demand" skills.
It will be interesting to note the correlation between the most in demand skills and the top paid skills.

To do this I will join the job postings via an inner query
I will focus on the top 5 most in demand skills for the roles i set out previously
This will focus on all job postings in the UK
For interest, I will compare the most in demand skills in the UK vs remote that could be located elsewhere
We can from this reflect on the most valuable skills for me to improve as a job seeker
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_location = 'Anywhere' AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5

/*
1. Focus on keeping the same joined tables from previous table but selecting skills and the count to focus only
on those 2 parameters.

2. Added different where clauses for each search to look at the results within the UK and for results in remote jobs
Again only for the roles where I could be a suitable candidate

3. Grouped by skills since this is the focus of this query and ordered by the demand_count DESC to get the most
in demand skills first

4. Limited to the top 5 skills to hone in on what I may need to focus on as I enter this new career

5. Removed the salary_yearly_avg compared to previous queries as the focus here is on the most in demand skills 
required irresepctive of whether the salaries were listed on the job posting or not

6. Interesting that both result sets have the same 5 top in demand skills in the UK and Remote, with 2 of the 5 being
visulisation tools - highlighting that not only is it important to be able to analyse data, but presenting it well is
argueably just as key for employers.
SQL and Excel remain the best skills to have for both demand and pay for any job seekers looking to enter the field.
However in the UK a visulisation tool, like power BI, may be more in demand than learning further programming languages.
*/

-- attempt at a case statement to showcase both result tables together
SELECT 
    skills,
    COUNT(CASE 
              WHEN job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%' 
              THEN skills_job_dim.job_id 
         END) AS demand_count_uk,
    COUNT(CASE 
              WHEN job_location = 'Anywhere' 
              THEN skills_job_dim.job_id 
         END) AS demand_count_anywhere
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    skills
ORDER BY
    demand_count_uk DESC, demand_count_anywhere DESC
LIMIT 5