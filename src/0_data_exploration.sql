/* comparison of job title vs job title short shows that there is a difference in the number of data analysts amongst other postitions,
important to decide which of these to use when filtering in the where clause for future queries */

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    job_title_short
ORDER BY 
    avg_salary DESC
    
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title_short LIKE '%Analyst%' AND 
    job_title_short NOT LIKE '%Senior%' AND
    job_title_short NOT LIKE '%Sr%'
GROUP BY
    job_title_short
ORDER BY 
    avg_salary DESC



/* to do this i adjusted the where clauses to show me only the results that were different between the two searches above*/

SELECT
    job_title_short,
    job_title
FROM
    job_postings_fact
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title_short LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Analyst%' AND
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    job_title_short, job_title


/* This search showed me the different titles and title short for the 17 results different between the two original searches, in this we can see that
many job title descriptions have been incorrectly summarised to data analyst roles for example
as a result I decided it was more reliable to use the job title in the where clause over the job title short however job title short in the select statement for conciseness  */

/* the average salary of the 17 jobs excluded here are 100k+ and so that could massively influence the average salaries
used in later queries */

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title_short LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Analyst%' AND
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    job_title_short
ORDER BY 
    avg_salary DESC



/* I then decieded to visualise a box plot using powerBI to look at the distribution of these job salaries to see whether there were any outliers 
as this may affect the average salary used for analysis in later queries */

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    MIN(salary_year_avg) AS min_salary,
    MAX(salary_year_avg) AS max_salary,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY salary_year_avg) AS median,
    percentile_cont(0.25) WITHIN GROUP (ORDER BY salary_year_avg) AS q25,
    percentile_cont(0.75) WITHIN GROUP (ORDER BY salary_year_avg) AS q75
FROM
    job_postings_fact
WHERE
    (job_location LIKE '%UK%' OR job_location LIKE '%United Kingdom%') AND
    salary_year_avg IS NOT NULL AND
    job_title LIKE '%Analyst%' AND 
    job_title NOT LIKE '%Senior%' AND
    job_title NOT LIKE '%Sr%'
GROUP BY
    job_title_short
ORDER BY 
    avg_salary DESC


/* It is worth noting that the data set would require more data on jobs in the UK under these job titles to be able to assess the level of significance  */