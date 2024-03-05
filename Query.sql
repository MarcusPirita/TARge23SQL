--loome db
create database TARge23SQL

-- db valimine
use TARge23SQL

--db kustutamine
drop database TARge23SQL

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female'),
(3, 'Unknown')

-- vaatame tabeli sisu
select * from Gender

--loome uue tabeli
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId) values
(1, 'Superman', 's@s.com', 1),
(2, 'Wonderwoman', 'w@w.com', 2),
(3, 'Batman', 'b@b.com', 1),
(4, 'Aquaman', 'a@a.com', 1),
(5, 'Catwoman', 'c@c.com', 2),
(6, 'Antman', 'ant"ant.com', 1),
(7, NULL, NULL, 3)

--vaadake Person tabeli andmeid
select * from Person

-- võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud GenderId-d
-- alla väärtust, siis see automaatselt sisestab sellele reale
--väärtuse 3 e nagu unknown
alter table Person
add constraint DF_persons_GenderId
default 3 for GenderId

--sisestame andmed
--
insert into Person (Id, Name, Email)
values (8, 'Ironman', 'i@i.com')

select * from Person

--lisame uue veeru
alter table Person
add Age nvarchar(10)

-- lisame nr piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

-- sisestame uue rea andmeid
insert into Person (Id, Name, Email, GenderId, Age)
values (10, 'Kalevipoeg', 'k@k.com', 1, 30)

--muudame koodiga andmeid
update Person
set Age = 35
where Id = 9

select * from Person

--sisestame muutuja City nvarchar(50)
alter table Person
add City nvarchar(50)

--sisestame City veergu andmeid
update Person
set City = 'New York'
where Id = 

select * from Person

-- kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- kõik, kes ei ela Gothamis
select * from Person Where City <> 'Gotham'
-- kõik, kes ei ela Gothamis
select * from Person Where City != 'Gotham'

-- näitab teatud vanusega inimesi
select * from Person where Age = 120 or Age = 50 or Age = 19
select * from Person where Age in (120, 50, 19)

-- näitab teatud vanusevahemikus olevaid inimesi
-- ka 22 ja 31 aastaseid
select * from Person where Age between 22 and 31

-- wildcard e näitab kõik n-tähega linnad
-- n-tähega algavad linnad
select * from Person where City like 'n%'
-- kõik emailid, kus on @ märk sees
select * from Person where Email like '%@%'

-- näitab emaile, kus ei ole @-märki sees
select * from Person where Email not like '%@%'

-- näitab, kellel on emailis ees ja peale @-märki ainult üks täht
select * from Person where Email like '_@_.com'

update Person
set Email = 'bat@bat.com'
where Id = 3

-- kõik, kellel nimes ei ole esimene täht W, A, C
select * from Person where Name like '[^WAC]%'
select * from Person

-- kes elavad Gothamis ja New York-s
select * from Person where (City = 'Gotham' or City = 'New York')

-- kõik kes elavad välja toodud linnades ja on vanemad, kui
-- 29
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >= 30

-- kuvab tähestikulises järjekorras inimesi ja võtab
-- aluseks nime
select * from Person order by Name 
-- kuvab vastupidises järjekorras
select * from Person order by Name desc

-- võtab kolm esimest rida
select top 3 * from Person

-- kolm esimest, aga tabeli järjestus on Age ja siis Name
select * from Person
select top 3 Age, Name from Person

-- näita esimene 50% tabeli sisust
select top 50 percent * from Person

-- järjestab vanuse järgi isikud
select * from Person order by cast(Age as int)

--05.03.2024
--kõikide isikute koondvanus
select SUM(cast(Age as int)) from Person

--kuvab kõige nooremat isikut
select MIN(CAST(Age as int)) from Person
--kuvab kõige vanemat isikut
select MAX(CAST(Age as int)) from Person

--näeme konkreetsetes linnades olevate isikute koondvanust
select City, SUM(CAST(Age as int)) as TotalAge from 
Person group by City

--kuuidas saab koodiga muuta andme tüüp ja selle pikkust
alter table Person
alter column Age int

--kuvab esimeses reas välja toodud järjestuses ja muudab Age-i TotalAge-ks
--järjest Citys olevate nimede järgi ja siis GenderId järgi
select City, GenderId, SUM(Age) as TotalAge from Person
group by City, GenderId
order by City

insert into Person values
(11, 'Robin', 'robin@e.com', 1, 29, 'Gotham')

--näitab ridade arvu tabelis
select COUNT(*) from Person
select * from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 2 konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära
select GenderId, City, SUM(Age) as TotalAge, COUNT(Id)
as [Total Person(s)]
from Person
group by GenderId, City having SUM(Age) > 41

--loome tabelid Employees ja department

create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)
insert into Employees (Id, Name, Gender, Salary, DepartmentId) 
values
(1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department (Id, DepartmentName, Location, DepartmentHead) 
values
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutab kõikide palgad kokku Employees tabelis
select SUM(cast(Salary as int)) from Employees
--min palga saaja
select min(cast(Salary as int)) from Employees
--ühe kuu palga saaja linnade lõikes
select Location, SUM(CAST(Salary as int)) as TotalSalary
from Employees
left join Department 
on Employees.DepartmentId = Department.Id
group by Location

alter table Employees
add City nvarchar(30)

update Employees
set City = 'New York'
where Id = 10
select * from Employees

--näitab erinevust palgafondi osas nii linnade kui ka soo osas
select City, Gender, SUM(CAST(Salary as int)) as TotalSalary from Employees
group by City, Gender
--sama päring nagu eelmine, aga linnad on tähestikulises järjekorras
select City, Gender, SUM(CAST(Salary as int)) as TotalSalary from Employees
group by City, Gender
order by City

--loeb ära ridade arvu Employees tabelis
select COUNT(*) from Employees

--mitu töötajat on soo ja linna kaupa
select Gender, City,
count (Id) as [Total Employee(s)]
from Employees
group by Gender, City

--kuvab ainult kõik naised linnade kaupa
select Gender, City,
count (Id) as [Total Employee(s)]
from Employees
where Gender = 'Female'
group by Gender, City

--kuvab ainult kõik mehed linnade kaupa
--ja kasutame "having"
select Gender, City,
count (Id) as [Total Employee(s)]
from Employees
group by Gender, City
having Gender = 'Male'

select * from Employees where SUM(CAST(Salary as int)) > 4000

select Gender, City, SUM(CAST(Salary as int)) as TotalSalary, COUNT (Id)
as [Total Employee(s)]
from Employees group by Gender, City
having SUM(CAST(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1