-- ===================================== Retail Sales Management System ===================================== --

-- Create a Database:
create database RetailSalesDB
GO

-- Use Database:
use RetailSalesDB
GO

-- Create Schema
create schema sales


-- =========================================
-- CREATE CUSTOMERS TABLE
CREATE TABLE sales.Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('Male','Female')),
    City VARCHAR(50) NOT NULL,
    StateName VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    Email VARCHAR(100),
    JoinDate DATE DEFAULT GETDATE()
);


INSERT INTO sales.Customers
(CustomerName, Gender, City, StateName, Email)
VALUES
('Aman Sharma', 'Male', 'Delhi', 'Delhi', 'aman@gmail.com'),
('Neha Verma', 'Female', 'Mumbai', 'Maharashtra', 'neha@gmail.com'),
('Rohit Singh', 'Male', 'Pune', 'Maharashtra', 'rohit@gmail.com'),
('Priya Mehta', 'Female', 'Jaipur', 'Rajasthan', 'priya@gmail.com'),
('Karan Patel', 'Male', 'Ahmedabad', 'Gujarat', 'karan@gmail.com');


-- Create PRODUCTS TABLE
CREATE TABLE sales.Products
(
    ProductID INT IDENTITY(100,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) CHECK (Category IN ('Electronics','Clothing','Furniture')),
    Price DECIMAL(10,2) CHECK (Price > 0),
    StockQuantity INT CHECK (StockQuantity >= 0),
    Brand VARCHAR(50),
    AddedDate DATE DEFAULT GETDATE()
);


INSERT INTO sales.Products
(ProductName, Category, Price, StockQuantity, Brand)
VALUES
('Laptop', 'Electronics', 65000, 20, 'HP'),
('Mobile Phone', 'Electronics', 30000, 50, 'Samsung'),
('T-Shirt', 'Clothing', 1200, 100, 'Levis'),
('Sofa', 'Furniture', 45000, 10, 'IKEA'),
('Jeans', 'Clothing', 2500, 60, 'Levis');


-- EMPLOYEES TABLE
CREATE TABLE sales.Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Department VARCHAR(50) CHECK (Department IN ('Sales','Support','HR')),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    HireDate DATE DEFAULT GETDATE(),
    City VARCHAR(50)
);


INSERT INTO sales.Employees
(EmployeeName, Department, Salary, City)
VALUES
('Raj Malhotra', 'Sales', 50000, 'Delhi'),
('Sneha Kapoor', 'Sales', 55000, 'Mumbai'),
('Vikas Sharma', 'Support', 45000, 'Pune'),
('Anjali Gupta', 'HR', 60000, 'Jaipur');


-- ORDERS TABLE
CREATE TABLE sales.Orders
(
    OrderID INT IDENTITY(1000,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATE DEFAULT GETDATE(),
    OrderStatus VARCHAR(20) DEFAULT 'Pending' CHECK (OrderStatus IN ('Pending','Completed','Cancelled')),
    PaymentMode VARCHAR(20) CHECK (PaymentMode IN ('UPI','Card','Cash'))
);


INSERT INTO sales.Orders
(CustomerID, EmployeeID, OrderStatus, PaymentMode)
VALUES
(1, 1, 'Completed', 'UPI'),
(2, 2, 'Completed', 'Card'),
(3, 1, 'Pending', 'Cash'),
(4, 2, 'Completed', 'UPI'),
(5, 1, 'Cancelled', 'Card');


-- ORDER DETAILS TABLE
CREATE TABLE sales.OrderDetails
(
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice > 0)
);

INSERT INTO sales.OrderDetails
(OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1000, 100, 1, 65000),
(1000, 102, 2, 1200),
(1001, 101, 1, 30000),
(1002, 104, 2, 2500),
(1003, 103, 1, 45000);


SELECT * FROM sales.Customers
SELECT * FROM sales.Products
SELECT * FROM sales.Employees
SELECT * FROM sales.Orders
SELECT * FROM sales.OrderDetails


-- UPDATE statement
update sales.Products
set price = 70000
where ProductName = 'Laptop';


-- DELETE Statement
DELETE from sales.Orders
WHERE OrderStatus = 'Cancelled';


-- SELECT Statement
SELECT * from sales.Customers;


-- WHERE Clause
SELECT * from sales.Products
WHERE Price > 20000;


-- AND Operator
SELECT * from sales.Products
where Category = 'Electronics'
    AND Price > 50000;


-- OR Operator
SELECT * from sales.Customers
WHERE city = 'Delhi' 
    OR city = 'Pune';


-- IN Operator
SELECT * from sales.Customers
WHERE city IN ('Delhi', 'Mumbai', 'Jaipur');


-- BETWEEN Operator
SELECT * FROM sales.Products 
WHERE price BETWEEN 1000 and 50000;


-- LIKE Operator
SELECT * from sales.Customers
WHERE CustomerName LIKE 'P%';


=============================================================================================
-------------------------------- Aggregate Function --------------------------------

-- COUNT
SELECT count(*) as TotalCustomers
FROM sales.customers;

-- SUM
SELECT SUM(price) as TotalProductValue
FROM sales.Products;

