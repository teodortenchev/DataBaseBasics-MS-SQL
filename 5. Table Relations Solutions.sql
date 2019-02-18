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

CREATE TABLE Models (
   ModelID INT PRIMARY KEY,
	 [Name] VARCHAR(15) NOT NULL,
	 ManufacturerID INT NOT NULL
)

CREATE TABLE Manufacturers (
   ManufacturerID INT PRIMARY KEY,
	 [Name] VARCHAR(15) NOT NULL,
	 EstablishedOn DATE NOT NULL
)

ALTER TABLE Models
   ADD CONSTRAINT FK_Models_Manufacturers FOREIGN KEY (ManufacturerID)
	   REFERENCES Manufacturers(ManufacturerID)

