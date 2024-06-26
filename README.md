# Introduction
Welcome to my project, where I explore the exciting world of data jobs! 🚀 I focus on analyst roles, including data analysts, insight analysts, and business analysts 💡. In this project, I explore the UK job market in 2023, making interesting comparisons to remote roles 📊. I dive deep into the top-paying jobs, uncover the most in-demand skills, and provide a comprehensive understanding of the optimal skills required for job seekers. 💼

🔍 Interested in the SQL queries?: Check them out [here](/src/)

# Background
As an experienced senior pharmacist transitioning into the world of data, I found it challenging to understand and navigate the job market. Despite having a decade of experience in the healthcare domain, I needed to gain a clearer understanding of the skills required for data roles. This would help me identify which skills to develop and the reasons behind their importance.

For this reason, I used this dataset for my first GitHub project using data that orignates from a comprehensive SQL course featured online by Luke Barousse. 

## Project overview:
This project allowed me to apply my SQL skills and showcase my ability to not only use SQL but also to derive valuable insights from data. By focusing on my personal job search, I aimed to understand the UK job market and the required skillsets. This project demonstrates my capability to perform advanced queries and apply the insights to my real-life job-seeking efforts.

## Objectives:
Before embarking on this project, I set the following objectives:

1. **Analyse** the top-paying data roles in the UK job market
2. **Define** the essential skills required for these high-paying roles
3. **Evaluate** the most in-demand skills for the roles I am applying for
4. **Identify** the skills correlated with higher salaries
5. **Determine** the most optimal skills to learn and justify their importance


# Tools I used
For my exploration of the data job market, I employed a variety of powerful tools to efficiently manage, analyse, and present the dataset. Each tool played a crucial role in different stages of the project, from database management to version control and collaboration. Below is a detailed overview of the tools I used:

- **SQL**: SQL was fundamental in querying and analysing the dataset. It allowed me to extract meaningful insights by performing complex queries, aggregations, and data transformations. With SQL, I was able to filter, sort, and join tables to generate comprehensive reports and visualisations that highlighted key trends and patterns in the data job market.

- **PostgreSQL**: I utilised PostgreSQL as my database management system. PostgreSQL is a robust, open-source relational database known for its advanced features and reliability. It provided a secure and efficient environment for storing, managing, and querying large volumes of data. The use of PostgreSQL ensured that my data was organised and easily accessible for analysis.

- **Visual Studio Code**: VS Code was my primary code editor for writing and executing SQL queries. This versatile and user-friendly IDE (Integrated Development Environment) offered an excellent workspace for project management. With its extensive range of extensions and features, VS Code streamlined the development process, enabling me to write clean and efficient code and debug errors.

- **Git and GitHub**: For version control and collaboration, I relied on Git and GitHub. Git, a distributed version control system, allowed me to track changes, manage different versions of my project, and opens the ability to collaborate with others seamlessly. GitHub, a web-based platform, provided a space to host and share my project publicly. By pushing my code to GitHub, I was able to create this public portfolio showcasing my analysis and findings. This not only enhanced transparency but also facilitated potential collaboration and feedback from the data science community.

Each of these tools contributed significantly to the success of my project, enabling me to efficiently handle the data, perform in-depth analysis, and share my findings with a broader audience. The combination of these technologies ensured a smooth workflow and helped me achieve my project goals effectively.

# The Analysis
Each objective for this project was designed to investigate specific aspects of the job market data.
In this section I will outline how I approached each objecttive. 

## 1. **Analyse** the top-paying data roles in the UK job market

Being new to this career, I wanted to identify the top paying data roles within the UK job market from the 2023 dataset. This provides recent and reliable data that I can use to draw conclusions for my own applications in 2024.

### To identify these top paying jobs I followed this process: 

1. Reviewed the dataset to look for roles within the UK, noted that dataset had results for UK and United Kingdom
ensured both were included in the where clause to capture all the jobs in the dataset within my intended area

2. Next I removed any results that had NULL values for salaries

3. Filtered for role that include the word 'Analyst' and removed those that included the word 'Senior' or 'Sr'
This is to make it more personal to my needs to reflect the type of roles I will look to apply for myself

4. Joined the company_dim table to note the companies that lsited these job postings

