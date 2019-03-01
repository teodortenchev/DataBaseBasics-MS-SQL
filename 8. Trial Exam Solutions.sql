--Section 1 - Data Definition Language (30pts)
CREATE DATABASE Supermarket
USE Supermarket

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

--Section 2. Data Manipulation Language (10 pts)
--Problem 2. Insert

INSERT INTO Employees (FirstName,LastName,Phone,Salary) VALUES
('Stoyan','Petrov','888-785-8573',500.25),
('Stamat','Nikolov','789-613-1122',999995.25),
('Evgeni','Petkov','645-369-9517',1234.51),
('Krasimir','Vidolov','321-471-9982',50.25)

INSERT INTO Items (Name, Price, CategoryId) VALUES
('Tesla battery',154.25,8),
('Chess',30.25,8),
('Juice',5.32,1),
('Glasses',10,8),
('Bottle of water',1,1)

--Problem 3. Update
UPDATE Items SET Price *= 1.27 WHERE CategoryId IN (1,2,3)


--Problem 4. Delete
DELETE FROM OrderItems WHERE OrderId = 48

--Section 3. Querying (40 pts)
--P5. Richest PEOPLE

SELECT Id, FirstName FROM Employees WHERE Salary > 6500 ORDER BY FirstName, Id

--P6. Cool Phone Numbers
  SELECT FirstName + ' ' + LastName AS [Full Name], Phone 
    FROM Employees 
   WHERE Phone LIKE '3%' 
ORDER BY FirstName, Phone

--P7. Employee Statistics
SELECT e.FirstName, e.LastName, COUNT(o.ID) AS Count FROM Employees AS e
JOIN Orders AS o ON o.EmployeeId = e.Id
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY COUNT(o.ID) DESC, e.FirstName

--P8. Hard Workers Club
SELECT h.FirstName, h.LastName, AVG(h.[Total hours]) as [Work hours]
FROM (
      SELECT e.Id, e.FirstName, e.LastName, 
             DATEDIFF(HOUR, s.CheckIn, s.CheckOut) as [Total hours] 
        FROM Employees as e
        JOIN Shifts as s ON s.EmployeeId = e.Id
      ) as h
GROUP BY h.Id, h.FirstName, h.LastName
HAVING AVG(h.[Total hours]) > 7
ORDER BY [Work hours] DESC, h.Id

--P9. The most expensive order
SELECT TOP(1) oi.OrderId, SUM(i.Price * oi.Quantity) as [Total Price] FROM OrderItems as oi
JOIN Items as i ON i.Id = oi.ItemId
GROUP BY oi.OrderId
ORDER BY SUM(i.Price * oi.Quantity) DESC

--P10. Rich Item, Poor Item
SELECT TOP(10) oi.OrderId, MAX(i.Price) AS [ExpensivePrice], MIN(i.Price) AS [CheapPrice] FROM OrderItems as oi
JOIN Items as i ON i.Id = oi.ItemId
GROUP BY oi.OrderId
ORDER BY [ExpensivePrice] DESC, oi.OrderId

--P11. Cashiers
SELECT e.Id, e.FirstName, e.LastName FROM Employees as e
JOIN Orders as o ON o.EmployeeId = e.Id
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY e.Id

--P12. Lazy Employees