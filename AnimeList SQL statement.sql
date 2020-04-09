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
EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false 

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
userId int references Users(userId),
animeId int references Anime(animeId)
);

create table AnimeProducer(
producerId int references Producer(producerId),
animeId int references Anime(animeId)
);

create table AnimeGenre(
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

go
-- create a view
create VIEW  animeListView
AS
SELECT        TOP (100) PERCENT dbo.Anime.animeId, dbo.Anime.title, dbo.Users.userId, dbo.Users.userName
FROM          dbo.Anime CROSS JOIN
                         dbo.Users
GROUP BY dbo.Anime.animeId, dbo.Anime.title, dbo.Users.userId, dbo.Users.userName
ORDER BY dbo.Anime.animeId DESC;

go

--Stored Procedure (gets anime by anime id)

CREATE PROCEDURE getAnimeForUser
AS
select	al.userId, a.animeId, a.title
from  AnimeList al right join Anime a on al.animeId = a.animeId
where al.userId = 1;
GO

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
select * from Anime
select * from Users
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
