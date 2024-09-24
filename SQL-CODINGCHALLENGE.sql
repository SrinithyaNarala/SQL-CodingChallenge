------------------------Coding Challenge SQL---------------------------------
-----------------Virtual Art Gallery Shema DDL and DML-----------------------
create database Virtual_Art_Gallery
use Virtual_Art_Gallery;
-- Create the Artists table
CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

 -- Create the Categories table
 CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

 -- Create the Artworks table
 CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

 -- Create the Exhibitions table
CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

 -- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

 -- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

 -- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

 -- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso powerful anti-war mural.','guernica.jpg');

 -- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

 -- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

---------Solve the below queries:
--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.
SELECT a.Name, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.Name
ORDER BY ArtworkCount DESC;

--2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.
SELECT aw.Title
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality IN ('Spanish', 'Dutch')
ORDER BY aw.Year ;

--3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.
SELECT a.Name, COUNT(aw.ArtworkID) AS PaintingCount
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE c.Name = 'Painting'
GROUP BY a.Name;

--4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.
SELECT aw.Title, a.Name AS ArtistName, c.Name AS CategoryName
FROM ExhibitionArtworks ea
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
JOIN Artists a ON aw.ArtistID = a.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE e.Title = 'Modern Art Masterpieces';

--5. Find the artists who have more than two artworks in the gallery.
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (4, 'The Weeping Woman', 1, 1, 1937, 'A famous painting by Pablo Picasso.', 'weeping_woman.jpg'),
 (5, 'Les Demoiselles d"Avignon', 1, 1, 1907, 'A large oil painting by Pablo Picasso.', 'demoiselles_avignon.jpg');
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.Name
HAVING COUNT(aw.ArtworkID) > 2;

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions-(10)
SELECT aw.Title
FROM Artworks aw
JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE e.Title IN ('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY aw.ArtworkID, aw.Title
HAVING COUNT(DISTINCT e.ExhibitionID) = 2;


--7. Find the total number of artworks in each category
SELECT c.Name AS CategoryName, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name;

--8. List artists who have more than 3 artworks in the gallery.
INSERT INTO Artworks VALUES
 (6, 'Woman with a Flower', 1, 1, 1932, 'An abstract portrait by Pablo Picasso.', 'woman_flower.jpg');
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.Name
HAVING COUNT(aw.ArtworkID) > 3;

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish).
SELECT aw.Title
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality = 'Spanish';

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.-(6)
SELECT e.Title
FROM Exhibitions e
JOIN ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID
JOIN Artworks aw1 ON ea1.ArtworkID = aw1.ArtworkID
JOIN Artists a1 ON aw1.ArtistID = a1.ArtistID
JOIN ExhibitionArtworks ea2 ON e.ExhibitionID = ea2.ExhibitionID
JOIN Artworks aw2 ON ea2.ArtworkID = aw2.ArtworkID
JOIN Artists a2 ON aw2.ArtistID = a2.ArtistID
WHERE a1.Name = 'Vincent van Gogh' AND a2.Name = 'Leonardo da Vinci';

select * from ExhibitionArtworks
select * from Artists
select * from artworks
select * from Exhibitions
--11. Find all the artworks that have not been included in any exhibition.
SELECT aw.Title
FROM Artworks aw
LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;
-- 11) using suquery
SELECT aw.Title
FROM Artworks aw
where aw.ArtworkID not in(select ea.ArtworkID
from ExhibitionArtworks ea);

select * from artworks
select * from ExhibitionArtworks
select * from Exhibitions
--12. List artists who have created artworks in all available categories.
-- Adding a Sculpture for Vincent van Gogh (ArtistID = 2)
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (8, 'Head of a Woman', 2, 2, 1941, 'A famous sculpture by Pablo Picasso.', 'head_of_woman.jpg');
-- Adding a Photography work for Vincent van Gogh (ArtistID = 2)
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (9, 'Picasso Studio', 2, 3, 1955, 'A photograph taken in Picasso studio.', 'picasso_studio.jpg');

 update Artworks
set Title='van Studio',Description='A photograph taken in Vincent van Gogh.',ImageURL='van_studio.jpg' where ArtworkID=9;
update Artworks
set Description='A Sculpture by Vincent van Gogh.' where ArtworkID=8;

SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
GROUP BY a.Name
HAVING COUNT(aw.CategoryID) = (SELECT COUNT(*) FROM Categories);

--13. List the total number of artworks in each category.
-------same as 7th query
SELECT c.Name AS CategoryName, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name;
--14. Find the artists who have more than 2 artworks in the gallery.
-------- same as query 5
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.Name
HAVING COUNT(aw.ArtworkID) > 2;
--15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
SELECT c.Name AS CategoryName, AVG(aw.Year) AS AverageYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name
HAVING COUNT(aw.ArtworkID) > 1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT aw.Title
FROM ExhibitionArtworks ea
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
WHERE e.Title = 'Modern Art Masterpieces';

--17. Find the categories where the average year of artworks is greater than the average year of all artworks.
SELECT c.Name
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name
HAVING AVG(aw.Year) > (SELECT AVG(Year) FROM Artworks);

--18. List the artworks that were not exhibited in any exhibition.
-------- same as query 11
SELECT aw.Title
FROM Artworks aw
LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;
--19. Show artists who have artworks in the same category as "Mona Lisa."
SELECT DISTINCT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
WHERE aw.CategoryID = (SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa');

--20. List the names of artists and the number of artworks they have in the gallery
-------- same as query 1
select a.Name, count(aw.artworkID) as Number_of_Artworks
from Artists a
join Artworks aw on a.ArtistID = aw.ArtistID
group by a.Name