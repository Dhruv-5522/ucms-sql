# 🎓 University Course Management System (UCMS)

An end-to-end relational database implementation engineered to model, manage, and analyze academic course operations. Built with a focus on structural integrity, query optimization, and dynamic data reporting.

---

## 📌 Executive Summary

The **University Course Management System** synthesizes fundamental and advanced SQL concepts into a cohesive relational architecture. It handles core academic workflows—from faculty placement and student enrollments to real-time analytics like windowed totals and dynamic seniority classification.

* **Database Name**: `UniversityDB`
* **Architecture**: Relational Database Management System (RDBMS)
* **Primary Features**: Cascading Foreign Keys, Group Aggregations, Complex Joins, Subqueries, Window Functions

---

## 📂 Database Schema Design

The system relies on 5 interlinked tables designed to minimize redundancy and uphold 3NF principles:

* **`Departments`**: Primary organizational units.
  * Fields: `DepartmentID` (PK), `DepartmentName`
* **`Instructors`**: Academic personnel mapping to departments.
  * Fields: `InstructorID` (PK), `FirstName`, `LastName`, `Email`, `Salary`, `DepartmentID` (FK)
* **`Courses`**: Catalog of active academic modules.
  * Fields: `CourseID` (PK), `CourseName`, `Credits`, `DepartmentID` (FK)
* **`Students`**: Central repository for enrolled learners.
  * Fields: `StudentID` (PK), `FirstName`, `LastName`, `Email`, `BirthDate`, `EnrollmentDate`
* **`Enrollments`**: Transactional mapping between students and course offerings.
  * Fields: `EnrollmentID` (PK), `StudentID` (FK), `CourseID` (FK), `EnrollmentDate`

---

## 💡 Query Implementations & Technical Index

Below is the complete functional index of all 16 project operations implemented in `db.sql`.

> **01. Lifecycle CRUD Operations**
> Implementation of full data management (`CREATE`, `READ`, `UPDATE`, `DELETE`) with cascade integrity across connected tables.

> **02. Temporal Filtering**
> Date evaluation filtering students admitted after the year 2022 (`EnrollmentDate > '2022-12-31'`).

> **03. Departmental Course Selection (Limited)**
> Filtered query extracting courses specific to Mathematics, constrained using `LIMIT 5`.

> **04. Aggregated Course Demand**
> Grouped query identifying popular courses using `GROUP BY` and `HAVING COUNT(StudentID) > 5`.

> **05. Strict Dual-Course Enrollment (AND Logic)**
> Double `INNER JOIN` logic filtering students simultaneously enrolled in both *Introduction to SQL* and *Data Structures*.

> **06. Inclusive Multi-Course Enrollment (OR Logic)**
> Distinct set query fetching students enrolled in either target course using `IN(...)` matching.

> **07. Credit Metrics**
> Aggregate measurement calculating the overall mean credits using `AVG(Credits)`.

> **08. Departmental Compensation Cap**
> Target join query extracting the peak faculty salary (`MAX(Salary)`) within Computer Science.

> **09. Academic Footprint Analytics**
> Grouped aggregation calculating total unique student headcounts per department.

> **10. Strict Relational Mapping (INNER JOIN)**
> Multi-table join isolating active records with existing student-course connections.

> **11. Comprehensive Registry Audit (LEFT JOIN)**
> Outer join retrieving all student records regardless of current course enrollment status.

> **12. High-Capacity Subquery**
> Nested filtering query isolating students enrolled in classes exceeding 10 total members.

> **13. Temporal Extraction**
> Scalar function application isolating admission years using `YEAR(EnrollmentDate)`.

> **14. Name Concatenation**
> String manipulation formatting faculty display names via `CONCAT(FirstName, ' ', LastName)`.

> **15. Cumulative Analytics (Window Functions)**
> Advanced analytical reporting computing running enrollment totals using `COUNT() OVER(ORDER BY ...)`.

> **16. Dynamic Seniority Categorization**
> Conditional logic utilizing `CASE WHEN` to dynamically assign `'Senior'` status (>4 years tenure) versus `'Junior'`.

---

## ⚙️ Execution Instructions

1. Launch **VS Code** with your active SQL client extension or open **MySQL Workbench**.
2. Open the primary script file: `db.sql`.
3. Execute the full script. The setup sequence will automatically:
   * Initialize `UniversityDB`.
   * Construct all 5 relational tables with explicit foreign key constraints.
   * Populate sample records.
   * Run all 16 analytical queries sequentially.

---

**Developed with precision for evaluation.**
