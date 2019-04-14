--P02 Insert

INSERT INTO Teachers (FirstName, LastName, Address, Phone, SubjectId) VALUES
('Ruthanne','Bamb','84948 Mesta Junction','3105500146',6),
('Gerrard','Lowin','370 Talisman Plaza','3324874824',2),
('Merrile','Lambdin','81 Dahle Plaza','4373065154',5),
('Bert','Ivie','2 Gateway Circle','4409584510',4)

INSERT INTO Subjects ([Name], Lessons) VALUES
('Geometry', 12),
('Health', 10),
('Drama', 7),
('Sports', 9)

--Problem 3. Update
UPDATE StudentsSubjects SET Grade = 6.00 WHERE SubjectId IN (1,2) AND Grade >= 5.50

--Problem 4. Delete
DELETE FROM StudentsTeachers WHERE TeacherId IN (SELECT Id FROM Teachers  WHERE Phone LIKE('%72%'))
DELETE FROM Teachers  WHERE Phone LIKE('%72%')

--Problem 5. Teen Students
SELECT FirstName, LastName, Age FROM Students WHERE Age >=12
ORDER BY FirstName, LastName

--Problem 6. Cool Addresses
SELECT CONCAT(FirstName,' ', MiddleName, ' ', LastName) as [Full Name], Address FROM Students WHERE Address LIKE ('%road%')
ORDER BY FirstName, LastName, [Address]

--Problem 7. Phones
SELECT FirstName, [Address], Phone FROM Students
WHERE MiddleName IS NOT NULL AND Phone LIKE ('42%')
ORDER BY FirstName

--Problem 8. Students Teachers
SELECT FirstName, LastName, COUNT(st.TeacherId) as TeachersCount
FROM Students as s
INNER JOIN StudentsTeachers as st ON st.StudentId = s.Id
GROUP BY FirstName, LastName

--Problem 9. Subjects with Students
SELECT CONCAT(FirstName, ' ', LastName) as FullName, Subjects = (CONCAT(sub.Name,'-',sub.Lessons)), 
STUDENTS = (SELECT COUNT (StudentId) From StudentsTeachers WHERE TeacherId = t.Id)
FROM Teachers as t
INNER JOIN Subjects as sub ON sub.Id = t.SubjectId
INNER JOIN StudentsTeachers as st ON st.TeacherId = t.Id
GROUP BY t.FirstName, t.LastName, sub.[Name], sub.Lessons, t.Id
ORDER BY Students DESC, FullName, Subjects

--Problem 10. Students to Go
SELECT CONCAT(FirstName, ' ', LastName) as [Full Name] FROM Students as s
LEFT JOIN StudentsExams as se on se.StudentId = s.Id
WHERE se.Grade IS NULL
ORDER BY [Full Name]

--Problem 11. Busiest Teachers
SELECT TOP 10 t.FirstName, t.LastName, COUNT(st.StudentId) as StudentsCount From Teachers as t
JOIN StudentsTeachers as st on st.TeacherId = t.Id
GROUP BY t.FirstName, t.LastName
ORDER BY StudentsCount DESC, t.FirstName, t.LastName

--Problem 12. Top Students
SELECT TOP 10 s.FirstName, s.LastName, FORMAT(AVG(e.Grade), 'N2') as Grade FROM Students as s
JOIN StudentsExams as e on e.StudentId = s.Id
GROUP BY s.FirstName, s.LastName
ORDER BY Grade DESC, s.FirstName, s.LastName

--Problem 13. Second highest grade
SELECT b.FirstName, b.LastName, b.Grade
FROM (SELECT s.FirstName as FirstName, s.LastName as LastName, 
ss.Grade as Grade, ROW_NUMBER() OVER (PARTITION BY FirstName, LastName ORDER BY Grade DESC) AS [Rank] 
FROM Students as s
JOIN StudentsSubjects as ss on ss.StudentId = s.Id
) as b
WHERE b.Rank = 2
ORDER BY FirstName, LastName


--Problem 14 Not So In The Studying
SELECT [Full Name] = 
	(
		IIF(MiddleName IS NULL, CONCAT(FirstName, ' ', LastName), CONCAT(FirstName,' ', MiddleName, ' ', LastName)) 
	)
