--Problem 1
CREATE PROCEDURE dbo.usp_GetEmployeesSalaryAbove35000
AS
  SELECT FirstName, LastName
  FROM Employees
  WHERE Salary > 35000

EXEC dbo.usp_GetEmployeesSalaryAbove35000

--Problem 2