-- Create database and tables for demo
CREATE DATABASE SalesDB;
GO

USE SalesDB;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Region NVARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderLines (
    OrderLineID INT PRIMARY KEY,
    OrderID INT,
    Product NVARCHAR(100),
    Quantity INT,
    LineTotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Sample data
INSERT INTO Customers VALUES (1, 'Alice', 'North'), (2, 'Bob', 'South');
INSERT INTO Orders VALUES (101, 1, '2023-01-10'), (102, 2, '2023-01-15');
INSERT INTO OrderLines VALUES (1001, 101, 'Widget', 2, 50.00), (1002, 102, 'Gadget', 1, 75.00);
