🍕 Pizza Sales Data Analysis using SQL Server

This project presents a complete analysis of a pizza sales dataset sourced from Kaggle. The raw CSV files were first imported into SQL Server using the Flat File Import Wizard, and then structured as relational tables. SQL queries were written to perform detailed data analysis on the imported data.

📂 Data Used

•	orders.csv
•	order_details.csv
•	pizzas.csv
•	pizza_types.csv
These files represent different entities such as customer orders, order details, pizza information, and pizza categories. They were imported into SQL Server to enable structured querying and relational joins.

🛠️ How the Data Was Prepared

•	Step 1: Downloaded raw data from Kaggle – Pizza Place Sales Dataset.
•	Step 2: Used SQL Server’s Import Flat File Wizard to load each CSV file into separate tables.
•	Step 3: Verified data types and relationships (e.g., foreign keys between orders and order_details).
•	Step 4: Performed SQL queries for analysis (queries provided in the .sql file).

🔍 Analysis Highlights

The following questions were answered using SQL:
1) Retrieve the total number of orders placed.
2) Calculate the total revenue generated from pizza sales.
3) Identify the highest-priced pizza.
4) Identify the most common pizza size ordered.
5) List the top 5 most ordered pizza types along with their quantities.
6) Join the necessary tables to find the total quantity of each pizza category ordered.
7) Determine the distribution of order quantity by hour of the day.
8) Determine the distribution of orders by hour of the day.
9) Join relevant tables to find the category-wise distribution of pizzas.
10) Group the orders by date and calculate the average number of pizzas ordered per day.
11) Determine the top 3 most ordered pizza types based on revenue.
12) Calculate the percentage contribution of each pizza type to total revenue.
13) Analyze the cumulative revenue generated over time.
14) Determine the top 3 most ordered pizza types based on revenue for each pizza category.

📁 Files in this Repository

•	PROJECT FILE PIZZA SALES.sql — Contains all SQL queries used for the analysis.
•	Analysis from SQL.docx — Includes both the questions and SQL output results.
•	Raw CSV files used to create the SQL tables.

🎯 Objective

The main goal of this project is to practice real-world data analysis using SQL and to gain insights into sales performance, product popularity, and ordering trends that can inform business strategy.

