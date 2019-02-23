--Problem 1
CREATE PROCEDURE dbo.usp_GetEmployeesSalaryAbove35000
AS
  SELECT FirstName, LastName
  FROM Employees
  WHERE Salary > 35000

EXEC dbo.usp_GetEmployeesSalaryAbove35000

GO
--Problem 2
CREATE PROC dbo.usp_GetEmployeesSalaryAboveNumber 
       @SalaryLimit DECIMAL(18,4)
AS
  SELECT FirstName,LastName
  FROM Employees
  WHERE Salary >= @SalaryLimit

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100

GO
--Problem 3
CREATE PROC usp_GetTownsStartingWith
     @TownStartsWith nvarchar(10)
AS
   SELECT [Name] as Town
   FROM Towns
   WHERE [Name] LIKE @TownStartsWith + '%'

EXEC usp_GetTownsStartingWith 'b'
