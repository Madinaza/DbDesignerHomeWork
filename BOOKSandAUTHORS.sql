create database Dbdesigner

use Dbdesigner

create table Books(
Id int primary key identity,
Name nvarchar(50)  not null constraint checkName check(len(Name)>2) , check(len(Name)<100),
PageCount int check(PageCount>=10),
AuthorId int foreign key references Authors(Id)
)

create table Authors(
Id int primary key identity,
Name nvarchar(30),
Surname nvarchar(40)
)

insert into Authors
values('Agatha','Christie'),
('Xalid','Huseyn'),
('Chingiz','Abdullayev')

insert into Books
values('Mavi Melekler',300,3),
('Mehşer ayaginda',279,3),
('Xezinedar',250,3),
('A Deadly Affair',350,1),
('The Mystery of the Blue Train',310,1),
('Cerpeleng ucuran',450,2),
('Min möhtesem gunes',390,2)

drop table Books



create view vw_SelectAuthorsBooks
as
select *from(
select b.Id,b.Name as 'BookName',b.PageCount ,(a.[Name]+' '+a.[Surname]) as 'AuthorFullName' from Books as b
join Authors as a
on b.AuthorId=a.Id
) as BooksAndAuthors

select *from vw_SelectAuthorsBooks

create procedure usp_BooksAndAuthors
@BookName nvarchar(30),
@AuthorFullName nvarchar(40)
as 
select * from vw_SelectAuthorsBooks
where BookName=@BookName and AuthorFullName=@AuthorFullName

exec usp_BooksAndAuthors 'Min möhtesem gunes','Xalid Huseyn'

create procedure usp_addAuthors
@Name nvarchar(30),
@Surname nvarchar(40)
as
insert into Authors
values(@Name,@Surname)

exec usp_addAuthors Paul,Auster

create procedure usp_updateAuthors
@Id int,
@Name nvarchar(30),
@Surname nvarchar(40)
as
update Authors
set Name=@Name ,Surname=@Surname
where Id=@Id


create procedure usp_deleteAuthors
@Id int,
@Name nvarchar(30),
@Surname nvarchar(40)
as
delete from Authors
where Id=@Id

exec usp_deleteAuthors 4,Paul,Auster


create view vw_SelectAuthors
as
select * from(
		select a.Id ,(a.[Name]+' '+a.[Surname])as 'FullName', Count(b.[Name]) as 'BookCount',Max(b.[PageCount])as 'MaxPageCount' from Books as b
		join Authors as a
		on b.AuthorId=a.Id
		group by a.[Id],a.[Name],a.[Surname]
		
) as AboutAuthors

select*from vw_SelectAuthors