FROM Students as st
LEFT JOIN StudentsSubjects as ss ON ss.StudentId = st.Id
WHERE StudentId IS NULL
ORDER BY [Full Name]

--Problem 15. Top Student Per Teacher
SELECT k.[Teacher Full Name], k.[Subject Name], k.[Student Full Name], k.Grade FROM 
(
 Select b.[Teacher Full Name], b.[Subject Name], b.[Student Full Name], FORMAT(b.Grade, 'N2') as Grade,
ROW_NUMBER() OVER (PARTITION BY b.[Teacher Full Name]  ORDER BY b.Grade DESC) as [Rank]
FROM 
(
	SELECT t.FirstName + ' ' + t.LastName as [Teacher Full Name], 
	sb.Name as [Subject Name], s.FirstName + ' ' + s.LastName as [Student Full Name], AVG(ss.Grade) as Grade
	FROM Teachers as t
	JOIN StudentsTeachers as st on st.TeacherId = t.Id
	JOIN Students as s on s.Id = st.StudentId
	JOIN StudentsSubjects as ss on ss.StudentId = s.Id
	JOIN Subjects as sb on sb.Id = ss.SubjectId AND sb.Id = t.SubjectId
	GROUP BY t.FirstName, t.LastName, s.FirstName, s.LastName, sb.[Name]
) as b
) as k
WHERE k.Rank = 1
ORDER BY k.[Subject Name], k.[Teacher Full Name], k.Grade DESC

--Problem 16 Average Grade Per Subject
SELECT sb.[Name], AVG(ss.Grade) as AverageGrade
FROM Subjects as sb
JOIN StudentsSubjects as ss on ss.SubjectId = sb.Id
GROUP BY sb.[Name], sb.Id
ORDER BY sb.Id

--Problem 17
SELECT k.Quarter, k.SubjectName, COUNT(k.StudentID) as StudentsCount
FROM
 (
 SELECT IIF(e.Date IS NULL, 'TBA', CONCAT('Q', DATEPART(QUARTER, e.Date)))  as [Quarter],
s.[Name] as SubjectName, se.StudentId
FROM Exams as e
JOIN Subjects as s on s.Id = e.SubjectId
JOIN StudentsExams as se on se.ExamId = e.Id
WHERE se.Grade >= 4.00

 ) as k
 GROUP BY Quarter, k.SubjectName
 ORDER BY Quarter

 GO
 --Problem 18
 CREATE FUNCTION dbo.udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(16,2)) 
	RETURNS VARCHAR(100)
AS
	BEGIN
		IF(@grade > 6)
			BEGIN
				RETURN 'Grade cannot be above 6.00!'
			END
		DECLARE @studentNAME NVARCHAR(50) = (SELECT FirstName FROM Students WHERE Id = @studentId)

		IF(@studentNAME IS NULL)
			BEGIN
				RETURN 'The student with provided id does not exist in the school!'
			END

		DECLARE @gradesCount INT = (SELECT COUNT(s.Id) FROM Students as s
									JOIN StudentsExams as ss ON ss.StudentId = s.Id
									WHERE ss.StudentId = @studentId AND ss.Grade BETWEEN @grade AND @grade + 0.5
								)

		
		RETURN 'You have to update ' + CAST(@gradesCount AS VARCHAR(10)) + ' grades for the student ' + @studentNAME
	END 

	GO
SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)

GO
--problem 19

CREATE PROCEDURE usp_ExcludeFromSchool(@StudentId INT) AS
	DECLARE @Student INT = (SELECT Id FROM Students WHERE Id = @StudentId)

	IF(@Student IS NULL)
		BEGIN
			RAISERROR('This school has no student with the provided id!', 16, 1)
			RETURN
		END

	DELETE FROM StudentsExams WHERE StudentId = @StudentId
	DELETE FROM StudentsSubjects WHERE StudentId = @StudentId
	DELETE FROM StudentsTeachers WHERE StudentId = @StudentId
	DELETE FROM Students WHERE Id = @StudentId

	--P20. Deleted Student

CREATE TABLE ExcludedStudents(
      StudentId INT,
      StudentName NVARCHAR(150)
)

GO

CREATE TRIGGER tr_LogDeletedStudents ON Students AFTER DELETE
AS 
	INSERT INTO ExcludedStudents
	Select s.Id, s.FirstName + ' ' + s.LastName From deleted as s