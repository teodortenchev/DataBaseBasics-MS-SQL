--Problem 1
USE SoftUni
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

GO
--Problem 9
USE Bank

CREATE PROC usp_GetHoldersFullName
AS
  SELECT FirstName + ' ' + LastName AS [Full Name]
  FROM AccountHolders

GO
--Problem 10
CREATE PROC usp_GetHoldersWithBalanceHigherThan
        @BalanceLimit MONEY
AS
SELECT k.FirstName, k.LastName
FROM (
  SELECT ah.FirstName, ah.LastName
  FROM AccountHolders AS ah
  JOIN Accounts AS a ON a.AccountHolderId = ah.Id
  GROUP BY ah.ID, ah.FirstName, ah.LastName
  HAVING SUM(a.Balance) > @BalanceLimit ) as k
ORDER BY k.FirstName, k.LastName

EXEC usp_GetHoldersWithBalanceHigherThan 1000000

GO
--Problem 11
CREATE FUNCTION ufn_CalculateFutureValue 
                (@InitialSum DECIMAL(18,4), @YearlyInterestRate FLOAT, @YearsCount INT)
RETURNS DECIMAL(18,4)

BEGIN
  DECLARE @futureValue DECIMAL(18,4)
  SET @futureValue = @InitialSum * (POWER((1 + @YearlyInterestRate), @YearsCount))

  RETURN @futureValue
END

SELECT dbo.ufn_CalculateFutureValue (1000, 0.1, 5)

GO
--Problem 12
CREATE PROC usp_CalculateFutureValueForAccount 
            @AccountId INT, @InterestRate FLOAT
AS
SELECT a.AccountHolderId as [Account Id], ah.FirstName as [First Name], 
       ah.LastName as [Last Name], a.Balance as [Current Balance],
       dbo.ufn_CalculateFutureValue (a.Balance, @InterestRate, 5) as [Balance in 5 years]
FROM Accounts as a
JOIN AccountHolders ah ON ah.Id = a.AccountHolderId
WHERE a.Id = @AccountId


EXEC usp_CalculateFutureValueForAccount 1, 0.1

GO
--Problem 13
USE Diablo
GO

CREATE FUNCTION ufn_CashInUsersGames (@GameName NVARCHAR(50))
RETURNS TABLE AS

RETURN
(
    SELECT SUM(k.Cash) AS SumCash
    FROM (
    SELECT g.Name, ug.Cash, ROW_NUMBER() OVER(ORDER BY ug.Cash DESC) AS [Row]
    FROM Games AS g
    JOIN UsersGames AS ug ON ug.GameId = g.Id
    WHERE g.[Name] = @GameName) AS k
    WHERE k.[Row] % 2 = 1
    
)

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')
GO
--Problem 14

CREATE TABLE Logs (
             LogID INT PRIMARY KEY IDENTITY,
             AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
             OldSum DECIMAL(15,2),
             NewSum DECIMAL(15,2),
             )
GO

CREATE TRIGGER tr_AccountSumUpdate ON Accounts FOR UPDATE
AS
   DECLARE @newSum DECIMAL(15,2) = (SELECT Balance FROM inserted)
   DECLARE @oldSum DECIMAL(15,2) = (SELECT Balance FROM deleted)
   DECLARE @accountId INT = (SELECT Id FROM inserted)
   INSERT INTO Logs VALUES
   (@accountID, @oldSum, @newSum)
   
GO
--Problem 15
CREATE TABLE NotificationEmails (
             Id INT PRIMARY KEY IDENTITY,
             Recipient INT,
             [Subject] VARCHAR(100),
             Body VARCHAR(150)
)
GO

