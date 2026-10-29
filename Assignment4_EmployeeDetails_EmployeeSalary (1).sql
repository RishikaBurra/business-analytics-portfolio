
-- ASSIGNMENT 4 


USE master;
GO
IF DB_ID('Employee_Salary_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Employee_Salary_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Employee_Salary_DB;
END
GO
CREATE DATABASE Employee_Salary_DB;
GO
USE Employee_Salary_DB;
GO

CREATE TABLE EmployeeDetails (
    EmpId         INT PRIMARY KEY,
    FullName      VARCHAR(100),
    ManagerId     INT,
    DateOfJoining DATE,
    City          VARCHAR(100)
);

CREATE TABLE EmployeeSalary (
    EmpId    INT,
    Project  VARCHAR(50),
    Salary   DECIMAL(10, 2),
    Variable DECIMAL(10, 2),
    FOREIGN KEY (EmpId) REFERENCES EmployeeDetails(EmpId)
);
GO

INSERT INTO EmployeeDetails (EmpId, FullName, ManagerId, DateOfJoining, City) VALUES
(101, 'Alice Johnson', 321, '2022-05-15', 'New York'),
(102, 'Bob Smith', 876, '2020-03-12', 'Los Angeles'),
(103, 'Charlie Brown', 986, '2021-08-23', 'Chicago'),
(104, 'David Williams', 876, '2019-11-05', 'Houston'),
(105, 'Eve Davis', 321, '2023-01-07', 'Phoenix'),
(106, 'Frank Miller', 986, '2018-12-19', 'Philadelphia'),
(107, 'Grace Wilson', 876, '2022-03-28', 'San Antonio'),
(108, 'Hank Moore', 321, '2021-09-14', 'San Diego'),
(109, 'Ivy Taylor', 986, '2020-02-11', 'Dallas'),
(110, 'Jack Anderson', 876, '2022-11-30', 'San Jose'),
(111, 'Karen Thomas', 321, '2021-07-16', 'Austin'),
(112, 'Liam Jackson', 986, '2023-04-21', 'Fort Worth'),
(113, 'Mia White', 876, '2019-06-03', 'Columbus'),
(114, 'Noah Harris', 321, '2020-12-10', 'Charlotte'),
(115, 'Olivia Martin', 986, '2021-10-25', 'San Francisco'),
(116, 'Paul Garcia', 876, '2023-07-18', 'Indianapolis'),
(117, 'Quinn Martinez', 321, '2022-09-07', 'Seattle'),
(118, 'Rachel Rodriguez', 986, '2020-01-15', 'Denver'),
(119, 'Steve Clark', 876, '2021-03-19', 'Washington'),
(120, 'Tina Lewis', 321, '2019-08-31', 'Boston');

INSERT INTO EmployeeSalary (EmpId, Project, Salary, Variable) VALUES
(101, 'P1', 7500, 500),
(102, 'P2', 9200, 700),
(103, 'P1', 6700, 600),
(104, 'P3', 8300, 900),
(105, 'P2', 7800, 800),
(106, 'P3', 9100, 1000),
(107, 'P1', 6200, 400),
(108, 'P2', 8800, 750),
(109, 'P3', 9500, 1100),
(110, 'P1', 7200, 650),
(111, 'P2', 8700, 850),
(112, 'P3', 9300, 1200),
(113, 'P1', 7900, 550),
(114, 'P2', 6800, 450),
(115, 'P3', 8400, 900),
(116, 'P1', 7600, 500),
(117, 'P2', 8900, 1000),
(118, 'P3', 9200, 1100),
(119, 'P1', 8100, 600),
(120, 'P2', 8300, 750);
GO

-- PART 1
-- =====================================================================

-- 1.1  Present in EmployeeDetails but not in EmployeeSalary
--      (empty: every employee has a salary row)
SELECT d.*
FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE s.EmpId IS NULL;

-- 1.1  ... and the other direction (empty as well)
SELECT s.*
FROM EmployeeSalary s
LEFT JOIN EmployeeDetails d ON d.EmpId = s.EmpId
WHERE d.EmpId IS NULL;

-- 1.2  (empty: every employee works on a project)
SELECT d.EmpId, d.FullName
FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE s.Project IS NULL;

-- 1.3
SELECT * FROM EmployeeDetails WHERE YEAR(DateOfJoining) = 2020;

-- 1.4
SELECT d.*
FROM EmployeeDetails d
INNER JOIN EmployeeSalary s ON s.EmpId = d.EmpId;

-- 1.5
SELECT Project, COUNT(*) AS Employee_Count
FROM EmployeeSalary
GROUP BY Project
ORDER BY Project;

-- 1.6
SELECT d.FullName, s.Salary
FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON s.EmpId = d.EmpId;

-- 1.7  (empty: no ManagerId equals any EmpId)
SELECT DISTINCT e.EmpId, e.FullName
FROM EmployeeDetails e
WHERE e.EmpId IN (SELECT ManagerId FROM EmployeeDetails);

-- 1.8  (empty: no duplicate records)
SELECT EmpId, FullName, ManagerId, DateOfJoining, City, COUNT(*) AS Duplicate_Count
FROM EmployeeDetails
GROUP BY EmpId, FullName, ManagerId, DateOfJoining, City
HAVING COUNT(*) > 1;

-- 1.9
SELECT EmpId, FullName, ManagerId, DateOfJoining, City
FROM (
    SELECT d.*, ROW_NUMBER() OVER (ORDER BY EmpId) AS rn
    FROM EmployeeDetails d
) t
WHERE rn % 2 = 1;

-- 1.10  3rd highest salary without TOP / LIMIT
SELECT MAX(Salary) AS Third_Highest_Salary
FROM EmployeeSalary
WHERE Salary < (SELECT MAX(Salary)
                FROM EmployeeSalary
                WHERE Salary < (SELECT MAX(Salary) FROM EmployeeSalary));

-- 1.10  (second way: DENSE_RANK)
SELECT DISTINCT Salary AS Third_Highest_Salary
FROM (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM EmployeeSalary
) t
WHERE rnk = 3;


-- PART 2
-- =====================================================================

-- 2.1
SELECT EmpId, FullName FROM EmployeeDetails WHERE ManagerId = 986;

-- 2.2
SELECT DISTINCT Project FROM EmployeeSalary;

-- 2.3
SELECT COUNT(*) AS P1_Employee_Count FROM EmployeeSalary WHERE Project = 'P1';

-- 2.4
SELECT MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary, AVG(Salary) AS Avg_Salary
FROM EmployeeSalary;

-- 2.5
SELECT EmpId, Salary FROM EmployeeSalary WHERE Salary BETWEEN 9000 AND 15000;

-- 2.6  (empty: no employee lives in Toronto)
SELECT * FROM EmployeeDetails WHERE City = 'Toronto' AND ManagerId = 321;

-- 2.7  (nobody lives in California, so these are the manager-321 employees)
SELECT * FROM EmployeeDetails WHERE City = 'California' OR ManagerId = 321;

-- 2.8
SELECT d.EmpId, d.FullName, s.Project
FROM EmployeeDetails d
JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE s.Project <> 'P1';

-- 2.9
SELECT EmpId, Salary, Variable, (Salary + Variable) AS Total_Salary FROM EmployeeSalary;

-- 2.10  (empty: no name has "hn" in the 3rd-4th position)
SELECT * FROM EmployeeDetails WHERE FullName LIKE '__hn%';
-- PART 3
-- =====================================================================

-- 3.1
SELECT EmpId FROM EmployeeDetails
UNION
SELECT EmpId FROM EmployeeSalary;

-- 3.2
SELECT d.*, s.Project, s.Salary, s.Variable
FROM EmployeeDetails d
INNER JOIN EmployeeSalary s ON s.EmpId = d.EmpId;

-- 3.3  (both directions combined; empty because both tables hold the same EmpIds)
SELECT COALESCE(d.EmpId, s.EmpId) AS EmpId
FROM EmployeeDetails d
FULL OUTER JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE d.EmpId IS NULL OR s.EmpId IS NULL;

-- 3.4
SELECT d.EmpId
FROM EmployeeDetails d
INNER JOIN EmployeeSalary s ON s.EmpId = d.EmpId;

-- 3.5  (empty)
SELECT d.EmpId
FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE s.EmpId IS NULL;

-- 3.6
SELECT FullName, REPLACE(FullName, ' ', '_') AS FullName_Replaced FROM EmployeeDetails;

-- 3.7  position of the letter 'a' in FullName
SELECT FullName, CHARINDEX('a', FullName) AS Position_Of_a FROM EmployeeDetails;

-- 3.8
SELECT EmpId, ManagerId, CONCAT(EmpId, '-', ManagerId) AS EmpId_ManagerId FROM EmployeeDetails;

-- 3.9
SELECT FullName, LEFT(FullName, CHARINDEX(' ', FullName + ' ') - 1) AS FirstName FROM EmployeeDetails;

-- 3.10
SELECT UPPER(FullName) AS FullName, LOWER(City) AS City FROM EmployeeDetails;


-- PART 4
-- =====================================================================

-- 4.1  occurrences of the lowercase letter 'n' per name and in total
--      (COLLATE ... CS_AS makes REPLACE case-sensitive, so 'N' is not counted)
SELECT FullName,
       LEN(FullName) - LEN(REPLACE(FullName COLLATE Latin1_General_CS_AS, 'n', '')) AS n_Count
FROM EmployeeDetails;

SELECT SUM(LEN(FullName) - LEN(REPLACE(FullName COLLATE Latin1_General_CS_AS, 'n', ''))) AS Total_n_Count
FROM EmployeeDetails;

-- 4.2
UPDATE EmployeeDetails SET FullName = LTRIM(RTRIM(FullName));
SELECT TOP 5 EmpId, '[' + FullName + ']' AS FullName_After_Trim FROM EmployeeDetails ORDER BY EmpId;

-- 4.3  (empty)
SELECT d.EmpId, d.FullName
FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE s.Project IS NULL;

-- 4.4
SELECT d.FullName, s.Salary
FROM EmployeeDetails d
JOIN EmployeeSalary s ON s.EmpId = d.EmpId
WHERE s.Salary >= 5000 AND s.Salary <= 10000;

-- 4.5
SELECT GETDATE() AS Current_Date_Time;

-- 4.6
SELECT * FROM EmployeeDetails WHERE YEAR(DateOfJoining) = 2020;

-- 4.7
SELECT d.*
FROM EmployeeDetails d
INNER JOIN EmployeeSalary s ON s.EmpId = d.EmpId;

-- 4.8
SELECT Project, COUNT(*) AS Employee_Count
FROM EmployeeSalary
GROUP BY Project
ORDER BY Employee_Count DESC, Project;

-- 4.9
SELECT d.FullName, s.Project, s.Salary, s.Variable
FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON s.EmpId = d.EmpId;
GO

-- 4.10  Joining 3 tables: a small ManagerDetails table is added for this
CREATE TABLE ManagerDetails (
    ManagerId   INT PRIMARY KEY,
    ManagerName VARCHAR(100)
);
GO
INSERT INTO ManagerDetails VALUES (321, 'Michael Scott'), (876, 'Pam Beesly'), (986, 'Jim Halpert');
GO

SELECT d.EmpId, d.FullName, s.Project, s.Salary, m.ManagerName
FROM EmployeeDetails d
JOIN EmployeeSalary  s ON s.EmpId     = d.EmpId
JOIN ManagerDetails  m ON m.ManagerId = d.ManagerId
ORDER BY d.EmpId;
GO
