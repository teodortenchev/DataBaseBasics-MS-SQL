--P18Basic Insert
USE Softuni 

INSERT INTO Towns VALUES
('Sofia'), ('Plovdiv'), ('Varna'), ('Burgas')

INSERT INTO Departments VALUES
('Engineering'),('Sales'),('Marketing'),('Software Development'),('Quality Assurance')

ALTER TABLE Employees
ALTER COLUMN AddressId INT

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DeparmentId, HireDate, Salary) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, CONVERT(datetime, 01/02/2013, 103), 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, CONVERT(datetime, 02/03/2004, 103), 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, CONVERT(datetime, 28/08/2016, 103), 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, CONVERT(datetime, 09/12/2007, 103), 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, CONVERT(datetime, 28/08/2016, 103), 599.88)

--P19 Basic Select All Fields

--P20 Select all and order
USE Softuni

SELECT * FROM Towns
	ORDER BY [Name] ASC --optional as this is the default
SELECT * FROM Departments
	ORDER BY [Name] ASC
SELECT * FROM Employees
	ORDER BY [Salary] DESC

--P21 Select Some Fields

SELECT [NAME] FROM Towns 
	ORDER BY [Name]
SELECT [NAME] FROM Departments
	ORDER BY [Name]
SELECT FirstName, LastName, JobTitle, Salary FROM Employees
	ORDER BY [Salary] DESC