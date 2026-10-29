-- =====================================================================
-- ASSIGNMENT 3 : University Database Management System       (SQL Server / T-SQL)
-- =====================================================================

-- ---------------------------------------------------------------------
-- TASK 1
-- ---------------------------------------------------------------------

-- 1  Create the database
USE master;
GO
IF DB_ID('University_DB') IS NOT NULL
BEGIN
    ALTER DATABASE University_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE University_DB;
END
GO
CREATE DATABASE University_DB;
GO
USE University_DB;
GO

-- 2  Four tables, three columns each
--    (NOT NULL on ID, Name and the third column of College and Department)
CREATE TABLE College_Table (
    College_ID   INT          NOT NULL PRIMARY KEY,
    College_Name VARCHAR(100) NOT NULL,
    College_Area VARCHAR(100) NOT NULL
);

CREATE TABLE Department_Table (
    Dept_ID       INT          NOT NULL PRIMARY KEY,
    Dept_Name     VARCHAR(100) NOT NULL,
    Dept_Facility VARCHAR(100) NOT NULL
);

CREATE TABLE Professor_Table (
    Professor_ID      INT PRIMARY KEY,
    Professor_Name    VARCHAR(100),
    Professor_Subject VARCHAR(100)
);

CREATE TABLE Student_Table (
    Student_ID     INT PRIMARY KEY,
    Student_Name   VARCHAR(100),
    Student_Stream VARCHAR(100)
);
GO

-- 3  Foreign key: College_Table -> Department_Table
ALTER TABLE Department_Table ADD College_ID INT NULL;
GO
ALTER TABLE Department_Table
    ADD CONSTRAINT fk_dept_college
        FOREIGN KEY (College_ID) REFERENCES College_Table(College_ID);
GO

-- 4  Foreign key: Professor_Table -> Student_Table
ALTER TABLE Student_Table ADD Professor_ID INT NULL;
GO
ALTER TABLE Student_Table
    ADD CONSTRAINT fk_student_professor
        FOREIGN KEY (Professor_ID) REFERENCES Professor_Table(Professor_ID);
GO

-- Link Department -> Professor so that all 4 tables can be INNER JOINed
-- in one chain (College - Department - Professor - Student) in Task 3.
ALTER TABLE Professor_Table ADD Dept_ID INT NULL;
GO
ALTER TABLE Professor_Table
    ADD CONSTRAINT fk_professor_dept
        FOREIGN KEY (Dept_ID) REFERENCES Department_Table(Dept_ID);
GO

-- 5  At least 10 records in each table
INSERT INTO College_Table (College_ID, College_Name, College_Area) VALUES
(1,  'Central Engineering College', 'North Campus'),
(2,  'Cosmos Science College',      'East Campus'),
(3,  'Capital Commerce College',    'South Campus'),
(4,  'Delta Arts College',          'West Campus'),
(5,  'Aurora',                      'City Centre'),
(6,  'Sigma',                       'Hill Area'),
(7,  'Vidya',                       'Lake Side'),
(8,  'Horizon Medical College',     'Medical Zone'),
(9,  'Nova',                        'Tech Park'),
(10, 'Crescent Law College',        'Old Town');

INSERT INTO Department_Table (Dept_ID, Dept_Name, Dept_Facility, College_ID) VALUES
(1,  'Computer Science', 'Computer Lab',     1),
(2,  'Mechanical',       'Workshop',         1),
(3,  'Physics',          'Physics Lab',      2),
(4,  'Chemistry',        'Chemistry Lab',    2),
(5,  'Accounting',       'Smart Classroom',  3),
(6,  'Fine Arts',        'Art Studio',       4),
(7,  'Mathematics',      'Seminar Hall',     5),
(8,  'Biology',          'Bio Lab',          6),
(9,  'Law',              'Moot Court',       10),
(10, 'Medicine',         'Hospital Wing',    8),
(11, 'Electronics',      'Embedded Lab',     NULL),
(12, 'Philosophy',       'Reading Room',     NULL);

INSERT INTO Professor_Table (Professor_ID, Professor_Name, Professor_Subject, Dept_ID) VALUES
(1,  'Dr. Anil Kumar',     'Algorithms',           1),
(2,  'Dr. Sunita Rao',     'Thermodynamics',       2),
(3,  'Dr. Rajesh Verma',   'Quantum Physics',      3),
(4,  'Dr. Neha Sharma',    'Organic Chemistry',    4),
(5,  'Dr. Vikram Singh',   'Financial Accounting', 5),
(6,  'Dr. Priya Nair',     'Sculpture',            6),
(7,  'Dr. Karthik Reddy',  'Calculus',             7),
(8,  'Dr. Fatima Khan',    'Genetics',             8),
(9,  'Dr. Suresh Babu',    'Constitutional Law',   9),
(10, 'Dr. Lakshmi Devi',   'Anatomy',              10),
(11, 'Dr. Ravi Teja',      NULL,                   1),
(12, 'Dr. Anjali Mehta',   NULL,                   NULL);