-- AVERAGE
SELECT avg(salary) as AverageSalary
FROM sales.Employees;

-- MAXIMUM and MINIMUM
SELECT MAX(price) as HighestPrice , MIN(price) as LowestPrice 
FROM sales.Products;

====================================================================================================

-- GROUP BY
SELECT Category, count(*) as TotalProducts
FROM sales.Products 
GROUP BY Category;

-- HAVING Clause
SELECT Category, AVG(price) as AvgPrice
FROM sales.Products 
GROUP BY Category
HAVING AVG(price) > 10000;

===============================================================================================================
--------------------------------------------- JOINS -----------------------------------------------------------

--INNER JOIN
SELECT o.orderid, c.customername, o.orderstatus
from sales.orders as o
INNER JOIN sales.customers as c
    ON o.customerid = c.customerid;

-- LEFT JOIN
SELECT c.customername, o.orderid
from sales.customers as c
LEFT JOIN sales.orders as o
    ON c.customerid = o.customerid;

-- RIGHT JOIN
SELECT o.orderid, e.EmployeeName
from sales.orders as o
RIGHT JOIN sales.Employees as e
    ON o.employeeid = e.employeeid;

-- FULL OUTER JOIN
SELECT c.CustomerName, o.OrderID
FROM sales.Customers as c
FULL OUTER JOIN sales.Orders as o
    ON c.CustomerID = o.CustomerID;

-- Multiple Table JOIN
SELECT o.orderid, o.OrderDate, c.CustomerName, p.ProductName, od.Quantity, e.EmployeeName
FROM sales.Orders as o
INNER JOIN sales.Customers as c
    ON o.CustomerID = c.CustomerID
INNER JOIN sales.OrderDetails as od
    ON o.OrderID = od.OrderID
INNER JOIN sales.Products as p
    ON od.ProductID = p.ProductID
INNER JOIN sales.Employees as e
    ON o.EmployeeID = e.EmployeeID;

===============================================================================================================
-------------------------------------------- Subquery ---------------------------------------------------------

SELECT * FROM sales.Products
WHERE Price > (SELECT AVG(Price) FROM sales.Products);

-- Subquery with IN
SELECT * FROM sales.Customers
WHERE CustomerID IN (SELECT CustomerID FROM sales.Orders);

===============================================================================================================
---------------------------------------- Window Functions -----------------------------------------------------

-- ROW_NUMBER
SELECT ProductName, Category, Price,
    ROW_NUMBER() OVER(PARTITION BY Category ORDER BY Price DESC) AS RowNum
FROM sales.Products;

-- RANK
SELECT EmployeeName, Salary,
    RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
FROM sales.Employees;

-- DENSE_RANK
SELECT EmployeeName, Salary,
    DENSE_RANK() OVER(ORDER BY Salary DESC) AS DenseRankValue
FROM sales.Employees;

-- LAG
SELECT OrderID, OrderDate,
    LAG(OrderDate) OVER(ORDER BY OrderDate DESC) AS PreviousOrderDate
FROM sales.Orders;

-- LEAD
SELECT OrderID, OrderDate,
    LEAD(OrderDate) OVER(ORDER BY OrderDate DESC) AS NextOrderDate
FROM sales.Orders;  


===============================================================================================================
----------------------------------------------- View ----------------------------------------------------------

-- Creating View:
create view vw_CustomerDetails as 
SELECT CustomerID, CustomerName, City, StateName, Email
FROM sales.Customers;

SELECT * from vw_CustomerDetails;

-- View with WHERE Clause
CREATE VIEW vw_ExpensiveProducts as
SELECT ProductID, ProductName, Category, Price, Brand
FROM sales.Products
WHERE Price > 20000;

SELECT * FROM vw_ExpensiveProducts;

-- View with JOIN:
CREATE VIEW vw_OrderSummary as 
SELECT o.OrderID, c.CustomerName, e.EmployeeName, o.OrderStatus, o.PaymentMode
FROM sales.Customers as c
INNER JOIN sales.Orders as o
    ON c.CustomerID = o.CustomerID
INNER JOIN sales.Employees as e
    ON o.EmployeeID = e.EmployeeID;

SELECT * FROM vw_OrderSummary;


===============================================================================================================
--------------------------------------------- Variable --------------------------------------------------------

-- Creating Variable:
Declare @MinSalary money

-- Assigning Value:
SET @MinSalary = 50000

-- Print Output:
SELECT * from sales.Employees
WHERE Salary >= @MinSalary

---------------------------------------------------
-- Creating a Variable:
Declare @CityName varchar(20)

-- Assigning Value:
SET @CityName = 'Delhi'

-- Print Output:
SELECT CustomerName , 'Customer belongs to ' + @CityName as Message
from sales.Customers
WHERE City = @CityName

---------------------------------------------------
-- Creating a Variable:
Declare @CategoryName varchar(20)

-- Assigning Value:
SET @CategoryName = 'Electronics'

-- Print Output:
SELECT ProductName, Price,
    CASE 
        WHEN Price > 50000 THEN (Price * 0.90)
        ELSE Price
    END as DiscountPrice
FROM sales.Products
WHERE Category = @CategoryName
