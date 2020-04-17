-- AnimeDatabase : LOGAN WHITE : CIST 1307 : PROFESSOR ELLISON


use master;
go
--drops the animelist database if it exists
drop database AnimeList;
go
-- creates the anime list database and makes it the used database
create database AnimeList;
go
use AnimeList;
go

-- change the owner of the database to a local account so we can create diagrams
EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false ;

--creates all of the tables in the database, including linking tables

create table Users(
userId int identity(00, 1) primary key,
userName nvarchar(25) not null,
dateOfBirth date not null,
gender char(1)
);

create table Anime(
animeId int identity(100, 1) primary key,
title nvarchar(100) not null,
sourceMaterial nvarchar(25),
episodeCount int
);

create table Producer(
producerId int identity(100, 1) primary key,
producerName nvarchar(25) not null
);

create table Genre(
genreId int identity(100, 1) primary key,
genreName nvarchar(25) not null
);

create table AnimeList(
listId int identity(1000,1) primary key,
userId int references Users(userId),
animeId int references Anime(animeId)
);

create table AnimeProducer(
animeProducerId int identity(1000,1) primary key,
producerId int references Producer(producerId),
animeId int references Anime(animeId)
);

create table AnimeGenre(
animeGenreId int identity(1000,1) primary key,
animeId int references Anime(animeId),
genreId int references Genre(genreId)
);
go
-- creates the indexes

create unique index users_username on Users(userName);
create unique index anime_animetitle on Anime(title);
create unique index producer_producername on Producer(producerName);
create unique index genre_genrename on Genre(genreName);
create index anime_sourcematerial on Anime(sourceMaterial);
create index anime_episodecount on Anime(episodeCount);


-- Insert data into users table
insert into Users(userName, dateOfBirth, gender) values('LAW175', '1999-10-06', 'M');
insert into Users(userName, dateOfBirth, gender) values('Sir_Ellison', '1980-12-13', 'M');
insert into Users(userName, dateOfBirth, gender) values('Sir_Ellison_Sr', '1979-04-02', 'M');
insert into Users(userName, dateOfBirth, gender) values('Jaelynn', '1989-11-12', 'F');
insert into Users(userName, dateOfBirth, gender) values('WeebGuy', '2000-01-28', 'M');

-- Insert Data into Anime table
insert into Anime(title, sourceMaterial, episodeCount) values('Steins;Gate', 'Visual Novel', 24);
insert into Anime(title, sourceMaterial, episodeCount) values('Death Note', 'Manga', 37);
insert into Anime(title, sourceMaterial, episodeCount) values('Naruto', 'Manga', 220);
insert into Anime(title, sourceMaterial, episodeCount) values('Boku no Hero Academia', 'Manga', 13);
insert into Anime(title, sourceMaterial, episodeCount) values('Hunter x Hunter (2011)', 'Manga', 148);


-- Insert data into Producer Table
insert into Producer(producerName) values('White Fox');
insert into Producer(producerName) values('Madhouse');
insert into Producer(producerName) values('Viz Media');
insert into Producer(producerName) values('Bones');
insert into Producer(producerName) values('Kyoto Animation');
-- Insert data into Genre Table
insert into Genre(genreName) values('Thriller');
insert into Genre(genreName) values('Sci-Fi');
insert into Genre(genreName) values('Mystery');
insert into Genre(genreName) values('Shounen');
insert into Genre(genreName) values('Action');

-- insert data into linking tables

-- animelist table
insert into AnimeList(userId, animeId) values(0, 100);
insert into AnimeList(userId, animeId) values(0, 101);
insert into AnimeList(userId, animeId) values(0, 102);
insert into AnimeList(userId, animeId) values(0, 103);
insert into AnimeList(userId, animeId) values(0, 104);
insert into AnimeList(userId, animeId) values(1, 102);
insert into AnimeList(userId, animeId) values(2, 100);
insert into AnimeList(userId, animeId) values(2, 102);
insert into AnimeList(userId, animeId) values(3, 104);
insert into AnimeList(userId, animeId) values(4, 104);
insert into AnimeList(userId, animeId) values(4, 102);

