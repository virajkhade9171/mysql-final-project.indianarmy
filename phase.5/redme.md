# 🇮🇳 Indian Army Database Management System (Final SQL Project)

## 📘 Project Overview
This project is a **comprehensive SQL-based database management system** that models the structure and operations of the **Indian Army**.  
It includes the creation of multiple interrelated tables, complex SQL operations, and advanced features like **joins, subqueries, views, stored procedures, triggers, and transactions**.  

The goal of this project is to demonstrate mastery of **SQL concepts** by implementing a realistic, large-scale database with relationships, integrity constraints, and operational logic.

---

## 🗂️ Database Information
- **Database Name:** `indianarmy`  
- **File Name:** `phase.1.sql`  
- **Language Used:** MySQL  
- **Tables Created:** 25+  
- **Lines of Code:** ~3500  
- **Developer:** Viraj Dinesh Khade  
- **Phase:** Final (Completed Project)

---

## ⚙️ Key Features

### 🧱 Database Design
- Realistic tables for **officers, soldiers, battalions, missions, weapons, payroll, and records**.
- Relationships modeled using **primary keys, foreign keys**, and **constraints**.
- Includes **CHECK**, **DEFAULT**, **UNIQUE**, **CASCADE**, and **ON UPDATE** operations.

### 💾 CRUD Operations
- Full coverage of **CREATE, READ, UPDATE, DELETE** commands.  
- Insertion of realistic military data for officers, soldiers, and weapons.

### 🧩 Joins & Relationships
- **INNER JOIN**, **LEFT JOIN**, **RIGHT JOIN**, **CROSS JOIN**, and **SELF JOIN** examples.  
- Demonstrates linking of battalions, soldiers, missions, and weapon data.

### 🧠 Subqueries & Clauses
- Single-row, multi-row, correlated, and nested subqueries.  
- Practical use of **WHERE**, **LIKE**, **IN**, **ANY**, **ALL**, and **EXISTS** conditions.

### 📊 Views & CTEs
- Multiple **views** to simplify complex queries (e.g., `HighRankingOfficers`, `BattalionArmaments`).  
- **CTEs (Common Table Expressions)** and **Recursive CTEs** for hierarchy and reporting.

### 🔄 Stored Procedures
- CRUD-based procedures for soldiers, officers, and missions:
  - `AddNewSoldier()`
  - `GetOfficerDetails()`
  - `UpdateSoldierLocation()`
  - `DeleteMission()`

### 🔐 Triggers & Transactions
- Audit log implemented using **AFTER INSERT**, **BEFORE UPDATE**, and **AFTER DELETE** triggers.
- Safe data modification through **COMMIT**, **ROLLBACK**, and **SAVEPOINT** transactions.
- Demonstrates database auditing and rollback control.

---

## 🧮 Topics Covered

| Category | Concepts Implemented |
|-----------|----------------------|
| **DDL** | CREATE, ALTER, DROP, CONSTRAINTS |
| **DML** | INSERT, UPDATE, DELETE, SELECT |
| **DCL** | GRANT, REVOKE (optional future scope) |
| **TCL** | COMMIT, ROLLBACK, SAVEPOINT |
| **JOINS** | INNER, LEFT, RIGHT, CROSS, SELF |
| **CLAUSES** | WHERE, LIKE, IN, BETWEEN, ANY, ALL, EXISTS |
| **AGGREGATE FUNCTIONS** | SUM, AVG, COUNT, MIN, MAX |
| **SCALAR FUNCTIONS** | UPPER, LOWER, LENGTH, CONCAT, NOW |
| **ADVANCED SQL** | Subqueries, Views, CTEs, Window Functions |
| **STORED PROGRAMS** | Procedures & Triggers |
| **DATA INTEGRITY** | CHECK, DEFAULT, CASCADE, UNIQUE |

---

## 🧾 Sample Table Creation

```sql
CREATE TABLE officers (
    officerid INT PRIMARY KEY,
    name VARCHAR(100),
    rank VARCHAR(50),
    age INT,
    gender CHAR(1),
    commissiondate DATE,
    postinglocation VARCHAR(100),
    branch VARCHAR(50),
    contactnumber VARCHAR(15),
    email VARCHAR(100),
    specialization VARCHAR(100)
);

