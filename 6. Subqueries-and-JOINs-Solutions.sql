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

--Problem 10 (Concat_WS is not a recognized internal function)
SELECT TOP(50) e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName,
               CONCAT_WS(' ', m.FirstName, m.LastName) AS EmployeeName, d.[Name] AS DepartmentName
          FROM Employees AS e
          JOIN Employees AS m ON e.ManagerID = m.EmployeeID
          JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
      ORDER BY e.EmployeeID 

--Problem 11
  SELECT MIN(AverageSalary) 
    FROM (SELECT AVG(Salary) AS AverageSalary FROM Employees
GROUP BY DepartmentID) AS AvgSalaries

--Problem 12
  SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
    FROM Peaks as p
    JOIN Mountains as m ON m.Id = p.MountainId
    JOIN MountainsCountries as mc ON mc.MountainId = m.Id
    JOIN Countries as c ON c.CountryCode = mc.CountryCode
   WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--Problem 13
  SELECT mc.CountryCode, COUNT(*) AS MountainRanges
    FROM Mountains AS m
    JOIN MountainsCountries mc on m.ID = mc.MountainId
   WHERE mc.CountryCode IN ('US','RU','BG')
GROUP BY mc.CountryCode


--Problem 14
  SELECT TOP(5) c.CountryName, r.RiverName
           FROM Countries AS c
LEFT OUTER JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT OUTER JOIN Rivers AS r ON r.Id = cr.RiverId
          WHERE c.ContinentCode = 'AF'
          ORDER BY c.CountryName
--Problem 15
SELECT ContinentCode, CurrencyCode, CurrencyUsage 
FROM
(SELECT ContinentCode, CurrencyCode, 
COUNT(CurrencyCode) AS CurrencyUsage, DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS [Rank]
FROM Countries
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(CurrencyCode) >1
) AS RankedCurrencies
WHERE RankedCurrencies.Rank = 1
ORDER BY ContinentCode, CurrencyUsage

--Problem 16
SELECT COUNT(*) 
  FROM Countries AS c
  LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
 WHERE MountainId IS NULL

--Problem 17
SELECT TOP(5) c.CountryName, MAX(p.Elevation) as HighestPeakElevation, 
              MAX(r.Length) as LongestRiverLength
         FROM Countries as c
    LEFT JOIN MountainsCountries as mc ON mc.CountryCode = c.CountryCode
    LEFT JOIN Mountains as m ON m.Id = mc.MountainId
    LEFT JOIN Peaks as p ON p.MountainId = m.Id
    LEFT JOIN CountriesRivers as cr ON cr.CountryCode = c.CountryCode
    LEFT JOIN Rivers as r ON r.Id = cr.RiverId
     GROUP BY c.CountryName
     ORDER BY HighestPeakElevation DESC, c.CountryName

--Problem 18
SELECT TOP(5) k.CountryName, IIF(k.PeakName IS NULL, '(no highest peak)', k.PeakName),
       IIF(k.MaxElevation IS NULL, 0, k.MaxElevation), 
       IIF(k.MountainRange IS NULL, '(no mountain)', k.MountainRange)
FROM
(SELECT  c.CountryName,
              MAX(p.Elevation) AS MaxElevation,
              p.PeakName, m.MountainRange, DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY MAX(p.Elevation) DESC) AS ElevationRank
         FROM Countries as c
    LEFT JOIN MountainsCountries as mc ON mc.CountryCode = c.CountryCode
    LEFT JOIN Mountains as m ON m.Id = mc.MountainId
    LEFT JOIN Peaks as p ON p.MountainId = m.Id
     GROUP BY c.CountryName, p.PeakName, p.Elevation, m.MountainRange
    ) as k
     WHERE k.ElevationRank = 1
     ORDER BY k.CountryName, k.PeakName
     