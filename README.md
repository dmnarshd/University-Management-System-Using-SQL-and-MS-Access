# University Database System
## Overview
A relational database system designed to manage university operations including departments, courses, modules, academic staff, students, and enrollments. The database was designed, normalized to 3NF, and implemented in both Oracle SQL and Microsoft Access, with a front-end prototype application for data entry and navigation.

## Tools Used
- **Oracle SQL** (backend database implementation)
- **Microsoft Access** (front-end prototype with forms)
- **UML / Lucidchart** (ER diagram)

## Features
- 8 normalized relational tables (3NF)
- Primary keys, foreign keys, and alternate keys
- CHECK constraints for data validation (sex, percentages, hours)
- Indexes on foreign keys for query performance
- 4 SQL views for common reporting needs
- 4 aggregated columns for pre-calculated data
- 10+ SQL queries covering joins, subqueries, and aggregation
- Microsoft Access forms for data entry and navigation

## Database Structure

### Tables
| Table | Purpose |
|-------|---------|
| Department | Academic departments and their managers |
| AcademicStaff | Staff details including salary, post, and qualifications |
| Course | Course information and coordinators |
| Module | Module details, dates, and assessment percentages |
| Student | Student personal and enrollment information |
| NextOfKin | Emergency contact records |
| Enrollment | Student-module registration and performance |
| TeachingSchedule | Staff teaching hours per module |

### Views
- `DepartmentSummary` — department details with manager names
- `StudentPerformance` — modules taken and passed per student
- `StaffTeachingLoad` — teaching hours per staff member
- `ModuleEnrollmentStats` — enrollment and pass rates per module

### Aggregated Columns
- `totalModulesPassed` (Student)
- `studentEnrollmentCount` (Module)
- `totalTeachingHours` (AcademicStaff)
- `totalEnrolledStudents` (Course)

## Key Challenges Solved

### 1. Circular Dependency
The `Department` table requires a `staffNo` foreign key (manager), while `AcademicStaff` requires a `departmentName` foreign key. This creates a chicken-and-egg problem during insertion.

**Solution:** Insert `Department` records first with `NULL` manager values, then insert `AcademicStaff`, then update `Department` with the correct `staffNo`.

### 2. Oracle Platform Limitations
- Oracle does not support `ON UPDATE CASCADE` on foreign keys
- Oracle does not natively support `BOOLEAN` data type

**Solution:** Adapted the design to work within Oracle's constraints while keeping the theoretical schema correct. Used `CHAR(1)` with CHECK constraints or `NUMBER` for boolean values.

## What I Learned
- Full database development lifecycle (design → implementation → querying)
- ER modeling and normalization (1NF → 3NF)
- Writing complex SQL queries with JOINs, subqueries, and aggregation
- Resolving referential integrity issues during data insertion
- Handling real-world platform limitations (Oracle vs Access)
- Building front-end forms in Microsoft Access

## Files
- `University Management System Report.pdf` — Full project report with ER diagram, schema, queries, and critical evaluation
- `uni_database.accdb` — Microsoft Access database with forms

## Contributors
- Dana Alzahid
- Rafal Alqahtani
- Daman Arshad

## Course
MISY 3331 — Advanced Database Systems
Prince Mohammad Bin Fahd University
Instructor: Dr. Shubashini Rathina Velu