INSERT INTO Student_Table (Student_ID, Student_Name, Student_Stream, Professor_ID) VALUES
(1,  'Aarav Patel',    'Computer Science', 1),
(2,  'Ananya Gupta',   'Physics',          3),
(3,  'Arjun Reddy',    'Computer Science', 1),
(4,  'Bhavana Rao',    'Mechanical',       2),
(5,  'Charan Kumar',   'Chemistry',        4),
(6,  'Divya Sharma',   'Accounting',       5),
(7,  'Eshwar Prasad',  'Fine Arts',        6),
(8,  'Farhan Ali',     'Mathematics',      7),
(9,  'Gayatri Menon',  'Biology',          8),
(10, 'Harsha Vardhan', 'Law',              9),
(11, 'Isha Kapoor',    'Medicine',         10),
(12, 'Kiran Kumar',    'Electronics',      NULL);
GO

-- ---------------------------------------------------------------------
-- TASK 2
-- ---------------------------------------------------------------------

-- 1
SELECT College_ID, College_Name FROM College_Table;

-- 2
SELECT TOP 5 * FROM Student_Table ORDER BY Student_ID;

-- 3
SELECT Professor_Name FROM Professor_Table WHERE Professor_ID = 5;

-- 4
SELECT Professor_ID, UPPER(Professor_Name) AS Professor_Name FROM Professor_Table;

-- 5
SELECT Student_Name FROM Student_Table WHERE Student_Name LIKE 'a%';

-- 6
SELECT College_Name FROM College_Table WHERE College_Name LIKE '%a';
GO

-- 7
ALTER TABLE Professor_Table ADD Salary DECIMAL(10,2);
GO

UPDATE Professor_Table
SET Salary = CASE Professor_ID
    WHEN 1  THEN 95000 WHEN 2  THEN 88000 WHEN 3  THEN 92000
    WHEN 4  THEN 85000 WHEN 5  THEN 90000 WHEN 6  THEN 78000
    WHEN 7  THEN 83000 WHEN 8  THEN 87000 WHEN 9  THEN 91000
    WHEN 10 THEN 99000 WHEN 11 THEN 70000
END
WHERE Professor_ID BETWEEN 1 AND 11;   -- professor 12 keeps NULL salary
GO

SELECT Professor_ID, Professor_Name, Salary FROM Professor_Table;
GO

-- 8
ALTER TABLE Student_Table ADD Contact VARCHAR(15);
GO

UPDATE Student_Table
SET Contact = '98765000' + RIGHT('0' + CAST(Student_ID AS VARCHAR(2)), 2);
GO

SELECT Student_ID, Student_Name, Contact FROM Student_Table;

-- 9
SELECT SUM(Salary) AS Total_Professor_Salary FROM Professor_Table;

-- 10
ALTER TABLE Student_Table ALTER COLUMN Contact BIGINT;
GO

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Student_Table'
ORDER BY ORDINAL_POSITION;
GO

-- ---------------------------------------------------------------------
-- TASK 3
-- ---------------------------------------------------------------------

-- 1
SELECT 'Student' AS Source, s.Student_ID AS ID, s.Student_Name AS Name
FROM (SELECT TOP 5 * FROM Student_Table ORDER BY Student_ID) s
UNION ALL
SELECT 'Professor', p.Professor_ID, p.Professor_Name
FROM (SELECT TOP 5 * FROM Professor_Table ORDER BY Professor_ID) p;

-- 2
SELECT c.College_Name, d.Dept_Name, p.Professor_Name, s.Student_Name
FROM College_Table c
INNER JOIN Department_Table d ON d.College_ID   = c.College_ID
INNER JOIN Professor_Table  p ON p.Dept_ID      = d.Dept_ID
INNER JOIN Student_Table    s ON s.Professor_ID = p.Professor_ID
ORDER BY c.College_ID, s.Student_ID;

-- 3
SELECT * FROM Department_Table WHERE College_ID IS NULL;

SELECT * FROM Professor_Table
WHERE Professor_Subject IS NULL OR Dept_ID IS NULL OR Salary IS NULL;
GO

-- 4  (CREATE VIEW must be the only statement in its batch, hence the GO lines)
IF OBJECT_ID('College_C_View', 'V') IS NOT NULL DROP VIEW College_C_View;
GO
CREATE VIEW College_C_View AS
SELECT * FROM College_Table WHERE College_Name LIKE 'C%';
GO

SELECT * FROM College_C_View;
GO

-- 5
IF OBJECT_ID('Get_Professor_By_ID', 'P') IS NOT NULL DROP PROCEDURE Get_Professor_By_ID;
GO
CREATE PROCEDURE Get_Professor_By_ID
    @ProfessorID INT
AS
BEGIN
    SELECT * FROM Professor_Table WHERE Professor_ID = @ProfessorID;
END
GO

EXEC Get_Professor_By_ID @ProfessorID = 5;
EXEC Get_Professor_By_ID @ProfessorID = 11;
GO

-- 6  (a view does not follow a renamed table, so it is dropped and recreated afterwards)
EXEC sp_rename 'College_Table', 'College_Tables_Data';
GO

DROP VIEW College_C_View;
GO
CREATE VIEW College_C_View AS
SELECT * FROM College_Tables_Data WHERE College_Name LIKE 'C%';
GO

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ORDER BY TABLE_NAME;
SELECT * FROM College_C_View;
GO
