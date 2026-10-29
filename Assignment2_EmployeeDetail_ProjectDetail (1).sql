-- =====================================================================
-- ASSIGNMENT 2 : 
-- =====================================================================

USE master;
GO
IF DB_ID('Employee_Project_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Employee_Project_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Employee_Project_DB;
END
GO
CREATE DATABASE Employee_Project_DB;
GO
USE Employee_Project_DB;
GO

CREATE TABLE EmployeeDetail (
    EmployeeID  INT PRIMARY KEY,
    FirstName   VARCHAR(50),
    LastName    VARCHAR(50),
    Salary      INT,
    JoiningDate DATETIME,
    Department  VARCHAR(30),
    Gender      VARCHAR(10)
);

-- ISO format with 'T' is read the same way under every language/date setting
INSERT INTO EmployeeDetail VALUES
(1, 'Vikas',  'Ahlawat', 600000,  '2013-02-12T11:16:00', 'IT',      'Male'),
(2, 'nikita', 'Jain',    530000,  '2013-02-14T11:16:00', 'HR',      'Female'),
(3, 'Ashish', 'Kumar',   1000000, '2013-02-14T11:16:00', 'IT',      'Male'),
(4, 'Nikhil', 'Sharma',  480000,  '2013-02-15T11:16:00', 'HR',      'Male'),
(5, 'anish',  'kadian',  500000,  '2013-02-16T11:16:00', 'Payroll', 'Male');

-- No foreign key on purpose: ProjectDetail row 9 refers to employee 6,
-- who does not exist (needed to demonstrate outer joins).
CREATE TABLE ProjectDetail (
    ProjectDetailID  INT PRIMARY KEY,
    EmployeeDetailID INT,
    ProjectName      VARCHAR(50)
);

INSERT INTO ProjectDetail VALUES
(1, 1, 'Task Track'),
(2, 1, 'CLP'),
(3, 1, 'Survey Managment'),
(4, 2, 'HR Managment'),
(5, 3, 'Task Track'),
(6, 3, 'GRS'),
(7, 3, 'DDS'),
(8, 4, 'HR Managment'),
(9, 6, 'GL Managment');
GO

-- =====================================================================
-- MAIN QUESTIONS
-- =====================================================================

-- 1
SELECT * FROM EmployeeDetail;

-- 2
SELECT FirstName FROM EmployeeDetail;

-- 3
SELECT UPPER(FirstName) AS [First Name] FROM EmployeeDetail;

-- 4
SELECT UPPER(FirstName) AS [First Name] FROM EmployeeDetail ORDER BY EmployeeID;

-- 5
SELECT FirstName + ' ' + LastName AS Name FROM EmployeeDetail;

-- 5.i
SELECT * FROM EmployeeDetail WHERE FirstName = 'Vikas';

-- 5.ii
SELECT * FROM EmployeeDetail WHERE FirstName LIKE 'a%';

-- 5.iii
SELECT * FROM EmployeeDetail WHERE FirstName LIKE 'a%' ORDER BY EmployeeID;

-- 5.iv
SELECT * FROM EmployeeDetail WHERE FirstName LIKE '%h';

-- 6
SELECT * FROM EmployeeDetail WHERE FirstName LIKE '[a-p]%';

-- 7
SELECT * FROM EmployeeDetail WHERE FirstName NOT LIKE '[a-p]%';

-- 8
SELECT * FROM EmployeeDetail WHERE Gender LIKE '__le';

-- 9
SELECT * FROM EmployeeDetail WHERE FirstName LIKE 'A____';

-- 10  (empty result: no first name contains a % character)
SELECT * FROM EmployeeDetail WHERE FirstName LIKE '%[%]%';

-- 11
SELECT DISTINCT Department FROM EmployeeDetail;

-- 12
SELECT MAX(Salary) AS Highest_Salary FROM EmployeeDetail;

-- 13
SELECT MIN(Salary) AS Lowest_Salary FROM EmployeeDetail;

-- 14   e.g. 15 Feb 2013
SELECT FirstName, CONVERT(VARCHAR(11), JoiningDate, 106) AS JoiningDate FROM EmployeeDetail;

-- 15   e.g. 2013/02/15
SELECT FirstName, CONVERT(VARCHAR(10), JoiningDate, 111) AS JoiningDate FROM EmployeeDetail;

-- 16
SELECT FirstName, CONVERT(VARCHAR(8), JoiningDate, 108) AS Joining_Time FROM EmployeeDetail;

-- 17
SELECT FirstName, YEAR(JoiningDate) AS Joining_Year FROM EmployeeDetail;

-- 18
SELECT FirstName, MONTH(JoiningDate) AS Joining_Month FROM EmployeeDetail;

-- 19
SELECT GETDATE() AS System_Date;

-- 20
SELECT GETUTCDATE() AS UTC_Date_Time;

-- 20.a
SELECT FirstName, GETDATE() AS Current_Date_Time, JoiningDate,
       DATEDIFF(MONTH, JoiningDate, GETDATE()) AS Diff_In_Months
FROM EmployeeDetail;

-- 21
SELECT FirstName, GETDATE() AS Current_Date_Time, JoiningDate,
       DATEDIFF(DAY, JoiningDate, GETDATE()) AS Diff_In_Days
FROM EmployeeDetail;

-- 22
SELECT * FROM EmployeeDetail WHERE YEAR(JoiningDate) = 2013;

-- 23  (empty result: everybody joined in February)
SELECT * FROM EmployeeDetail WHERE MONTH(JoiningDate) = 1;

-- 24  (empty result: same condition written with DATEPART)
SELECT * FROM EmployeeDetail WHERE DATEPART(MONTH, JoiningDate) = 1;

-- 25
SELECT COUNT(*) AS Total_Employees FROM EmployeeDetail;

-- 26
SELECT TOP 1 * FROM EmployeeDetail;

-- 27
SELECT * FROM EmployeeDetail WHERE FirstName IN ('Vikas', 'Ashish', 'Nikhil');

-- 28
SELECT * FROM EmployeeDetail WHERE FirstName NOT IN ('Vikas', 'Ashish', 'Nikhil');

-- 29
SELECT RTRIM(FirstName) AS FirstName FROM EmployeeDetail;

-- 30
SELECT LTRIM(FirstName) AS FirstName FROM EmployeeDetail;

-- 31
SELECT FirstName,
       CASE Gender WHEN 'Male' THEN 'M' WHEN 'Female' THEN 'F' END AS Gender
FROM EmployeeDetail;

-- 32
SELECT 'Hello ' + FirstName AS FirstName FROM EmployeeDetail;

-- 33
SELECT * FROM EmployeeDetail WHERE Salary > 600000;

-- 34
SELECT * FROM EmployeeDetail WHERE Salary < 700000;

-- 35
SELECT * FROM EmployeeDetail WHERE Salary BETWEEN 500000 AND 600000;
GO

-- =====================================================================
-- ADVANCED QUERIES
-- =====================================================================

-- A1
SELECT * FROM ProjectDetail;

-- A2
SELECT Department, SUM(Salary) AS Total_Salary
FROM EmployeeDetail
GROUP BY Department;

-- A3
SELECT Department, SUM(Salary) AS Total_Salary
FROM EmployeeDetail
GROUP BY Department
ORDER BY Total_Salary ASC;

-- A4
SELECT Department, SUM(Salary) AS Total_Salary
FROM EmployeeDetail
GROUP BY Department
ORDER BY Total_Salary DESC;

-- A5
SELECT Department, COUNT(Department) AS Total_No_Of_Departments, SUM(Salary) AS Total_Salary
FROM EmployeeDetail
GROUP BY Department;

-- A6  (Salary * 1.0 so the average is not truncated to an INT)
SELECT Department, AVG(Salary * 1.0) AS Average_Salary
FROM EmployeeDetail
GROUP BY Department
ORDER BY Average_Salary ASC;

-- A7
SELECT Department, MAX(Salary) AS Maximum_Salary
FROM EmployeeDetail
GROUP BY Department
ORDER BY Maximum_Salary ASC;

-- A8
SELECT Department, MIN(Salary) AS Minimum_Salary
FROM EmployeeDetail
GROUP BY Department
ORDER BY Minimum_Salary ASC;

-- A9
SELECT Department, MIN(Salary) AS Minimum_Salary
FROM EmployeeDetail
GROUP BY Department
ORDER BY MIN(Salary);

-- A10
SELECT *
FROM EmployeeDetail e
JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID;

-- A11
SELECT e.FirstName, p.ProjectName
FROM EmployeeDetail e
INNER JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
ORDER BY e.FirstName;

-- A12
SELECT e.FirstName, p.ProjectName
FROM EmployeeDetail e
LEFT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
ORDER BY e.FirstName;

-- A13
SELECT e.FirstName, ISNULL(p.ProjectName, '-No Project Assigned') AS ProjectName
FROM EmployeeDetail e
LEFT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
ORDER BY e.FirstName;

-- A14
SELECT e.FirstName, p.ProjectName
FROM EmployeeDetail e
RIGHT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
ORDER BY e.FirstName;

-- A15
SELECT e.FirstName AS EmployeeName, p.ProjectName
FROM EmployeeDetail e
FULL OUTER JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID;

-- A16
SELECT e.FirstName AS EmployeeName, p.ProjectName
FROM EmployeeDetail e
LEFT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
UNION
SELECT e.FirstName, p.ProjectName
FROM EmployeeDetail e
RIGHT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID;

-- A17
SELECT e.FirstName AS EmployeeName, p.ProjectName
FROM EmployeeDetail e
LEFT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
UNION ALL
SELECT e.FirstName, p.ProjectName
FROM EmployeeDetail e
RIGHT JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
WHERE e.EmployeeID IS NULL;

-- A18
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName, p.ProjectName
FROM EmployeeDetail e
JOIN ProjectDetail p ON e.EmployeeID = p.EmployeeDetailID
WHERE e.EmployeeID IN (SELECT EmployeeDetailID
                       FROM ProjectDetail
                       GROUP BY EmployeeDetailID
                       HAVING COUNT(*) > 1)
ORDER BY EmployeeName, p.ProjectName;

-- A19
SELECT p.ProjectName, e.FirstName + ' ' + e.LastName AS EmployeeName
FROM ProjectDetail p
JOIN EmployeeDetail e ON e.EmployeeID = p.EmployeeDetailID
WHERE p.ProjectName IN (SELECT ProjectName
                        FROM ProjectDetail
                        GROUP BY ProjectName
                        HAVING COUNT(DISTINCT EmployeeDetailID) > 1)
ORDER BY p.ProjectName, EmployeeName;

-- A20
SELECT *
FROM EmployeeDetail
CROSS JOIN ProjectDetail;
GO
