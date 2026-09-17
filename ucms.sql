-- ============================================================================
--               Project: University Course Management System
-- Description: Complete Database Schema, Sample Data, and All Required SQL Operations
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SECTION 1: DATABASE & TABLE CREATION (SCHEMA DESIGN)
-- ----------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

-- Drop existing tables to ensure clean execution (Order matters due to FK constraints)
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;

-- 1. Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL
);

-- 2. Instructors Table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2) DEFAULT 50000.00,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL
);

-- 3. Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Credits INT CHECK (Credits > 0),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL
);

-- 4. Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    BirthDate DATE,
    EnrollmentDate DATE NOT NULL
);

-- 5. Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- SECTION 2: SAMPLE DATA INSERTION (POPULATING DATABASE)
-- ----------------------------------------------------------------------------

-- Insert Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES 
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics');

-- Insert Instructors
INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID, Salary) VALUES 
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 85000.00),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 72000.00),
(3, 'Charlie', 'Brown', 'charlie.brown@univ.com', 1, 95000.00);

-- Insert Courses
INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES 
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 1, 4),
(103, 'Calculus I', 2, 4),
(104, 'Linear Algebra', 2, 3),
(105, 'Quantum Mechanics', 3, 4);

-- Insert Students
INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES 
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2020-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01'),
(3, 'Alex', 'Taylor', 'alex.taylor@email.com', '2001-03-12', '2023-01-10'),
(4, 'Emily', 'Davis', 'emily.davis@email.com', '2002-07-22', '2023-08-15'),
(5, 'Michael', 'Wilson', 'michael.wilson@email.com', '1998-11-30', '2019-08-01');

-- Insert Enrollments (Including mock data for testing subqueries & HAVING filters)
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES 
(1, 101, '2022-08-01'),
(1, 102, '2022-08-01'),
(2, 102, '2021-08-01'),
(3, 101, '2023-01-10'),
(3, 102, '2023-01-10'),
(4, 101, '2023-08-15'),
(5, 103, '2019-08-01');


-- ----------------------------------------------------------------------------
-- SECTION 3: REQUIRED PROJECT QUERIES (TASKS 1 - 16)
-- ----------------------------------------------------------------------------

-- Query 1: Perform CRUD Operations on all tables
-- C - Create/Insert (Demonstrated in Section 2)
-- R - Read
SELECT * FROM Students;

-- U - Update
UPDATE Students 
SET Email = 'john.doe_updated@email.com' 
WHERE StudentID = 1;

-- D - Delete
DELETE FROM Enrollments WHERE EnrollmentID = 7;


-- Query 2: Retrieve students who enrolled after 2022
SELECT StudentID, FirstName, LastName, EnrollmentDate
FROM Students
WHERE EnrollmentDate > '2022-12-31';


-- Query 3: Retrieve courses offered by the Mathematics department with a limit of 5 courses
SELECT c.CourseID, c.CourseName, c.Credits, d.DepartmentName
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;


-- Query 4: Get the number of students enrolled in each course, filtering for courses with more than 5 students
-- (Note: Set threshold to > 1 for sample testing if needed, keeping 5 as per assignment specification)
SELECT c.CourseName, COUNT(e.StudentID) AS EnrolledStudentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(e.StudentID) > 5;


-- Query 5: Find students who are enrolled in BOTH 'Introduction to SQL' AND 'Data Structures'
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e1 ON s.StudentID = e1.StudentID
JOIN Courses c1 ON e1.CourseID = c1.CourseID AND c1.CourseName = 'Introduction to SQL'
JOIN Enrollments e2 ON s.StudentID = e2.StudentID
JOIN Courses c2 ON e2.CourseID = c2.CourseID AND c2.CourseName = 'Data Structures';


-- Query 6: Find students who are enrolled in EITHER 'Introduction to SQL' OR 'Data Structures'
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName, s.Email
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');


-- Query 7: Calculate the average number of credits for all courses
SELECT AVG(Credits) AS AverageCourseCredits
FROM Courses;


-- Query 8: Find the maximum salary of instructors in the Computer Science department
SELECT MAX(i.Salary) AS MaxCSSalary
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';


-- Query 9: Count the number of students enrolled in each department
SELECT d.DepartmentName, COUNT(DISTINCT e.StudentID) AS TotalStudentsEnrolled
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentID, d.DepartmentName;


-- Query 10: INNER JOIN: Retrieve students and their corresponding courses
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName, e.EnrollmentDate
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;


-- Query 11: LEFT JOIN: Retrieve all students and their corresponding courses, if any
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;


-- Query 12: Subquery: Find students enrolled in courses that have more than 10 students
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);


-- Query 13: Extract the year from the EnrollmentDate of students
SELECT StudentID, FirstName, LastName, EnrollmentDate,
       YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;


-- Query 14: Concatenate the instructor's first and last name
SELECT InstructorID, 
       CONCAT(FirstName, ' ', LastName) AS FullName, 
       Email
FROM Instructors;


-- Query 15: Calculate the running total of students enrolled in courses
SELECT EnrollmentID, CourseID, EnrollmentDate,
       COUNT(StudentID) OVER(ORDER BY EnrollmentDate, EnrollmentID) AS RunningTotalStudents
FROM Enrollments;


-- Query 16: Label students as 'Senior' or 'Junior' based on their year of enrollment
-- (Senior if enrollment date is more than 4 years from current date, otherwise Junior)
SELECT StudentID, FirstName, LastName, EnrollmentDate,
       CASE 
           WHEN EnrollmentDate <= DATE_SUB(CURDATE(), INTERVAL 4 YEAR) THEN 'Senior'
           ELSE 'Junior'
       END AS StudentStatus
FROM Students;