-- producer table
insert into AnimeProducer(producerId, animeId) values(100, 100);
insert into AnimeProducer(producerId, animeId) values(101, 101);
insert into AnimeProducer(producerId, animeId) values(102, 102);
insert into AnimeProducer(producerId, animeId) values(103, 103);
insert into AnimeProducer(producerId, animeId) values(101, 104);

-- animegenre table

insert into AnimeGenre(genreId, animeId) values(100, 100);
insert into AnimeGenre(genreId, animeId) values(101, 100);
insert into AnimeGenre(genreId, animeId) values(102, 101);
insert into AnimeGenre(genreId, animeId) values(100, 101);
insert into AnimeGenre(genreId, animeId) values(103, 101);
insert into AnimeGenre(genreId, animeId) values(104, 102);
insert into AnimeGenre(genreId, animeId) values(103, 102);
insert into AnimeGenre(genreId, animeId) values(104, 103);
insert into AnimeGenre(genreId, animeId) values(103, 103);
insert into AnimeGenre(genreId, animeId) values(104, 104);
insert into AnimeGenre(genreId, animeId) values(103, 104);

go


-- VIEWS

-- VIEW 1| shows anime title and linked to a user with their ids
create VIEW  animeListView
AS
SELECT        TOP (100) PERCENT dbo.Anime.animeId, dbo.Anime.title, dbo.Users.userId, dbo.Users.userName
FROM          dbo.Anime CROSS JOIN
                         dbo.Users
GROUP BY dbo.Anime.animeId, dbo.Anime.title, dbo.Users.userId, dbo.Users.userName
ORDER BY dbo.Anime.animeId DESC;

go
select * from animeListView;
go
-- VIEW 2
create VIEW animeByProducer
as
SELECT        TOP (100) PERCENT dbo.Producer.producerName, dbo.Anime.title
FROM            dbo.Anime INNER JOIN
                         dbo.AnimeProducer ON dbo.Anime.animeId = dbo.AnimeProducer.animeId INNER JOIN
                         dbo.Producer ON dbo.AnimeProducer.producerId = dbo.Producer.producerId
GROUP BY dbo.Anime.title, dbo.Producer.producerName
ORDER BY dbo.Producer.producerName;
go
select * from animeByProducer;
go
-- VIEW 3 gets anime by its genre

create VIEW animeByGenre
as
SELECT        TOP (100) PERCENT dbo.Anime.title, dbo.Genre.genreName
FROM            dbo.Anime INNER JOIN
                         dbo.AnimeGenre ON dbo.Anime.animeId = dbo.AnimeGenre.animeId INNER JOIN
                         dbo.Genre ON dbo.AnimeGenre.genreId = dbo.Genre.genreId
ORDER BY dbo.Genre.genreName;
go
select * from animeByGenre;

-- STORED PROCEDURES

--Stored Procedure 1 gets anime based on userid
GO
CREATE PROCEDURE getAnimeForUser2 @UserId int
AS
select	al.userId, a.animeId, a.title
from  AnimeList al right join Anime a on al.animeId = a.animeId
where al.userId = @UserId;
GO

-- demonstrates it works
Exec getAnimeForUser2 @UserId = 3;
go




-- stored procedure 2 adds a user to database

CREATE PROCEDURE insertUser 
@userName nvarchar(25),
@dateOfBirth date,
@gender char(1)
AS
BEGIN
     SET NOCOUNT ON;

    -- Inserts the data
INSERT INTO Users
(userName, dateOfBirth, gender)
VALUES
(@userName, @dateOfBirth, @gender)
END
go

Exec insertUser @userName = 'test123', @dateOfBirth = '1993-10-10', @gender = 'F';

--displays that it works
select * 
from users
where userName = 'test123';



-- Stored Procedure 3 gets how many times an anime has been watched
go

Create procedure getAnimeCount 
as
select Anime.title, count(animelist.animeId) as 'Number of times watched'
from AnimeList join Anime on AnimeList.animeId = Anime.animeId
group by anime.title
order by [Number of times watched] DESC;
go

exec getAnimeCount;