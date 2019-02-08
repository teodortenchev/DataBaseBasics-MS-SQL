--2. Find All Information About Departments
SELECT * FROM Departments

--3. Find all Department Names
SELECT [Name] FROM Departments

--4. Find the Salary of Each Employee
SELECT FirstName, LastName, Salary
FROM Employees

--5. Find the Full Name of Each Employee
SELECT FirstName, MiddleName, LastName
FROM Employees

--6. Find the Email Address of Each Employee
SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address]
FROM Employees

--7. Find All Different Employee’s Salaries
SELECT DISTINCT Salary
FROM Employees

--8.	Find all Information About Employees
--Write a SQL query to find all information about the employees whose job title is “Sales Representative”. 

SELECT *
	FROM Employees
WHERE JobTitle = 'Sales Representative'

--9.	Find Names of All Employees by Salary in Range
--Write a SQL query to find the first name, last name and job title of all employees whose salary is in the range [20000, 30000].

SELECT FirstName, LastName, JobTitle
	FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

--10.	 Find Names of All Employees 
--Write a SQL query to find the full name of all employees whose salary is 25000, 14000, 12500 or 23600. Full Name is combination of first, middle and last name (separated with single space) and they should be in one column called “Full Name”.

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
	FROM Employees
WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

--11.	 Find All Employees Without Manager
--Write a SQL query to find first and last names about those employees that do not have a manager. 

SELECT FirstName, LastName
	FROM Employees
WHERE ManagerID IS NULL

--12.	 Find All Employees with Salary More Than 50000
--Write a SQL query to find first name, last name and salary of those employees who has salary more than 50000. Order them in decreasing order by salary. 

SELECT FirstName, LastName, Salary
	FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

--13.	 Find 5 Best Paid Employees.
--Write SQL query to find first and last names about 5 best paid Employees ordered descending by their salary.

SELECT TOP(5) FirstName, LastName
	FROM Employees
ORDER BY Salary DESC

--14.	Find All Employees Except Marketing
--Write a SQL query to find the first and last names of all employees whose department ID is different from 4.

SELECT FirstName, LastName
	FROM Employees
WHERE DepartmentID != 4

--15.	Sort Employees Table
--	Write a SQL query to sort all records in the Employees table by the following criteria: 
--		•	First by salary in decreasing order
--		•	Then by first name alphabetically
--		•	Then by last name descending
--		•	Then by middle name alphabetically

SELECT * FROM Employees
ORDER BY Salary DESC, FirstName, LastName DESC, MiddleName

--16.	 Create View Employees with Salaries
--Write a SQL query to create a view V_EmployeesSalaries with first name, last name and salary for each employee.
GO

CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName, LastName, Salary
FROM Employees

GO

SELECT * FROM V_EmployeesSalaries

--17.	Create View Employees with Job Titles
--Write a SQL query to create view V_EmployeeNameJobTitle with full employee name and job title. When middle name is NULL replace it with empty string (‘’).

GO

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + 
	(SELECT MiddleName = 

	CASE
		WHEN MiddleName IS NULL THEN ''
		ELSE MiddleName
	END


) + ' ' + LastName AS [Full Name], JobTitle AS [Job Title]
FROM Employees

GO

SELECT * FROM V_EmployeeNameJobTitle

--17.	Create View Employees with Job Titles V2

GO
CREATE VIEW V_EmployeeNameJobTitle_V2 AS
	SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' +
									 LastName AS [FullName], JobTitle AS [Job Title]
FROM Employees			

GO


--18.	 Distinct Job Titles
--Write a SQL query to find all distinct job titles.

SELECT DISTINCT JobTitle
FROM Employees

--19.	Find First 10 Started Projects
--Write a SQL query to find first 10 started projects. Select all information about them and sort them by start date, then by name.


SELECT TOP(10) ProjectID AS ID, [Name], [Description], StartDate, EndDate
FROM Projects
ORDER BY StartDate, [Name]

--20.	 Last 7 Hired Employees
--Write a SQL query to find last 7 hired employees. Select their first, last name and their hire date.

SELECT TOP (7) FirstName, LastName, HireDate
FROM Employees
ORDER BY HireDate DESC

--21.	Increase Salaries
--Write a SQL query to increase salaries of all employees that are in the Engineering, Tool Design, Marketing or Information Services department by 12%. Then select Salaries column from the Employees table. After that exercise restore your database to revert those changes.

UPDATE Employees
		SET Salary -= Salary * 0.12
	WHERE DepartmentID = 1 OR DepartmentID = 2 OR DepartmentID = 4 OR DepartmentID = 11


	SELECT Salary FROM Employees
	WHERE DepartmentID = 1 OR DepartmentID = 2 
								OR DepartmentID = 4 OR DepartmentID = 11
	