5. Cast job_posted_date to DATE to remove time stamp so data result can look cleaner

6. Limited results to the top 50 jobs out of these 2023 postings

```sql
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
```
### Key insights:

1. **Variability in salaries**:

The highest-paying job had an average annual salary of £180,000. This is significantly higher than the other roles listed, indicating a possible specialisation or seniority that commands a premium. The difference between this highest salary and the lowest within the top 50 jobs was around £130'000 suggesting that even within the top jobs, there can be quite a distinction between compensation for the skills provided.

2. **Salary Concentration and Distribution**:

Many of the top-paying jobs are clustered around the average of the £100,500 mark within these top jobs. Roles such as "Data Analyst" in various companies and locations (e.g., London, Sheffield, Glasgow) often offer this salary, suggesting a potential standard market rate for experienced data analysts across different industries and locations.

3. **Geographical and Industry Spread**:

High-paying data jobs are distributed across various locations in the UK, including London, Newcastle, Stockport, and Edinburgh. While London hosts the majority of these roles, significant opportunities exist outside the capital, indicating a robust demand for data professionals nationwide. It is worth noting the wide range of job titles that accomponied the job postings for similar salary roles. Companies from diverse sectors, such as financial services (e.g., Version 1, Ocorian), insurance (e.g., esure Group), and media (e.g., The Telegraph), are offering competitive salaries, showing the need for data expertise across all industries.

## 2. **Define** the essential skills required for these high-paying roles

Following on from previous query, I began looking at the top paying skills required to meet the top  jobs within the UK that fit my data analyst criteria so i can begin to look at where my skillset would match and what further skills I require.

### To do this I went through the following steps

1. Cleaned up the SELECT statement to focus on the job_id, job_title, salary_yearly_avg and company_name.
The other fields were no longer required since I am focusing in on specifics from my previous query

2. Created a CTE to be able to join this to another table - namely the skills associated to these top 50 paying roles

3. Inner join used to connect the skills_job_dim table to the CTE created (connected on job_id)
Then another inner join used to connect the skills_dim table to that (connected on skill_id)

4. Although data was naturally in order, added an order_by to ensure it is ordered by salary

5. Analysis of the results showed the following:

```sql
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
```

The analysis of the skill column from the top 50 analyst roles in job postings for 2023 reveals the most frequently mentioned skills and their counts (specific to the top 50 paying roles):

1. **SQL**: 28 mentions
2. **Excel**: 22 mentions
3. **Python**: 18 mentions
4. **Tableau**: 9 mentions
5. **Go**: 7 mentions
6. **R**: 6 mentions
7. **Power BI**: 5 mentions
8. **SAS**: 4 mentions
9. **BigQuery**: 4 mentions
10. **VBA**: 4 mentions

I used Excel to creat a visualisation chart below for easier analysis of the most frequently mentioned skills. 

![Most listed skills within the top 50 jobs](assests\skill_count_for_top_paying_jobs.png)


### Key insights:
1. SQL, Excel, and Python are the most sought-after skills for the analyst roles I am looking at within the UK

2. Visualisation tools like Tableau and Power BI, as well as programming languages like R and Go, are also significant but less prevalent

3. In terms of initial thoughts, I would need to ensure that I am able to use the top 3 skills and at least 1 visulisation tool to be able to apply for these roles

## 3. **Evaluate** the most in-demand skills for the roles I am applying for

Having looked at the top paid skills, I decided to delve a bit deeper and review the most "in demand" skills.
I was looking to review whether this will correlate with the top paid skills.

To do this I joined the job_postings via an inner query.
I focused on the top 5 most in demand skills for the roles I set out previously.
The focus still remains on all job postings in the UK, however out of interest, I compared the most in demand skills in the UK VS those for remote jobs that could be located elsewhere.
From this I can reflect on the most valuable skills for me to improve on as an active job seeker.

### To do this I went through the following steps:

1. Focused on keeping the same joined tables from previous query but selecting skills and the COUNT to focus only
on those 2 parameters

2. Added different WHERE clauses for each search to look at the results within the UK and for results in remote jobs
Again only for the roles where I could be a suitable candidate

3. GROUPED BY skills since this is the focus of this query and ORDERED BY the demand_count DESC to get the most
in demand skills first

4. LIMITED to the top 5 skills to hone in on what I may need to focus on as I enter this new career

