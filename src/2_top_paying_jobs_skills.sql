/* Following on from previous query, I am looking at the skills required to meet the top 50 jobs within the UK that fit my data analyst criteria so i can begin to look
at where my skillset would match and what further skills I require.
To start, this query will provide a detalied insight into the "top paid" skills that employers seek - useful for applicants like myself new to this career.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 50
)

SELECT
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN 
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/* 
1. cleaned up select statement to focus on the job_id, job_title, salary_yearly_avg and company_name.
The other fields were no longer required since I am focussing on in on specifics from my previous query.

2. created CTE to be able to join this to another table - namely the skills associated to these top 50 paying roles

3. Inner join used to connect the skills_job_dim table to the CTE created (connected on job_id)
Then another inner join used to connect the skills_dim table to that. (connected on skill_id)

4. Although data was naturally in order, added an order by to ensure it is ordered by salary.

5. Analysis of the results showed the following:

The analysis of the skill column from the top 50 analyst roles in job postings for 2023 reveals the most frequently mentioned skills and their counts (specific to the top 50 paying roles):

1. SQL: 28 mentions
2. Excel: 22 mentions
3. Python: 18 mentions
4. Tableau: 9 mentions
5. Go: 7 mentions
6. R: 6 mentions
7. Power BI: 5 mentions
8. SAS: 4 mentions
9. BigQuery: 4 mentions
10. VBA: 4 mentions

These insights suggest that SQL, Excel, and Python are the most sought-after skills for the analyst roles I am looking at within the UK. 
Visualisation tools like Tableau and Power BI, as well as programming languages like R and Go, are also significant but less prevalent.
In terms of initial thoughts, I would need to ensure that I am able to use the top 3 skills and at least 1 visulisation tool to be able to apply for these roles.

*/