# 🇮🇳 Indian Army Database Management System (SQL Project)

## 📘 Project Overview
The **Indian Army Database Management System** is a comprehensive SQL-based project designed to manage and analyze data related to army operations, personnel, missions, logistics, and resources.  
This project simulates a real-world defense database structure with detailed tables, sample records, and SQL operations to ensure efficient data handling and relational integrity.

---

## 🗂️ Database Name
**`indianarmy`**

---

## ⚙️ Features & Objectives

- Manage detailed information about **officers, soldiers, battalions, and missions**.
- Handle **training centers, weapons, vehicles, medical, and payroll** data efficiently.
- Ensure data consistency with **primary keys and structured relationships**.
- Include **DML (SELECT, INSERT, UPDATE, DELETE)** and **DDL (CREATE, ALTER, DROP, TRUNCATE)** operations.
- Simulate **real-time defense logistics and personnel management**.

---

## 🧩 Major Modules (Tables)

| No. | Table Name | Description |
|-----|-------------|--------------|
| 1 | `officers` | Stores data about officers’ personal and professional details |
| 2 | `soldiers` | Contains information about enlisted soldiers |
| 3 | `battalions` | Details of battalion units, their commanders, and resources |
| 4 | `training_centers` | Information on army training centers and their operations |
| 5 | `weapons` | Manages inventory of weapons, types, and deployment |
| 6 | `missions` | Tracks operations and missions conducted by the army |
| 7 | `vehicles` | Vehicle and transport information across army units |
| 8 | `medical_records` | Health records and medical checkup details for soldiers |
| 9 | `leave_records` | Manages leave applications, types, and approval details |
| 10 | `promotions` | Tracks soldiers’ career progression and promotions |
| 11 | `events` | Contains details about ceremonial and training events |
| 12 | `disciplinary_actions` | Logs disciplinary actions and their outcomes |
| 13 | `accommodations` | Manages accommodation details for personnel |
| 14 | `payroll` | Salary and payment structure for soldiers |
| 15 | `arms_inventory` | Tracks arms, ammunition, and condition reports |
| 16–25 | *(Additional Tables)* | Cover logistics, training, awards, and communication data |

---

## 💾 SQL Operations Included

- **Database Creation**
  ```sql
  CREATE DATABASE indianarmy;
  USE indianarmy;
