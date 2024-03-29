CREATE DATABASE PROJECT;
GO

USE PROJECT;
GO

-- Contains a listing of all possible course disciplines which
-- may have books up for sale. In other words, this table contains
-- all avaliable course disciplines at GCC.
CREATE TABLE Courses (
	CourseID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(64) NOT NULL UNIQUE,
	Code CHAR(4) NOT NULL UNIQUE
);

-- Contains one entry for every book in the exchange.
-- 
-- For example,the COMP 220 C++ book may be for sale by several
-- users, but each occurance (in the Sale relation) will link to a
-- single tuple in this realtion in order to avoid redundant data,
-- and satisfy 2NF.
CREATE TABLE Books (
	BookID INT NOT NULL PRIMARY KEY,
	ISBN10 CHAR(10) NOT NULL UNIQUE,
	ISBN13 CHAR(13) NOT NULL UNIQUE,
	Title VARCHAR(512) NOT NULL,
	Edition VARCHAR(32) NULL
);

-- Contains a record of book authors. Each author is linked to at 
-- least one book. In the case where multiple authors wrote one
-- book, then then several authors may reference one book in the 
-- Books relation.
CREATE TABLE Authors (
	EntryID INT NOT NULL PRIMARY KEY,
	Book INT NOT NULL REFERENCES Books(BookID) ON DELETE CASCADE,
	Author VARCHAR(512) NOT NULL
);

-- Holds all registered users and their associated roles, either
-- "Administrator" or "User"
CREATE TABLE Users (
	UserID INT NOT NULL PRIMARY KEY,
	FName VARCHAR(64) NOT NULL,
	LName VARCHAR(64) NOT NULL,
	UName VARCHAR(64) NOT NULL UNIQUE,
	PWord CHAR(32) NOT NULL,
	Role VARCHAR(13) NOT NULL
);

-- Contains entries for each book avaliable on the exchange
CREATE TABLE Sale (
	SaleID INT NOT NULL PRIMARY KEY,
	Book INT NOT NULL REFERENCES Books(BookID) ON DELETE NO ACTION,
	Merchant INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
	Upload DATETIME NOT NULL,
	Sold BIT NOT NULL,
	Price DECIMAL(10, 2) NOT NULL,
	Condition VARCHAR(9) NOT NULL,
	Written BIT NOT NULL,
	Comments VARCHAR(8000) NULL
);

-- Used in conjunction with the Sale table. This will contain a 
-- listing of courses where a particular user used a particular
-- book.
-- 
-- For example, the Stewart Calculus Book is used in MATH 161 A 
-- or B; 162 A, B, D, or E; and 261 A, B, or D. A user may have
-- used this particular book in MATH 161 A, 162 B, and 261 D,
-- and this table would link their entry in the Sale relation
-- with a series of tuple in this relation indicating which 
-- course section in which they used this book.
CREATE TABLE BookCourses (
	EntryID INT NOT NULL PRIMARY KEY,
	Sale INT NOT NULL REFERENCES Sale(SaleID) ON DELETE CASCADE,
	Course CHAR(4) NOT NULL REFERENCES Courses(Code) ON DELETE NO ACTION,
	CourseNum CHAR(3) NOT NULL,
	CourseSec CHAR(1) NOT NULL
);

-- Contains a list of purchased books
CREATE TABLE Purchases (
	PurchaseID INT NOT NULL PRIMARY KEY,
	Buyer INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
	Merchant INT NOT NULL REFERENCES Users(UserID) ON DELETE NO ACTION,
	Sale INT NOT NULL REFERENCES Sale(SaleID) UNIQUE,
	Time DATETIME NOT NULL
);
GO

