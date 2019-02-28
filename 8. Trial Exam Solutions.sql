--Section 1 - Data Definition Language (30pts)
CREATE DATABASE Supermarket

CREATE TABLE Categories(
        Id INT PRIMARY KEY IDENTITY,
        [Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Items(
        Id INT PRIMARY KEY IDENTITY,
        [Name] NVARCHAR(30) NOT NULL,
        Price DECIMAL(14,2) NOT NULL,
        CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL
)

CREATE TABLE Employees(
        Id INT PRIMARY KEY IDENTITY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Phone VARCHAR(12) NOT NULL,
        Salary DECIMAL(14,2) NOT NULL
)

CREATE TABLE Orders(
        Id INT PRIMARY KEY IDENTITY,
        [DateTime] DateTime NOT NULL,
        EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL
)

CREATE TABLE OrderItems(
        OrderId INT FOREIGN KEY REFERENCES Orders(Id) NOT NULL,
        ItemId INT FOREIGN KEY REFERENCES Items(Id) NOT NULL,
        Quantity INT NOT NULL,
        PRIMARY KEY (OrderId, ItemID),
        CONSTRAINT UC_QuantityCheck Check (Quantity > 0)
)

CREATE TABLE Shifts(
         Id INT IDENTITY NOT NULL,
         EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
         CheckIn DATETIME NOT NULL,
         CheckOut DATETIME NOT NULL,
         PRIMARY KEY (Id, EmployeeId),
         CONSTRAINT CH_CheckOutAfterCheckIn CHECK (CheckOut > CheckIn)
         
)

