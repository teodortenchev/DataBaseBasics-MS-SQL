--Problem 1

CREATE TABLE Persons (
    PersonID INT PRIMARY KEY,
		FirstName VARCHAR(30) NOT NULL,
		Salary DECIMAL(15,2),
		PassportID INT NOT NULL 
)

CREATE TABLE Passports (
    PassportID INT PRIMARY KEY,
		PassportNumber CHAR(8) NOT NULL
)

ALTER TABLE Persons
    ADD CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID)
		  REFERENCES Passports(PassportID)

ALTER TABLE Persons
    ADD UNIQUE(PassportID)

ALTER TABLE Passports
    ADD UNIQUE(PassportNumber)

INSERT INTO Passports (PassportID, PassportNumber) VALUES
 (101, 'N34FG21B'), (102, 'K65LO4R7'), (103, 'ZE657QP2')

INSERT INTO Persons VALUES
 (1, 'Roberto', 43300.00, 102), (2, 'Tom', 56100.00, 103), 
 (3, 'Yana', 60200.00, 101)


--Problem 2
CREATE TABLE Models (
   ModelID INT PRIMARY KEY IDENTITY(101,1),
	 [Name] VARCHAR(15) NOT NULL,
	 ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)

)

CREATE TABLE Manufacturers (
   ManufacturerID INT PRIMARY KEY IDENTITY,
	 [Name] VARCHAR(15) NOT NULL,
	 EstablishedOn DATE NOT NULL
)

ALTER TABLE Models
   ADD CONSTRAINT FK_Models_Manufacturers FOREIGN KEY (ManufacturerID)
	   REFERENCES Manufacturers(ManufacturerID)

--Problem 3

CREATE TABLE Students (
  StudentID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(15) NOT NULL,
)

CREATE TABLE Exams (
  ExamID INT PRIMARY KEY IDENTITY(101,1),
	[Name] VARCHAR(15) NOT NULL,
)

CREATE TABLE StudentsExams (
  StudentID INT NOT NULL,
	ExamID INT NOT NULL,
	CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentID)
	  REFERENCES Students(StudentID),
	CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamID)
	  REFERENCES Exams(ExamID)
)