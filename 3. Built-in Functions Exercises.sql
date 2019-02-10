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
