-- Query to create table:
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    DateHired DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert data
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Sales');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, DateHired) VALUES
(1, 'Alice', 'Smith', 1, 50000, '2020-01-15'),
(2, 'Bob', 'Johnson', 1, 60000, '2018-03-22'),
(3, 'Charlie', 'Williams', 2, 70000, '2019-07-30'),
(4, 'David', 'Brown', 2, 80000, '2017-11-11'),
(5, 'Eve', 'Davis', 3, 90000, '2021-02-25'),
(6, 'Frank', 'Miller', 3, 55000, '2020-09-10'),
(7, 'Grace', 'Wilson', 2, 75000, '2016-04-05'),
(8, 'Henry', 'Moore', 1, 65000, '2022-06-17');


--Find the top 3 highest-paid employees in each department.
go
with Rankedemp as (
select e.EmployeeID,e.FirstName,e.LastName,e.DepartmentID,e.Salary,e.DateHired,d.DepartmentName,
row_number() over(partition by e.DepartmentID order by e.Salary desc) as rank
from dbo.Employees e
join Departments d on e.DepartmentID = d.DepartmentID)

select EmployeeID,FirstName,LastName,DepartmentID,Salary,DateHired,DepartmentName from Rankedemp  where rank<3


select * from(
select EmployeeID,FirstName,LastName,DepartmentID,Salary,DateHired,
dense_rank() over(partition by DepartmentID order by Salary desc) as r 
from dbo.Employees) as ranked
where r <=3

--Find the average salary of employees hired in the last 5 years.


select EmployeeID,FirstName,LastName,avg(Salary) from dbo.Employees where year(DateHired) 


select Year(DateHired),avg(Salary) from dbo.Employees group by Year(DateHired)

select EmployeeID,Salary, avg(Salary) avg_sal from dbo.Employees 
where DateHired >= DATEADD(Year,-5,GETDATE())
group by EmployeeID,Salary



--Find the employees whose salry is less than the average salary of employees hired in the last 5 years.


select * from dbo.Employees where Salary < (select avg(Salary) from dbo.Employees)
and DateHired >= DATEADD(Year,-5,GETDATE()) 


select DATEADD(day,-3,GETDATE())


select * from dbo.Departments
select * from dbo.Employees


create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')


select * from dbo.entries


select name,COUNT(name) as Total_visits from dbo.entries group by name




select * from dbo.Departments
select * from dbo.Employees


select d.DepartmentName,count(e.EmployeeID) as Emp_Dept
from dbo.Departments d join dbo.Employees e
on d.DepartmentID = e.DepartmentID
group by d.DepartmentName


select * from dbo.Sales_Data

select sum(price) from dbo.Sales_Data



select month(order_date),
SUM(price) as total_price,
--sum(sum(price)) over(order by month(order_date)) as cum_price from dbo.Sales_Data,
avg(avg(price)) over(order by month(order_date)) as cum_price from dbo.Sales_Data
group by month(order_date)