--Problem 1: Employee Address
    SELECT TOP (5) emp.EmployeeID, emp.JobTitle, emp.AddressId, adr.AddressText
		  FROM Employees as emp
INNER JOIN Addresses AS adr
        ON emp.AddressID = adr.AddressID
				ORDER BY emp.AddressID

--Problem 2
