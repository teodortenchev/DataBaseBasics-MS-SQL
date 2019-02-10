--Problem 1.	Find Names of All Employees by First Name
--Write a SQL query to find first and last names of all employees whose first name starts with “SA”. 


SELECT FirstName, LastName
		FROM Employees
WHERE FirstName LIKE 'SA%'

--Problem 2.	  Find Names of All employees by Last Name 
--Write a SQL query to find first and last names of all employees whose last name contains “ei”. 

SELECT FirstName, LastName
		FROM Employees
WHERE LastName LIKE '%ei%'

--Problem 3.	Find First Names of All Employees
--Write a SQL query to find the first names of all employees in the departments with ID 3 or 10 and whose hire year is between 1995 and 2005 inclusive.

SELECT FirstName
	FROM Employees
WHERE (DepartmentID = 3 OR DepartmentID = 10) AND 
			DATEPART(YEAR, HireDate) >= 1995 AND DATEPART(YEAR, HireDate) <=2005

--Problem 4.	Find All Employees Except Engineers
--Write a SQL query to find the first and last names of all employees whose job titles does not contain “engineer”. 

SELECT FirstName, LastName
		FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--Problem 5.	Find Towns with Name Length
--Write a SQL query to find town names that are 5 or 6 symbols long and order them alphabetically by town name. 

SELECT [Name] 
FROM Towns 
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

--Problem 6.	 Find Towns Starting With
--Write a SQL query to find all towns that start with letters M, K, B or E. Order them alphabetically by town name

SELECT TownID, [Name] 
FROM Towns 
WHERE [Name] LIKE '[M,K,B,E]%'
ORDER BY [Name]


--Problem 7.	 Find Towns Not Starting With
--Write a SQL query to find all towns that does not start with letters R, B or D. Order them alphabetically by name. 

SELECT TownID, [Name] 
FROM Towns 
WHERE [Name] NOT LIKE '[R,B,D]%'
ORDER BY [Name]

--Problem 8.	Create View Employees Hired After 2000 Year
--Write a SQL query to create view V_EmployeesHiredAfter2000 with first and last name to all employees hired after 2000 year. 

GO

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

GO

SELECT * FROM V_EmployeesHiredAfter2000

--Problem 9.	Length of Last Name
--Write a SQL query to find the names of all employees whose last name is exactly 5 characters long.

SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5