5. Removed the salary_yearly_avg compared to previous queries as the focus here is on the most in demand skills 
required irresepctive of whether the salaries were listed on the job posting or not

```sql
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
```
**UK results of top demanded skills**


| Skills  | Demand Count |
|---------|--------------|
| SQL     | 4198         |
| Excel   | 4041         |
| Power BI| 2737         |
| Python  | 1905         |
| Tableau | 1478         |

**Remote results of top demanded skills**

| Skills  | Demand Count |
|---------|--------------|
| SQL     | 7545         |
| Excel   | 5149         |
| Python  | 4336         |
| Tableau | 3912         |
| Power BI| 2735         |


### Key insights:

1. Interesting that both result sets have the same 5 top in demand skills in the UK and Remotely, with 2 of the top 5 being visulisation tools - highlighting that not only is it important to be able to analyse data, but presenting it well is argueably just as key for employers

2. SQL and Excel remain the best skills to have for both demand and pay for any job seekers looking to enter the field.
However in the UK a visulisation tool, like power BI, may be more in demand than learning further programming languages

## 4. **Identify** the skills correlated with higher salaries

The aim here was to look at the average salary associated with each skills and assess whether they correlate with the top paying jobs or the most in demand skills within the UK.
We can then delve deeper into what is the most financially rewarding skill to learn or improve on.

### To do this, I went through this process:

1. Used previous query but removed the skill COUNT and instead did an average of the salary_year_avg to find the average salaries for each skill

2. This was then rounded to 0 decimal places

3. ORDER BY statement was corrected to order by the avg_salary and then added LIMIT to the top 15 paying skills as an average from all the job listings in the UK

```sql
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
```

To find the average of the salaries in the UK verses remote jobs it was better to add a CASE statement to group any job that had 'UK' or 'United Kingdom' to ensure a fair average was taken of all the jobs posted.

```sql
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
```

**Results of search 1**:

This table lists the skills alongside their corresponding average salaries.

| Skills       | Average Salary |
|--------------|----------------|
| DAX          | 105000         |
| GDPR         | 105000         |
| SharePoint   | 100500         |
| PHP          | 100500         |
| Oracle       | 99592          |
| MATLAB       | 98500          |
| C#           | 98500          |
| SSRS         | 98500          |
| MySQL        | 98500          |
| Java         | 98500          |
| Databricks   | 98500          |
| PySpark      | 98500          |
| Sheets       | 97508          |
| JavaScript   | 92038          |
| Jupyter      | 90675          |



**Results of search 2**:

This table shows the average salary for each grouped location.

| Grouped Location | Average Salary |
|------------------|----------------|
| Anywhere         | 92897          |
| UK               | 77714          |



### Key insights:

1. Interesting for me on a personal note from search 1 that there are programs and database management systems that are new to me on this list such as dax and oracle. However mysql, pyspark and other more common skills are still featured in the top skills associated with the top 15 average salaries.

2. The table also reflects a diverse range of technical skills across different domains, including data analysis (DAX, PySpark), web development (PHP, JavaScript), database management (MySQL, Oracle), and analytics tools (SSRS, MATLAB, Databricks, Jupyter). This diversity indicates a broad spectrum of career paths and specialisations within the tech industry. We can infer that mastery of such complicated platforms and tools reflects in compensation due to the complexity in translating the data involved into actionable insights.

2. Search 2 shows that the average salary in the UK is considerably lower than those with remote jobs. This provides great options for those like myself entering the job market who are happy to relocate within UK or work from any desired remote location. Although there is a large discrepency in the average salary, we can deduce that the gap in real life application can be closed when leveraging skills and domain knowledge as other variables that can affect salary.
 

## 5. **Determine** the most optimal skills to learn and justify their importance

Lastly, similar to the top 5 in demand skills deduced from objective 3, I wanted to look at the disparity in the salary ranges for the jobs listed in the UK to assess what would be the most optimal for me to learn now that I have all this understanding. Considering what jobs and skills pay the hightest, which skills are most in demand, the average salary ranges. The remaining factor to understand was the range of pay associated with skills to understand the difference between entry level roles and more experienced roles. This helps assign order to the importance of the skills in my personal job seeking journey.

### To do this I went through this process:

