✈️ Air Cargo Database Analysis (SQL Project)

📘 Project Overview  
This project showcases the end-to-end design and analysis of an airline database system using PostgreSQL.  
It models real-world air cargo operations, covering customers, aircraft, routes, travel classes, ticket details, and passenger journeys.  
The project applies SQL techniques to manage, analyze, and optimize airline data efficiently.

🎯 Objectives  
- Design a normalized relational database for airline operations.  
- Define relationships among Customers, Routes, Aircraft, and Tickets.  
- Write and execute SQL queries for insights and business decisions.  
- Create stored procedures and functions for automation.  
- Implement indexing and performance optimization.

🧩 Database Schema  
The database consists of six main entities:  
- **Customer** – Passenger details and demographics.  
- **Aircraft** – Aircraft types, capacity, and manufacturer information.  
- **Routes** – Flight origin, destination, and travel distance.  
- **Class** – Travel classes such as Economy, Business, and Economy Plus.  
- **Ticket_Details** – Ticket booking and pricing information.  
- **Passengers_On_Flights** – Links passengers to flights and travel details.


🗂️ Repository Structure  
Air-Cargo-Database-Analysis/
│
├── datasets/ # CSV datasets used for the project
│
├── sql_scripts/ # SQL scripts for creation, analysis, and optimization
│ ├── Air_Cargo_Analysis_Full_Project.sql
│
├── documentation/ # Problem statement, theory, and visuals
│ ├── Air_Cargo_Problem_Statement.pdf
│ ├── Air_Cargo_SQL_Queries_and_Outputs.pdf
│ ├── Assignment_Theory.pdf
│
└── README.md # Project summary and usage guide


⚙️ Tools & Technologies  
- **Database:** PostgreSQL  
- **Language:** SQL / PL/pgSQL  
- **Visualization:** dbdiagram.io, Draw.io  
- **Dataset Format:** CSV  
- **Version Control:** Git & GitHub  

🔍 Key Analyses  
- Customer and ticket relationships through joins.  
- Aggregation of total revenue and ticket sales.  
- Route classification: Short, Intermediate, and Long Distance.  
- Complimentary service eligibility for premium classes.  
- Stored procedures for automating long-distance route checks and customer lookups.  
- Indexing and query optimization for faster execution.

📊 Results & Insights  
- Database fully normalized and validated.  
- Stored procedures and functions automated repetitive tasks.  
- Economy Plus and Business classes contributed most to premium service use.  
- Indexing improved query response times.  
- Delivered a scalable airline data management model.

