--Problem 1
SELECT COUNT(*) AS [Count]
FROM WizzardDeposits

--Problem 2
SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

--Problem 3
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

--Problem 4
SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--Problem 5
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

--Problem 6
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family'

--Problem 7
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
HAVING MagicWandCreator = 'Ollivander family' AND SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

--Problem 8
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

--Problem 9
SELECT [AgeGroup] =
	(
		CASE
			WHEN AGE BETWEEN 0 AND 20 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'	
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'	
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'		
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'	
			WHEN Age >= 61 THEN '[61+]'		
		END	
	) , [WizardCount] = COUNT(*)
FROM WizzardDeposits
GROUP BY (
		CASE
			WHEN AGE BETWEEN 0 AND 20 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'	
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'	
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'		
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'	
			WHEN Age >= 61 THEN '[61+]'		
		END	
	)
	
--Problem 10
SELECT LEFT(FirstName, 1) 
FROM WizzardDeposits
GROUP BY LEFT(FirstName, 1), DepositGroup
HAVING DepositGroup = 'Troll Chest'
ORDER BY LEFT(FirstName, 1)

--Problem 11
SELECT DepositGroup, IsDepositExpired, FORMAT(AVG(DepositInterest), 'N2') AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC

--Problem 12
SELECT SUM(wd.Diff) AS SumDifference
FROM (
SELECT DepositAmount - LEAD(DepositAmount, 1) OVER (ORDER BY Id) AS [Diff]
	FROM WizzardDeposits) AS wd

--Problem 12 v2
SELECT SUM(final.Diff)
  FROM(
   SELECT wd1.DepositAmount - (SELECT wd2.DepositAmount FROM WizzardDeposits AS wd2 WHERE Id = wd1.Id + 1) AS [Diff]
 FROM WizzardDeposits AS wd1) AS final

--Problem 13
SELECT DepartmentID, Sum(Salary) 
  FROM Employees
 GROUP BY DepartmentID

--Problem 14

SELECT DepartmentId, MIN(Salary)
  FROM Employees
	WHERE HireDate > 01/01/2000
 GROUP BY DepartmentID
 HAVING DepartmentID IN (2, 5, 7)

--Problem 15
SELECT * INTO NewEmployees
  FROM Employees
 WHERE Salary > 30000

DELETE FROM NewEmployees WHERE ManagerID = 42

UPDATE NewEmployees
 SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary)
 FROM NewEmployees
 GROUP BY DepartmentID

--Problem 16
SELECT DepartmentID, MAX(Salary) AS [MaxSalary]
  FROM Employees
 GROUP BY DepartmentID
  HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--Problem 17
SELECT COUNT(Salary)
 FROM Employees
WHERE ManagerID IS NULL

--Problem 18
SELECT DISTINCT DepartmentId, Salary AS [ThirdHighestSalary] FROM 
(
SELECT DepartmentID, DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank], Salary
FROM Employees) AS RankedSalaries
 WHERE RankedSalaries.Rank = 3

--Problem 19
SELECT TOP(10) FirstName, LastName, DepartmentID
 FROM Employees  AS b
  WHERE b.Salary > (SELECT AVG(Salary)
     FROM Employees AS a
		 WHERE a.DepartmentID = b.DepartmentID
		 
		  )
ORDER BY DepartmentID