INSERT INTO Courses VALUES
(1, 'Accounting', 'ACCT'),
(2, 'Art', 'ART'),
(3, 'Astronomy', 'ASTR'),
(4, 'Biology', 'BIO'),
(5, 'Business', 'BUSS'),
(6, 'Chemistry', 'CHEM'),
(7, 'Chinese', 'CHIN'),
(8, 'Communications', 'COMM'),
(9, 'Computer Science', 'COMP'),
(10, 'Economics', 'ECON'),
(11, 'Education', 'EDUC'),
(12, 'Electrical Engineering', 'EENG'),
(13, 'Engineering', 'ENGR'),
(14, 'English', 'ENGL'),
(15, 'Entreprenuership', 'ENTR'),
(16, 'Exercise Science', 'ESCI'),
(17, 'French', 'FREN'),
(18, 'General Science', 'GSCI'),
(19, 'Geology', 'GEOL'),
(20, 'German', 'GERM'),
(21, 'Global Studies', 'GLOB'),
(22, 'Greek', 'GREK'),
(23, 'Hebrew', 'HEBR'),
(24, 'History', 'HIST'),
(25, 'Humanities', 'HUMA'),
(26, 'Japanese', 'JAPN'),
(27, 'Mathematics', 'MATH'),
(28, 'Mechanical Engineering', 'MECH'),
(29, 'Music', 'MUSC'),
(30, 'Philosophy', 'PHIL'),
(31, 'Physics', 'PHYS'),
(32, 'Political Science', 'POLY'),
(33, 'Psychology', 'PYCH'),
(34, 'Religion', 'RELI'),
(35, 'Science Faith & Tech', 'SSFT'),
(36, 'Sociology', 'SOCI'),
(37, 'Spanish', 'SPAN'),
(38, 'Special Education', 'SEDU'),
(39, 'Theater', 'THEA');

INSERT INTO Books VALUES
(1, '0538497815', '9780538497817', 'Calculus', '7th Edition'),
(2, '013283071X', '9780132830713', 'Absolute C++', '5th Edition'),
(3, '0205728928', '9780205728923', 'The Western Heritage: Teaching and Learning Classroom Edition, Volume 1 (to 1740)', '6th Edition');

INSERT INTO Authors VALUES
(1, 1, 'James Stewart'),
(2, 2, 'Walter Savitch'),
(3, 3, 'Donald Kagan'),
(4, 3, 'Steven Ozment'),
(5, 3, 'Frank M. Turner');

INSERT INTO Users VALUES
(1, 'Matthew', 'Goehring', 'goehringmr1', 'password', 'Administrator'),
(2, 'David', 'Smeltzer', 'smeltzerdj1', 'password', 'Administrator'),
(3, 'Oliver', 'Spryn', 'sprynoj1', 'password', 'Administrator'),
(4, 'Regular', 'User', 'reguser', 'password', 'User');

INSERT INTO Sale VALUES
(1, 2, 4, CURRENT_TIMESTAMP, 0, 39.99, 'Excellent', 0, 'Just like new!'),
(2, 2, 2, CURRENT_TIMESTAMP, 0, 39.99, 'Very Good', 1, 'The books has a few rough edges on the cover, but basically in good shape.'),
(3, 1, 1, CURRENT_TIMESTAMP, 1, 99.99, 'Excellent', 0, 'This book is still in the plastic wrapping, with the WebAssign card.'),
(4, 3, 3, CURRENT_TIMESTAMP, 0, 19.99, 'Good', 1, 'This is book has had several owners, and its cover shows it with its curling edges.');

INSERT INTO BookCourses VALUES
(1, 1, 'COMP', '220', 'A'),
(2, 2, 'COMP', '220', 'A'),
(3, 3, 'MATH', '161', 'A'),
(4, 3, 'MATH', '162', 'B'),
(5, 3, 'MATH', '261', 'D'),
(6, 4, 'HUMA', '101', 'L');

INSERT INTO PURCHASES VALUES
(1, 4, 1, 3, CURRENT_TIMESTAMP);
GO

-- Create a DELETE trigger since ON DELETE CASCADE will not work for
-- the Sale attribute of the Purchases relation
CREATE TRIGGER SaleDeleteRemoveReferencingPurchases
ON Sale
AFTER DELETE
AS BEGIN
	DECLARE @SaleID INT;
	SET @SaleID = (SELECT SaleID FROM DELETED);
	
	IF (SELECT COUNT(*) FROM Purchases WHERE Sale = @SaleID) > 0
	BEGIN
		DELETE FROM Purchases WHERE Sale = @SaleID;
	END
END
GO

-- Allows the creation of DB Diagrams
ALTER AUTHORIZATION ON DATABASE::PROJECT TO sa;