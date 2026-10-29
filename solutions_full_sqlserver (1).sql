
DROP TABLE IF EXISTS client_transactions;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Accounts;
GO

CREATE TABLE clients (
    client_id  INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50)
);
CREATE TABLE client_transactions (
    transaction_id   INT PRIMARY KEY,
    client_id        INT,
    transaction_date DATETIME,
    amount           DECIMAL(10,2)
);
CREATE TABLE Accounts (
    account_id   INT PRIMARY KEY,
    account_type VARCHAR(20),
    balance      DECIMAL(10,2)
);
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    account_id  INT
);
GO

INSERT INTO clients VALUES
 (123,'John','Doe'),(456,'Jane','Smith'),(789,'Martin','Johnson'),
 (654,'Lucy','Thompson'),(321,'Sam','Williams');

INSERT INTO client_transactions VALUES
 (1001,123,'2022-06-08',500.01),
 (1002,123,'2022-07-15',752.99),
 (1003,123,'2022-08-22',320.25),
 (1004,456,'2022-07-10',698.52),
 (1005,456,'2022-07-26',421.76),
 (1006,456,'2022-08-14',649.80);

INSERT INTO Accounts VALUES
 (1,'Saving',5000),(2,'Checking',1000),(3,'Saving',5500),
 (4,'Saving',4500),(5,'Checking',1800);

INSERT INTO Customers VALUES (101,1),(102,2),(103,3),(104,4),(105,5);
GO


WITH ranked AS (
    SELECT client_id, transaction_date, amount,
           ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY transaction_date DESC) AS rn
    FROM client_transactions
)
SELECT client_id,
       MAX(transaction_date) AS transaction_date,
       ROUND(AVG(amount), 2) AS avg_amount
FROM ranked
WHERE rn <= 3
GROUP BY client_id
HAVING COUNT(*) = 3
ORDER BY client_id;
GO


SELECT a.account_type, AVG(a.balance) AS avg_balance
FROM Accounts a
JOIN Customers c ON c.account_id = a.account_id
GROUP BY a.account_type;
GO


SELECT a.account_type, AVG(a.balance) AS avg_balance
FROM Accounts a
JOIN Customers c ON c.account_id = a.account_id
GROUP BY a.account_type;
GO
