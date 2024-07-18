
For the top 5 in demand skills from the previous query, I wanted to look at the various salary ranges for the jobs listed in the UK and remote, 
To do this I added the skills_job_dim back into the select statement with MIN and MAX on the salary_year_avg to look at the range of salaries for each skill
I also counted the number of jobs within that
I ordered by the number_of_jobs to review the most frequently occuring jobs in the UK and
the avg_salary DESC
grouped by the skill since that is what I am aggregating 
Limited to the top 10 commonly present skills in job listings
*/

SELECT
    skills,
    MIN(salary_year_avg) AS min_salary,
    MAX(salary_year_avg) AS max_salary,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary,
    COUNT(skills_job_dim.job_id) AS number_of_jobs
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
    number_of_jobs DESC, avg_salary DESC
LIMIT 10

/* 
A review of the results from this search can help us infer the following from jobs in the UK:

1. Salary Range and Averages: 
Each skill has a range of salaries associated with it (from min_salary to max_salary)
indicating the variability in compensation for roles requiring that skill

2. Demand (Number of Jobs): 
The number_of_jobs field indicates the demand for each skill in the job market. 
Skills like SQL and Excel have a higher number of job postings compared to skills like R, Power BI, Word, and Outlook.
We have seen this matching with previous queries also.

3. Comparison Across Skills: 
By comparing avg_salary values, we can get a sense of which skills tend to command higher salaries on average. 
For example, SAS and Excel have higher average salaries compared to R and Power BI.

4. Specialised Skills: 
Skills like SAS, R, and Tableau, have fewer job postings but potentially higher average salaries, might indicate a demand for specialised expertise.

As a new jobseeker within this field I can use the insights so far to understand the following for my own personal career:

1. Skill popularity and entry-Level opportunities:
    SQL and Excel are highly sought after across various job postings, suggesting they are fundamental and widely applicable in many data related industries.
    Entry-Level Pay Variability - Despite SQL and Excel being so common, entry-level salaries vary, indicating opportunities for negotiation and growth based on additional skills and experience - this could be dependant on domain knowledge e.g healthcare.
    
2. Various career pathways to achieve higher paying roles:
    Potential of specialised skills - skills like SAS, Python, and Tableau command higher average salaries, indicating potential pathways to higher-paying roles as expertise and experience grow.
    Understanding the salary range for each skill allows me to strategically plan towards roles that offer competitive salaries as I grow in various associated skills.
    
3. Strategic Skill Development:
    Following on from this - balancing common and specialised skills will be key. 
    While focusing on commonly required skills like SQL and Excel for broader job prospects, investing in specialised skills (e.g., Python for data analysis, Tableau for visualisation) can lead to roles with higher earning potential.
    Continuous learning - As with my previous career in pharmacy and in healthcare, recognising the evolving nature of technology and ongoing learning in emerging tools can enhance competitiveness in the job market and improve my value as an employee.




/* code if CTE is used to analyse most optimal skills however this is not needed as the code above is more concise
however this was good practice in using CTEs
*/

With skills_demand AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
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
        skills_dim.skill_id
), average_salary AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
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
        skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN 
    average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25
