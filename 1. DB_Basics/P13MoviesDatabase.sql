CREATE DATABASE Movies

CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NTEXT
)

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY,
	GenreName NVARCHAR(50) NOT NULL,
	Notes NTEXT
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL,
	Notes NTEXT
)

CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(50) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear INT,
	[Length] INT NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating INT,
	Notes TEXT
)

INSERT INTO Directors(DirectorName, Notes) VALUES
('Jean Valjan', 'this guy is amazingly awesome'),
('Goran Gospodinovich', 'How did this movie get released?'),
('Nino Buddy', 'Remember to eat that sandwich under the desk'),
('Wholen Brown', null),
('Bonnie Richardson', null)

INSERT INTO Genres(GenreName, Notes) VALUES
('Horror', 'Scary spooky stuff'),
('Adventure', 'Indiana Jones and the liks'),
('Documentary', 'Joe from the office had nothing on this one.'),
('Drama', 'Everyone loves a little drama.'),
('Reality Shows', 'Risk of accute onset of brain meltdown ahead. Be warned.')

INSERT INTO Categories(CategoryName, Notes) VALUES
('Award-winning', null),
('Oscars', null),
('DVD Releases', null),
('Unos', null),
('Uncategorised',null)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating) VALUES
('The Great Escape', 1, 1998, 321, 2, 3, 9),
('Banana Peels', 3, 2005, 60, 3, 4, 10),
('Sure Gains', 2, 2015, 85, 1, 4, 5),
('Charlie Nomad', 2, 2025, 85, 1, 4, 2),
('Amazingly Faulty', 5, 1999, 5, 1, 1, 0)

