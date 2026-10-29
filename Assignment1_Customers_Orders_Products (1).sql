
-- Assingment1

USE master;
GO
IF DB_ID('Customers_Orders_Products') IS NOT NULL
BEGIN
    ALTER DATABASE Customers_Orders_Products SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Customers_Orders_Products;
END
GO
CREATE DATABASE Customers_Orders_Products;
GO
USE Customers_Orders_Products;
GO

-- 
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductName VARCHAR(50),
    OrderDate DATE,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);
GO


-- 
INSERT INTO Customers (CustomerID, Name, Email) VALUES
(1, 'John Doe', 'johndoe@example.com'),
(2, 'Jane Smith', 'janesmith@example.com'),
(3, 'Robert Johnson', 'robertjohnson@example.com'),
(4, 'Emily Brown', 'emilybrown@example.com'),
(5, 'Michael Davis', 'michaeldavis@example.com'),
(6, 'Sarah Wilson', 'sarahwilson@example.com'),
(7, 'David Thompson', 'davidthompson@example.com'),
(8, 'Jessica Lee', 'jessicalee@example.com'),
(9, 'William Turner', 'williamturner@example.com'),
(10, 'Olivia Martinez', 'oliviamartinez@example.com'),
(11, 'James Anderson', 'jamesanderson@example.com'),
(12, 'Kelly Clarkson', 'kellyclarkson@example.com');

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Product A', 10.99),
(2, 'Product B', 8.99),
(3, 'Product C', 5.99),
(4, 'Product D', 12.99),
(5, 'Product E', 7.99),
(6, 'Product F', 6.99),
(7, 'Product G', 9.99),
(8, 'Product H', 11.99),
(9, 'Product I', 14.99),
(10, 'Product J', 4.99),
(11, 'Product K', 3.99),
(12, 'Product L', 15.99);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity) VALUES
(1, 1, 'Product A', '2023-07-01', 5),
(2, 2, 'Product B', '2023-07-02', 3),
(3, 3, 'Product C', '2023-07-03', 2),
(4, 4, 'Product A', '2023-07-04', 1),
(5, 5, 'Product B', '2023-07-05', 4),
(6, 6, 'Product C', '2023-07-06', 2),
(7, 7, 'Product A', '2023-07-07', 3),
(8, 8, 'Product B', '2023-07-08', 2),
(9, 9, 'Product C', '2023-07-09', 5),
(10, 10, 'Product A', '2023-07-10', 1),
(11, 11, 'Product D', '2023-07-10', 3),
(12, 12, 'Product E', '2023-07-11', 6),
(13, 5, 'Product G', '2023-07-12', 2),
(14, 4, 'Product H', '2023-07-13', 4),
(15, 6, 'Product I', '2023-07-14', 3);
GO


--

-- 1
SELECT * FROM Customers;

-- 2
SELECT Name, Email
FROM Customers
WHERE Name LIKE 'J%';

-- 3
SELECT OrderID, ProductName, Quantity
FROM Orders;

-- 4
SELECT SUM(Quantity) AS Total_Quantity_Ordered
FROM Orders;

-- 5
SELECT DISTINCT c.Name
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID;

-- 6
SELECT *
FROM Products
WHERE Price > 10.00;

-- 7
SELECT c.Name, o.OrderDate
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= '2023-07-05'
ORDER BY o.OrderDate;

-- 8
SELECT AVG(Price) AS Average_Price
FROM Products;

-- 9
SELECT c.Name, SUM(o.Quantity) AS Total_Quantity
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY c.CustomerID;

-- 10
SELECT p.ProductID, p.ProductName, p.Price
FROM Products p
LEFT JOIN Orders o ON o.ProductName = p.ProductName
WHERE o.OrderID IS NULL;
GO

-- 

-- The Products table has no category column, so one is added
-- (needed for Task 2 items 2 and 7): ProductID 1-6 = 'Standard', 7-12 = 'Premium'
ALTER TABLE Products ADD Category VARCHAR(30);
GO

UPDATE Products
SET Category = CASE WHEN ProductID <= 6 THEN 'Standard' ELSE 'Premium' END;
GO

SELECT * FROM Products;
GO

-- 1  (ties on quantity are broken by CustomerID)
SELECT TOP 5 c.CustomerID, c.Name, SUM(o.Quantity) AS Total_Quantity
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Quantity DESC, c.CustomerID;

-- 2
SELECT Category, ROUND(AVG(Price), 2) AS Average_Price
FROM Products
GROUP BY Category;

-- 3  (empty result: every customer has placed at least one order)
SELECT c.CustomerID, c.Name
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;

-- 4
SELECT o.OrderID, o.ProductName, o.Quantity
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.Name LIKE 'M%';

-- 5
SELECT SUM(o.Quantity * p.Price) AS Total_Revenue
FROM Orders o
JOIN Products p ON p.ProductName = o.ProductName;

-- 6
SELECT c.Name, SUM(o.Quantity * p.Price) AS Total_Revenue
FROM Customers c
JOIN Orders o   ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductName = o.ProductName
GROUP BY c.CustomerID, c.Name
ORDER BY c.CustomerID;

-- 7
SELECT c.CustomerID, c.Name
FROM Customers c
JOIN Orders o   ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductName = o.ProductName
GROUP BY c.CustomerID, c.Name
HAVING COUNT(DISTINCT p.Category) = (SELECT COUNT(DISTINCT Category) FROM Products);

-- 8  (empty result: no customer ordered on two consecutive days)
SELECT DISTINCT c.CustomerID, c.Name
FROM (
    SELECT CustomerID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PrevDate
    FROM Orders
) t
JOIN Customers c ON c.CustomerID = t.CustomerID
WHERE DATEDIFF(DAY, t.PrevDate, t.OrderDate) = 1;

-- 9  (AVG of an INT column is truncated in SQL Server, so Quantity is cast first;
--     ties on average are broken by ProductName)
SELECT TOP 3 ProductName, AVG(CAST(Quantity AS DECIMAL(10, 2))) AS Avg_Quantity
FROM Orders
GROUP BY ProductName
ORDER BY Avg_Quantity DESC, ProductName;

-- 10
SELECT CAST(100.0 * COUNT(CASE WHEN o.Quantity > a.AvgQty THEN 1 END) / COUNT(*) AS DECIMAL(5, 2))
       AS Percentage_Above_Average
FROM Orders o
CROSS JOIN (SELECT AVG(CAST(Quantity AS DECIMAL(10, 4))) AS AvgQty FROM Orders) a;
GO
