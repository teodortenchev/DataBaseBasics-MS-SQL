CREATE DATABASE PracticeDB

--p8
CREATE TABLE Users(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL UNIQUE,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
	LastLoginTime DATETIME,
	IsDeleted BIT,
)

INSERT INTO Users (Username, [Password], ProfilePicture, LastLoginTime, IsDeleted) VALUES
('Teodor', '123', NULL, CONVERT(datetime,'22-05-2019',103), 0),
('Maina', 'aza', NULL, CONVERT(datetime,'21-05-2000',103), 0),
('Puncho', '123', NULL, CONVERT(datetime,'11-11-2019',103), 0),
('Liolo', '123', NULL, CONVERT(datetime,'22-01-1988',103), 0),
('Garash', '123', NULL, CONVERT(datetime,'23-01-1999',103), 0)

--bonus - check if picture is equal or less than 900KB
ALTER TABLE Users
ADD CONSTRAINT CHK_ProfilePicture CHECK (DATALENGTH(ProfilePicture) <= 900 * 1024)

--P9 Change Primary Key. First drop the current PK then add a new one
ALTER TABLE Users
	DROP CONSTRAINT PK__Users__3214EC0794F195AF
--Add a PK that is a composite of two fields
ALTER TABLE Users
	ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

--P10 Add Check Contraint On Password Length
 
ALTER TABLE Users
ADD CONSTRAINT CHK_PasswordLength CHECK (LEN([Password]) >= 5)

--P11 Set Default Value of a Field

ALTER TABLE Users
ADD DEFAULT GETDATE() FOR LastLoginTime

INSERT INTO Users(Username, [Password], ProfilePicture, IsDeleted) VALUES
('Teodor', 'PASSWORD1LLS@', NULL, 0)

--P12 Set Unique Key
--Using SQL queries modify table Users. Remove Username field from the primary key
-- so only the field Id would be primary key. Now add unique constraint to
--  the Username field to ensure that the values there are at least 3 symbols long.

ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT CHK_UsernameLength CHECK (LEN(Username) >= 3)

INSERT INTO Users(Username, [Password], ProfilePicture, IsDeleted) VALUES
('Te', 'PASSWORD1LLS@', NULL, 0)