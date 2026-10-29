-- =====================================================================
-- ASSIGNMENT 5 : SQL SELECT Queries (students / borrows / books /
--                authors / types)                           (SQL Server / T-SQL)
-- =====================================================================

USE master;
GO
IF DB_ID('Library_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Library_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Library_DB;
END
GO
CREATE DATABASE Library_DB;
GO
USE Library_DB;
GO

CREATE TABLE students (
    studentId INT IDENTITY(1,1) PRIMARY KEY,
    name      VARCHAR(50),
    surname   VARCHAR(50),
    birthdate DATE,
    gender    CHAR(1),
    class     VARCHAR(10),
    point     INT
);

CREATE TABLE authors (
    authorId INT IDENTITY(1,1) PRIMARY KEY,
    name     VARCHAR(50),
    surname  VARCHAR(50)
);

CREATE TABLE types (
    typeId INT IDENTITY(1,1) PRIMARY KEY,
    name   VARCHAR(50)
);

CREATE TABLE books (
    bookId    INT IDENTITY(1,1) PRIMARY KEY,
    name      VARCHAR(100),
    pagecount INT,
    point     INT,
    authorId  INT,
    typeId    INT,
    FOREIGN KEY (authorId) REFERENCES authors(authorId),
    FOREIGN KEY (typeId)   REFERENCES types(typeId)
);

CREATE TABLE borrows (
    borrowId    INT IDENTITY(1,1) PRIMARY KEY,
    studentId   INT,
    bookId      INT,
    takenDate   DATE,
    broughtDate DATE,
    FOREIGN KEY (studentId) REFERENCES students(studentId),
    FOREIGN KEY (bookId)    REFERENCES books(bookId)
);
GO

-- ---------------------------------------------------------------------
-- DATA  (explicit ids need IDENTITY_INSERT ON; the counter then continues
--        after the highest id that was inserted)
-- ---------------------------------------------------------------------
-- students 1-10 are the sample rows; 11-42 are extra rows (classes such as
-- 10Math / 10Sci / 9Math / 9His / 10Bio, birth year 1989, a NULL birthdate)
-- so that every question below has something to work on.
SET IDENTITY_INSERT students ON;
INSERT INTO students (studentId, name, surname, birthdate, gender, class, point) VALUES
(1,  'John',    'Doe',      '2005-01-15', 'M', '10A',    85),
(2,  'Jane',    'Smith',    '2006-03-22', 'F', '10B',    90),
(3,  'Alice',   'Johnson',  '2005-07-12', 'F', '10A',    88),
(4,  'Bob',     'Brown',    '2006-11-30', 'M', '10C',    76),
(5,  'Charlie', 'Davis',    '2005-05-05', 'M', '10B',    92),
(6,  'Diana',   'Miller',   '2006-06-25', 'F', '10C',    81),
(7,  'Eve',     'Wilson',   '2005-09-18', 'F', '10A',    87),
(8,  'Frank',   'Moore',    '2006-12-02', 'M', '10B',    80),
(9,  'Grace',   'Taylor',   '2005-04-17', 'F', '10C',    83),
(10, 'Hank',    'Anderson', '2006-10-20', 'M', '10A',    78),
(11, 'Emma',    'Stone',    '1989-04-12', 'F', '10Math', 78),
(12, 'Sophia',  'Turner',   '1989-08-23', 'F', '10Math', 91),
(13, 'Robert',  'King',     '1990-02-02', 'M', '10Bio',  84),
(14, 'Daniel',  'Craig',    '1990-01-20', 'M', '10Math', 73),
(15, 'Kevin',   'Hart',     '1991-05-17', 'M', '10Sci',  69),
(16, 'Amy',     'Adams',    '1990-09-09', 'F', '9Math',  88),
(17, 'Aaron',   'Paul',     '1989-12-25', 'M', '9Math',  82),
(18, 'Linda',   'Hamilton', '1990-07-07', 'F', '9His',   79),
(19, 'David',   'Beckham',  '1991-03-03', 'M', '9His',   86),
(20, 'Karen',   'Gillan',   NULL,         'F', '10Bio',  90),
(35, 'Fiona',   'Apple',    '1990-06-18', 'F', '10Sci',  74),
(42, 'Helen',   'Mirren',   '1989-10-05', 'F', '9His',   95);
SET IDENTITY_INSERT students OFF;

SET IDENTITY_INSERT authors ON;
INSERT INTO authors (authorId, name, surname) VALUES
(1,  'F. Scott', 'Fitzgerald'),
(2,  'Harper',   'Lee'),
(3,  'George',   'Orwell'),
(4,  'Jane',     'Austen'),
(5,  'J.D.',     'Salinger'),
(6,  'J.R.R.',   'Tolkien'),
(7,  'Herman',   'Melville'),
(8,  'Leo',      'Tolstoy'),
(9,  'James',    'Joyce'),
(10, 'Homer',    '');
SET IDENTITY_INSERT authors OFF;

SET IDENTITY_INSERT types ON;
INSERT INTO types (typeId, name) VALUES
(1,  'Fiction'),
(2,  'Classic'),
(3,  'Dystopian'),
(4,  'Literature'),
(5,  'Fantasy'),
(6,  'Adventure'),
(7,  'Historical Fiction'),
(8,  'Science Fiction'),
(9,  'Mythology'),
(10, 'Philosophy');
SET IDENTITY_INSERT types OFF;

SET IDENTITY_INSERT books ON;
INSERT INTO books (bookId, name, pagecount, point, authorId, typeId) VALUES
(1,  'The Great Gatsby',        180,  95, 1,  1),
(2,  'To Kill a Mockingbird',   281,  90, 2,  2),
(3,  '1984',                    328,  88, 3,  3),
(4,  'Pride and Prejudice',     279,  93, 4,  4),
(5,  'The Catcher in the Rye',  214,  85, 5,  1),
(6,  'The Hobbit',              310,  91, 6,  2),
(7,  'Moby-Dick',               635,  80, 7,  3),
(8,  'War and Peace',           1225, 92, 8,  4),
(9,  'Ulysses',                 730,  89, 9,  1),
(10, 'The Odyssey',             541,  87, 10, 2),
(11, 'Anna Karenina',           864,  90, 8,  4);
SET IDENTITY_INSERT books OFF;

SET IDENTITY_INSERT borrows ON;
INSERT INTO borrows (borrowId, studentId, bookId, takenDate, broughtDate) VALUES
(1,  1,  3,  '2024-01-10', '2024-01-20'),
(2,  2,  5,  '2024-01-12', '2024-01-22'),
(3,  3,  7,  '2024-01-15', '2024-01-25'),
(4,  4,  2,  '2024-01-18', '2024-01-28'),
(5,  5,  1,  '2024-01-20', '2024-01-30'),
(6,  6,  4,  '2024-01-22', '2024-02-01'),
(7,  7,  6,  '2024-01-24', '2024-02-03'),
(8,  8,  8,  '2024-01-26', '2024-02-05'),
(9,  9,  10, '2024-01-28', '2024-02-07'),
(10, 10, 9,  '2024-01-30', '2024-02-09');
SET IDENTITY_INSERT borrows OFF;
GO

-- =====================================================================
-- QUERIES
-- =====================================================================

-- 1
SELECT * FROM students;

-- 2
SELECT name, surname, class FROM students;

-- 3
SELECT * FROM students WHERE gender = 'F';

-- 4
SELECT DISTINCT class FROM students;

-- 5
SELECT * FROM students WHERE gender = 'F' AND class = '10Math';

-- 6
SELECT name, surname, class FROM students WHERE class = '10Math' OR class = '10Sci';

-- 7
SELECT name, surname, studentId AS school_number FROM students;

-- 8
SELECT name + ' ' + surname AS name_surname FROM students;

-- 9
SELECT * FROM students WHERE name LIKE 'A%';

-- 10
SELECT name, pagecount FROM books WHERE pagecount BETWEEN 50 AND 200;

-- 11
SELECT * FROM students WHERE name IN ('Emma', 'Sophia', 'Robert');

-- 12
SELECT * FROM students WHERE name LIKE '[ADK]%';

-- 13
SELECT name, surname, class, gender
FROM students
WHERE (gender = 'M' AND class = '9Math') OR (gender = 'F' AND class = '9His');

-- 14
SELECT * FROM students WHERE gender = 'M' AND class IN ('10Math', '10Bio');

-- 15
SELECT * FROM students WHERE YEAR(birthdate) = 1989;

-- 16
SELECT * FROM students WHERE gender = 'F' AND studentId BETWEEN 30 AND 50;

-- 17
SELECT * FROM students ORDER BY name;

-- 18
SELECT * FROM students ORDER BY name, surname;

-- 19
SELECT * FROM students WHERE class = '10Math' ORDER BY studentId DESC;

-- 20
SELECT TOP 10 * FROM students ORDER BY studentId;

-- 21
SELECT TOP 10 name, surname, birthdate FROM students ORDER BY studentId;

-- 22
SELECT TOP 1 * FROM books ORDER BY pagecount DESC;

-- 23  (youngest = latest birthdate)
SELECT TOP 1 * FROM students WHERE birthdate IS NOT NULL ORDER BY birthdate DESC;

-- 24  (oldest = earliest birthdate)
SELECT TOP 1 * FROM students
WHERE class = '10Math' AND birthdate IS NOT NULL
ORDER BY birthdate ASC;

-- 25
SELECT * FROM books WHERE name LIKE '_n%';

-- 26
SELECT class, COUNT(*) AS number_of_students
FROM students
GROUP BY class
ORDER BY class;

-- 27
SELECT * FROM students ORDER BY NEWID();

-- 28
SELECT TOP 1 * FROM students ORDER BY NEWID();

-- 29
SELECT TOP 1 name, surname, studentId FROM students WHERE class = '10Math' ORDER BY NEWID();

-- 30
INSERT INTO authors (name, surname) VALUES ('Smith', 'Allen');
SELECT * FROM authors WHERE name = 'Smith' AND surname = 'Allen';

-- 31
INSERT INTO types (name) VALUES ('Biography');
SELECT * FROM types WHERE name = 'Biography';

-- 32
INSERT INTO students (name, surname, gender, class) VALUES
('Thomas', 'Nelson', 'M', '10Math'),
('Sally',  'Allen',  'F', '9Bio'),
('Linda',  'Sandra', 'F', '11His');
SELECT * FROM students
WHERE (name = 'Thomas' AND surname = 'Nelson')
   OR (name = 'Sally'  AND surname = 'Allen')
   OR (name = 'Linda'  AND surname = 'Sandra');

-- 33
INSERT INTO authors (name, surname)
SELECT TOP 1 name, surname FROM students ORDER BY NEWID();
SELECT TOP 1 * FROM authors ORDER BY authorId DESC;

-- 34
INSERT INTO authors (name, surname)
SELECT name, surname FROM students WHERE studentId BETWEEN 10 AND 30;
SELECT COUNT(*) AS total_authors FROM authors;

-- 35  (@@IDENTITY holds the last automatically generated id)
INSERT INTO authors (name, surname) VALUES ('Cindy', 'Brown');
SELECT @@IDENTITY AS new_author_number;

-- 36
UPDATE students SET class = '10His' WHERE studentId = 3;
SELECT studentId, name, class FROM students WHERE studentId = 3;

-- 37
UPDATE students SET class = '10Math' WHERE class = '9Math';
SELECT studentId, name, class FROM students WHERE class = '10Math' ORDER BY studentId;

-- 38
UPDATE students SET point = point + 5;
SELECT studentId, name, point FROM students ORDER BY studentId;

-- 39  (the authors table ends at id 24, so there is no author #25 and
--      this DELETE correctly removes 0 rows; authors 20 onwards are shown below)
DELETE FROM authors WHERE authorId = 25;
SELECT authorId, name, surname FROM authors WHERE authorId >= 20 ORDER BY authorId;

-- 40
SELECT * FROM students WHERE birthdate IS NULL;

-- 41
SELECT s.name, s.surname, b.takenDate
FROM students s
JOIN borrows b ON b.studentId = s.studentId
ORDER BY b.takenDate;
GO
