IDA Data Analysis and Dashboard Project

This project analyses International Development Association (IDA) credit, grant, and guarantee data for Nigeria, with a focus on creating an interactive Tableau dashboard and optimised SQL queries. It highlights key insights into the funding structure, repayment status, and project allocations, providing stakeholders with a powerful tool for decision-making and exploration.
________________________________________

Project Objectives
1.	Analyse and visualise IDA's monthly credit data for Nigeria.
2.	Optimise SQL queries for efficient data retrieval and aggregation.
3.	Develop an interactive Tableau dashboard to explore Nigeria's IDA data with filters, controls, and visual summaries.
________________________________________

Key Features
Data Analysis
•	Database: MySQL
o	  Efficient query design using indexing strategies.
o	  Monthly updates tracked using end_of_period data.
o	  Calculations include total principal amounts, disbursements, repayments, and borrower obligations.

Data Visualisation
•	Tool: Tableau
o	An interactive dashboard showcasing:
	Total disbursed, repaid, and undisbursed amounts for Nigeria.
	Credit status distribution.
	Project-wise funding breakdown.
	Monthly trend analysis for disbursements and repayments.
o	Dynamic filters for credit_status, country, end_of_period, and more.
________________________________________


How to Use

1. Data Setup
•	Download and load the IDA dataset into a MySQL database.
•	Run the provided SQL scripts to create indexes and optimise queries.
2. Interactive Analysis

https://public.tableau.com/views/NigeriaCreditsIDA/IDACreditsNGR?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
4. Queries
   
•	Run the optimised SQL queries to extract specific insights into Nigeria's credit data.

________________________________________
Technical Requirements

•	Database: MySQL 8.0+

•	Visualisation Tool: Tableau Desktop 2021.4+

•	Programming Language: SQL

•	Data Source: IDA historical data for monthly credits and grants.

________________________________________
Project Workflow

1.	Data cleaning and preparation in MySQL.
2.	Writing and optimising SQL queries.
3.	Creating calculated fields and relationships in Tableau.
4.	Building an interactive and user-friendly dashboard.
________________________________________

Challenges and Solutions

•	Data Volume: Indexing strategies were applied to improve query performance for large datasets.

•	Dynamic Visuals: Leveraged Tableau's calculated fields and parameter controls for interactivity.

•	Data Redundancy: Handled repetitive monthly data updates efficiently using DISTINCT and MAX queries.
________________________________________

Future Improvements

1.	Include more countries for broader comparative analysis.
2.	Automate monthly data ingestion using ETL pipelines.
3.	Expand dashboard features, such as predictive analytics for repayment trends.
   
________________________________________

Repository Contents

•	SQL/: Contains SQL scripts for creating indexes and running queries.

•	Tableau/: Includes Tableau workbook (.twbx) and exported images.

•	README.md: Project overview and setup instructions.
________________________________________

Author
Noah Ajekwemu - www.linkedin.com/in/noahajekwemu

•	Aspiring data analyst with expertise in MySQL, Tableau, and data storytelling.
•	Connect on LinkedIn www.linkedin.com/in/noahajekwemu

Acknowledgements

•	International Development Association (IDA) for providing the dataset.

•	Tableau and MySQL communities for their invaluable resources.

•	Martin Diaz-Valdes - https://www.linkedin.com/in/martdv/

•	Vidhi SaxenaVidhi Saxena - https://www.linkedin.com/in/vidhi-saxena-0b8379227/ 
