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

GO
--Problem 4
CREATE PROC usp_GetEmployeesFromTown 
    @TownName varchar(30)
AS
    SELECT e.FirstName, e.LastName
    FROM Employees as e
    JOIN Addresses as a ON a.AddressID = e.AddressID
    JOIN Towns as t ON t.TownID = a.TownID
    WHERE t.[Name] = @TownName

EXEC usp_GetEmployeesFromTown 'Sofia'

GO
--Problem 5
CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4)) 
       RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @salaryLevel VARCHAR(10);
    IF(@Salary < 30000)
      SET @salaryLevel = 'Low';
    ELSE IF(@Salary <= 50000)
      SET @salaryLevel = 'Average';
    ELSE 
      SET @salaryLevel = 'High';

    RETURN @salaryLevel;
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary)
FROM Employees

GO
--Problem 6
CREATE PROC usp_EmployeesBySalaryLevel 
    @SalaryLevel VARCHAR(10)
AS
  SELECT FirstName, LastName
  FROM Employees
  WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

EXEC usp_EmployeesBySalaryLevel 'High'

GO
--Problem 7
CREATE FUNCTION ufn_IsWordComprised(@SetOfLetters VARCHAR(15), @Word VARCHAR(20))
      RETURNS BIT
AS
BEGIN
    DECLARE @counter INT = 1
    WHILE @counter <= LEN(@Word)
    BEGIN
      DECLARE @currentLetter CHAR(1) = SUBSTRING(@Word,@counter,1)
      DECLARE @charIndex INT = CHARINDEX(@currentLetter, @SetOfLetters)
      
      IF(@charIndex = 0)
        BEGIN
          RETURN 0
        END

      SET @counter += 1
    END

  
    RETURN 1
END


SELECT FirstName FROM Employees
WHERE dbo.ufn_IsWordComprised('oistmiahf', FirstName) = 1

GO
--Problem 8
--alter table Departments to allow null in ManagerID
--Delete employees from EmployeesProjects
--update departments set managerid column = null
--delete from employees where depID = dep
--delete from dep where id = @id

CREATE OR ALTER PROC usp_DeleteEmployeesFromDepartment 
       @DepartmentID INT
AS
    ALTER TABLE Departments
    ALTER COLUMN ManagerID INT NULL

    DELETE FROM EmployeesProjects WHERE EmployeeID IN
        (SELECT EmployeeID FROM Employees WHERE DepartmentID = @DepartmentID)

    UPDATE Departments
    SET ManagerID = NULL
    WHERE DepartmentID = @DepartmentID

    UPDATE Employees
    SET ManagerID = NULL
    WHERE ManagerID IN 
        (SELECT EmployeeID FROM Employees WHERE DepartmentID = @DepartmentID)

    DELETE FROM Employees WHERE DepartmentID = @DepartmentID

    DELETE FROM Departments WHERE DepartmentID = @DepartmentID

    SELECT COUNT(*)
    FROM Employees
    WHERE DepartmentID = @DepartmentID

EXEC usp_DeleteEmployeesFromDepartment 1