1. Added the skills_job_dim back into the SELECT statement with MIN and MAX aggregations on the salary_year_avg to look at the range of salaries for each of those skills

2. I also did a COUNT of the number of jobs posted within that

3. I did an ORDER BY for the number_of_jobs to review the most frequently posted jobs associated with said skill in the UK and also ORDER BY the avg_salary DESC

4. I did a GROUP BY of the skills since that is what I am comparing

5. Finally added a LIMIT to look at just the top 10 commonly present skills in these job listings

```sql
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
```

**Results of the search**:

This table summarises the minimum salary, maximum salary, average salary, and number of jobs posted associated with each of the top 10 skills.


| Skills    | Min Salary | Max Salary | Avg Salary | Number of Jobs |
|-----------|------------|------------|------------|----------------|
| SQL       | 30000.0    | 111175.0   | 77230      | 35             |
| Excel     | 30000.0    | 180000.0   | 78326      | 28             |
| Python    | 51014.0    | 111175.0   | 77447      | 20             |
| Tableau   | 30000.0    | 111175.0   | 77035      | 14             |
| SAS       | 51014.0    | 111175.0   | 80551      | 8              |
| Go        | 51014.0    | 105000.0   | 73131      | 8              |
| R         | 51014.0    | 98500.0    | 68971      | 7              |
| Power BI  | 30000.0    | 89100.0    | 68842      | 6              |
| Word      | 30000.0    | 100500.0   | 62003      | 5              |
| Outlook   | 30000.0    | 100500.0   | 58006      | 5              |


### Key insights:

1. **Salary Range and Averages**: 
Each skill has a range of salaries associated with it (from min_salary to max_salary)
indicating the variability in compensation for roles requiring that skill

2. **Demand (Number of Jobs)**: 
The number_of_jobs field indicates the demand for each skill in the job market. 
Skills like SQL and Excel have a higher number of job postings compared to skills like R, Power BI, Word, and Outlook.
We have seen this continues to correlate withprevious queries.

3. **Comparison Across Skills**: 
By comparing avg_salary values, we can get a sense of which skills tend to command higher salaries on average. 
For example, SAS and Excel have higher average salaries compared to R and Power BI.

4. **Specialised Skills**: 
Skills like SAS, R, and Tableau, have fewer job postings but potentially higher average salaries, might indicate a demand for specialised expertise.

# What I learned

Throughout this project, I've strengthened my SQL capabilities significantly:

🧩 **Complex Query Formulation**:  I've shown my mastery in advanced SQL techniques, adeptly merging tables and utilising WITH clauses for sophisticated temporary data manipulations.

📊 **Effective Data Summarisation**: I've refined my skills in summarising data using GROUP BY and harnessing aggregate functions such as COUNT(), AVG(), MIN(), and MAX() to extract valuable insights.

💡 **Analytical Proficiency**: I've enhanced my ability to convert complex questions into actionable insights, highlighting my analytical acumen through SQL query execution.


# Conclusions

As a new jobseeker within this field I can use the insights from this project to understand the following for my own personal career:

1. **Skill popularity and entry-Level opportunities**:
    SQL and Excel are highly sought after across various job postings, suggesting they are fundamental and widely applicable in many data related industries.
    
2. **Entry-Level Pay Variability**:
    Despite SQL and Excel being so common, entry-level salaries vary, indicating opportunities for negotiation and growth based on additional skills and experience - this could be dependant on domain knowledge e.g healthcare.
    
2. **Various career pathways to achieve higher paying roles**:
    Potential of specialised skills like SAS, Python, and Tableau command higher average salaries, indicating potential pathways to higher-paying roles as expertise and experience grow.
    Understanding the salary range for each skill allows me to strategically plan towards roles that offer competitive salaries as I grow in those associated skills.
    
3. **Strategic Skill Development**:
    Following on from this - balancing common and specialised skills will be key. 
    While focusing on commonly required skills like SQL and Excel for broader job prospects, investing in specialised skills (e.g., Python for data analysis, Tableau for visualisation) can lead to roles with higher earning potential.

4. **Continuous learning**:
     As with my previous career in pharmacy and in healthcare, recognising the evolving nature of technology and ongoing learning in emerging tools can enhance competitiveness in the job market and improve my value as an employee.