CREATE TRIGGER tr_EmailOnBalanceChange ON Logs AFTER INSERT
AS
  DECLARE @accountId INT = (SELECT AccountId FROM inserted)
  DECLARE @oldSum DECIMAL(15,2) = (SELECT OldSum FROM inserted)
  DECLARE @newSum DECIMAL(15,2) = (SELECT NewSum FROM inserted)
  DECLARE @subject VARCHAR(100) = 'Balance change for account: ' + CAST(@accountId AS VARCHAR(10))
  DECLARE @currentTime DATETIME = GETDATE()
  DECLARE @body VARCHAR(150) = ('On ' + CAST(@currentTime AS VARCHAR(18)) + ' your balance was changed from '
                + CAST(@oldSum AS VARCHAR(18)) + ' to ' + CAST(@newSum AS VARCHAR(18)) + '.')

  INSERT INTO NotificationEmails (Recipient, [Subject], Body) VALUES
  (@accountId, @subject, @body)

  GO
  --Problem 16
  CREATE OR ALTER PROC usp_DepositMoney 
                    @AccountID INT, @MoneyAmount DECIMAL(16,4)
AS 
  BEGIN TRANSACTION
  
  DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @AccountID)

  IF (@account is NULL)
    BEGIN
      ROLLBACK
      RAISERROR('Account does not exist', 16, 1)
    RETURN
    END
  IF (@MoneyAmount < 0)
    BEGIN 
      ROLLBACK
      RAISERROR('Can only deposit a positive amount.', 16, 2)
      RETURN
    END

   UPDATE Accounts SET Balance += @MoneyAmount WHERE Id = @AccountID
  COMMIT

SELECT * FROM Accounts WHERE Id = 1
exec dbo.usp_DepositMoney 1, 10

--Problem 17
CREATE PROC usp_WithdrawMoney
                  @AccountID INT, @MoneyAmount DECIMAL(16,4)
AS
  BEGIN TRANSACTION
    DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @AccountID)
    DECLARE @balance DECIMAL(16,4) = (SELECT Balance FROM Accounts WHERE Id = @AccountID)

    IF(@account IS NULL)
      BEGIN
        ROLLBACK
        RAISERROR('Account does not exist', 16, 1)
        RETURN
      END
    IF(@MoneyAmount <= 0)
      BEGIN
        ROLLBACK
        RAISERROR('Cannot withdral 0 or negative amount', 16, 2)
        RETURN
      END
    IF(@MoneyAmount > @balance)
      BEGIN
        ROLLBACK
        RAISERROR('Insufficient funds. Withdrawal failed.', 16, 2)
        RETURN
      END
    
    UPDATE Accounts SET Balance -= @MoneyAmount WHERE Id = @AccountID
  COMMIT

GO
--Problem 18
CREATE PROC usp_TransferMoney
                @SenderId INT, @ReceiverID INT, @Amount DECIMAL(16,4)
AS
  BEGIN TRANSACTION
  DECLARE @senderAccount INT = (SELECT Id FROM Accounts WHERE Id = @SenderId)
  DECLARE @recipientAccount INT = (SELECT Id FROM Accounts WHERE Id = @ReceiverID)

  IF(@senderAccount IS NULL)
    BEGIN
        ROLLBACK
        RAISERROR('Sender does not exist', 16, 2)
        RETURN
    END
  IF(@recipientAccount IS NULL)
    BEGIN
        ROLLBACK
        RAISERROR('Recipient does not exist', 16, 2)
        RETURN
    END

  EXECUTE dbo.usp_WithdrawMoney @SenderID, @Amount
  EXECUTE dbo.usp_DepositMoney @ReceiverID, @Amount

  COMMIT

EXECUTE usp_TransferMoney 5, 1, 5000

SELECT * FROM Accounts WHERE Id IN (1,5)

--Problem 21
CREATE PROC usp_AssignProject
                      @EmployeeID INT, @ProjectID INT
AS
  BEGIN TRANSACTION
    INSERT INTO EmployeesProjects VALUES
    (@EmployeeID, @ProjectID)
    
    DECLARE @projectsCount INT = (
    SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @EmployeeID)

    IF(@projectsCount > 3)
      BEGIN
        ROLLBACK
        RAISERROR('The employee has too many projects!', 16, 1)
        RETURN
      END
  COMMIT

--Problem 22
CREATE TRIGGER tr_StoreDeletedEmployees ON Employees AFTER DELETE
AS
  INSERT INTO Deleted_Employees
      SELECT FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary FROM deleted
