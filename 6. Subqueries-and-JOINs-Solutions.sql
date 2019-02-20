--Problem 1
    SELECT TOP (5) emp.EmployeeID, emp.JobTitle, emp.AddressId, adr.AddressText
		  FROM Employees as emp
INNER JOIN Addresses AS adr
        ON emp.AddressID = adr.AddressID
				ORDER BY emp.AddressID

--Problem 2
    SELECT TOP (50) emp.FirstName, emp.LastName, t.[Name], adr.AddressText
		  FROM Employees as emp
INNER JOIN Addresses AS adr
        ON emp.AddressID = adr.AddressID
INNER JOIN Towns as t
        ON adr.TownID = t.TownID 
	ORDER BY emp.FirstName, emp.LastName

--Problem 3

    SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name]
      FROM Employees as e
INNER JOIN Departments as d
	      ON e.DepartmentID = d.DepartmentID
		 WHERE d.Name = 'Sales'

--Problem 4

SELECT TOP(5) e.EmployeeID, e.FirstName, Salary, d.[Name]
		     FROM Employees AS e
		     JOIN Departments as d
			     ON e.DepartmentID = d.DepartmentID
        WHERE e.Salary > 15000
     ORDER BY d.DepartmentID

--Problem 5
  SELECT TOP(3) e.EmployeeID, e.FirstName
           FROM Employees as e
LEFT OUTER JOIN EmployeesProjects as ep ON e.EmployeeID = ep.EmployeeID
          WHERE ep.ProjectID IS NULL

--Problem 6
  SELECT e.FirstName, e.LastName, e.HireDate, d.[Name]
    FROM Employees AS e
    JOIN Departments as d ON e.DepartmentID = d.DepartmentID
   WHERE d.Name IN ('Sales', 'Finance') AND e.HireDate > '1.1.1999'
ORDER BY e.HireDate

--Problem 7
SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name]
         FROM Employees as e
         JOIN EmployeesProjects as ep ON e.EmployeeID = ep.EmployeeID
         JOIN Projects as p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '08.13.2002' AND p.EndDate IS NULL

--Problem 8 v1
SELECT e.EmployeeID, e.FirstName, 
  CASE
  WHEN YEAR(p.StartDate) >= 2005 THEN NULL
  ELSE p.[Name]
  END
  FROM Employees as e
  JOIN EmployeesProjects as ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects as p 
    ON ep.ProjectID = p.ProjectID
 WHERE e.EmployeeID = 24

--Problem 8 v2
SELECT e.EmployeeID, e.FirstName, 
  IIF(YEAR(p.StartDate) >= 2005, NULL, p.[Name])
  FROM Employees as e
  JOIN EmployeesProjects as ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects as p 
    ON ep.ProjectID = p.ProjectID
 WHERE e.EmployeeID = 24

--Problem 9
  SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName
    FROM Employees AS e
    JOIN Employees AS m ON m.EmployeeID = e.ManagerID
   WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

