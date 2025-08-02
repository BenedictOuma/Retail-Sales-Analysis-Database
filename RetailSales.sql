--Creating the database
create database RetailSales;

use RetailSales;   

--Customers table
create table Customers (
    CustomerID int identity (100,1) primary key,
    CustomerName varchar (60) not null,
    EmailAddress varchar (55) unique not null,
    TelephoneNo varchar (15) unique not null,
    RegistrationDate date not null
	);

insert into Customers values
('Cristiano Penaldo', 'cr7@notreal.com', '30712345678', '2023-01-15'),
('Lionel Tapessi', 'messi@fake.org', '30723456789', '2023-02-10'),
('Neymar Diver', 'ney@flop.com', '40734567890', '2023-03-05'),
('Mbappé Sprinter', 'mbappe@usain.com', '40745678901', '2023-04-01'),
('Erling Haalalien', 'erling@city.org', '30756789012', '2023-05-20'),
('Luis Bitez', 'suarez@bite.net', '20767890123', '2023-06-15'),
('Paul PogBOOM', 'pogba@unreal.com', '30778901234', '2023-07-10'),
('Zlatan Legend', 'zlatan@god.com', '40789012345', '2023-08-05'),
('Harry Kanetrain', 'kane@missing.org', '40790123456', '2023-09-01'),
('Bruno Finisher', 'bruno@pen.com', '20711122334', '2023-10-10'),
('Sergio Ramosinho', 'ramos@redcards.com', '20722233445', '2023-11-15'),
('Mo Salahdive', 'salah@egypt.net', '30733344556', '2023-12-20'),
('David Hairia', 'degea@butterfingers.com', '30744455667', '2024-01-25'),
('Sadio Tappé', 'sadio@speed.org', '20755566778', '2024-02-05'),
('KDB Bruyne', 'kdb@assist.com', '70766677889', '2024-03-01'),
('Gareth Wale', 'gareth@golf.com', '60777788990', '2024-04-15'),
('Virgil Vandijk', 'virgil@defense.com', '40788899001', '2024-05-10'),
('Luka Modritch', 'luka@ballon.com', '30799900112', '2024-06-20'),
('Andres IniGoal', 'iniesta@silent.com', '10711212123', '2024-07-25'),
('Xavi Master', 'xavi@tiki.com', '30722323234', '2024-08-30'),
('Ronaldhino Smile', 'ronnie@magic.com', '80733434345', '2024-09-10'),
('Pele Ghost', 'pele@legend.com', '50744545456', '2024-10-15'),
('Maradona Hand', 'maradona@goat.com', '50755656567', '2024-11-05'),
('R9 Phenomeno', 'ronaldo@brazil.com', '20766767678', '2024-12-20'),
('Benz Ego', 'benzema@king.com', '70777878789', '2025-01-10'),
('LewanGoal', 'lewa@scorer.com', '40788989890', '2025-02-15'),
('Drogba King', 'drogba@ivory.com', '30799090901', '2025-03-20');


--Suppliers table
create table Suppliers (
	SupplierID int identity (250,1) primary key,
	SupplierName varchar (60) not null,
	TelephoneNo varchar (15) unique not null,
	EmailAddress varchar (30) unique not null
	);

insert into Suppliers values
('Zlatan Enterprises', '0712345678', 'god@acmilan'), 
('Maradona Distributors', '0723456789', 'handofgod@arg'), 
('Ronaldinho Sports Ltd', '0734567890', 'samba@brazil.football'), 
('Cantona Supplies', '0745678901', 'kungfu@manutd'), 
('Pirlo Italian Imports', '0756789012', 'wine@juve'), 
('Drogba Logistics', '0767890123', 'king@chelsea'), 
('Bale Fast Supplies', '0778901234', 'golf@wales');

--Adding a foreign key to products table
alter table Products
add constraint fk_ProviderID_Products
foreign key (SupplierID) references Suppliers(SupplierID);

--Employees table
create table Employees (
	EmployeeID int identity (300,-1) primary key,
	EmployeeName varchar (60) not null,
	TelephoneNo varchar (15) unique not null,
	EmailAddress varchar (15) unique not null,
	EmployeeRole varchar (60) not null,
	EmployeeSalary int check (EmployeeSalary>0) not null,
	HireDate date not null
	);

insert into Employees values
('Messi Ronaldo', '071234567898', 'goal@offside.', 'Sales Manager', 120000, '2023-01-15'),
('Zlatan Pogboom', '072345678967', 'legend@null', 'Cashier', 45000, '2023-02-20'),
('Mbappe Haaland', '073456789075', 'fast@pace123.', 'Warehouse Clerk', 35000, '2023-03-10'),
('Neymar Rashford', '074567890145', 'skills@freekick', 'Sales Representative', 50000, '2023-04-05'),
('Kante Lukaku', '075678901264', 'defensive@mid.', 'Inventory Manager', 65000, '2023-05-18'),
('Suarez Maguire', '076789012356', 'biting@head.', 'Security Officer', 40000, '2023-06-25'),
('Modric Xavi', '077890123424', 'passes@short.', 'Customer Support', 48000, '2023-07-30'),
('Bale Benzema', '078901234545', 'injury@subbed.', 'Delivery Coordinator', 55000, '2023-08-12'),
('Kimmich Casemiro', '079012345667', 'tackle@redcard', 'Finance Assistant', 70000, '2023-09-01');

--Adding foreign keys to Orders table
alter table Orders
add constraint fk_ProviderID_Orders
foreign key (CustomerID) references Customers(CustomerID),
foreign key (ProductID) references Products(ProductID);

--Sales table
create table Sales (
	SaleID  int identity (400,-1) primary key,
	EmployeeID int,
	OrderID int,
	SaleDate date,
	foreign key (EmployeeID) references Employees(EmployeeID),
	foreign key (OrderID) references Orders(OrderID)
	);

--Adding values to the Sales table
insert into Sales
select
    (300 - abs(checksum(newid())) % 9) as EmployeeID,
    OrderID, 
    OrderDate as SaleDate
from Orders
where OrderStatus = 'Delivered';

--Tables data preview
select*from Customers;
select*from Suppliers;
select*from Products;
select*from Employees;
select*from Orders;
select*from Sales;

--Employees and the commissions they earned from the sales they made
with OrderDetails as (
select
o.OrderID,
o.CustomerID,
o.OrderQuantity,
p.ProductPrice,
(o.OrderQuantity * p.ProductPrice) as OrderAmount,
case when o.OrderStatus = 'Delivered' then (o.OrderQuantity * p.ProductPrice + o.ShippingFee) else null end as SaleAmount,
case when o.OrderStatus = 'Delivered' then cast((o.OrderQuantity * p.ProductPrice + o.ShippingFee) * 0.05 as int) else null end as Commission
from Orders o
join Products p on o.ProductID = p.ProductID
),
SalesDetails as (
select s.SaleId, s.EmployeeId, e.EmployeeName, od.Commission
from Sales s
join Employees e on e.EmployeeID=s.Employeeid
join OrderDetails od on od.OrderID=s.OrderID
)
select*from SalesDetails;

--Cast is for changing commission maybe decimal to int, e.g above could also be (o.OrderQuantity * p.ProductPrice+ o.ShippingFee)*0.05 as Commission but would give a decimal value
--The one below gives the same outcome as the same as the above
with OrderDetails as (
select
o.CustomerID,
o.OrderID,
o.OrderQuantity,
p.ProductPrice,
(o.OrderQuantity * p.ProductPrice) as OrderAmount,
((o.OrderQuantity * p.ProductPrice)+o.ShippingFee) as SaleAmount,
cast((o.OrderQuantity * p.ProductPrice+ o.ShippingFee)*0.05 as int) as Commission
from Orders o
join Products p
on o.ProductId=p.ProductID
where o.OrderStatus='Delivered'
),
SalesDetails as (
select s.SaleId, s.EmployeeId, e.EmployeeName, od.Commission
from Sales s
join Employees e on e.EmployeeID=s.Employeeid
join OrderDetails od on od.OrderID=s.OrderID
)
select*from SalesDetails;

--The below query as well has the same outcome as the above(not using the where condition doesnt change the outcone, only that there will be SaleAmount and Commission on all orders
with OrderDetails as (
select
o.CustomerID,
o.OrderID,
o.OrderQuantity,
p.ProductPrice,
(o.OrderQuantity * p.ProductPrice) as OrderAmount,
((o.OrderQuantity * p.ProductPrice)+o.ShippingFee) as SaleAmount,
cast((o.OrderQuantity * p.ProductPrice+ o.ShippingFee)*0.05 as int) as Commission
from Orders o
join Products p
on o.ProductId=p.ProductID
),
SalesDetails as (
select s.SaleId, s.EmployeeId, e.EmployeeName, od.Commission
from Sales s
join Employees e on e.EmployeeID=s.Employeeid
join OrderDetails od on od.OrderID=s.OrderID
)
select*from SalesDetails;

--Indexing is for faster querying
--Clustered index, determines the physical order of data in a table, each table can only have one clustered index, ideal for primary keys and columns frequently used in range searches.
create clustered index idx_CustomerID on Customers(CustomerID);
create clustered index idx_SupplierID on Suppliers(SupplierID);
create clustered index idx_ProductID on Products(ProductID);
create clustered index idx_EmployeeID on Employees(EmployeeID);
create clustered index idx_OrderID on Orders(OrderID);
create clustered index idx_SaleID on Sales(SaleID);

--Creating a temporary table for #OrderDetails
select
	o.OrderID,
	o.CustomerID,
	o.OrderQuantity,
	p.ProductPrice,
	(o.OrderQuantity * p.ProductPrice) as OrderAmount,
	case when o.OrderStatus = 'Delivered' then (o.OrderQuantity * p.ProductPrice + o.ShippingFee) else null end as SaleAmount,
	case when o.OrderStatus = 'Delivered' then cast((o.OrderQuantity * p.ProductPrice + o.ShippingFee) * 0.05 as int) else null end as Commission
into #OrderDetails
from Orders o
join Products p on o.ProductID = p.ProductID;

select*from #OrderDetails;

--Top spenders
select top 3 
	c.CustomerName, 
	od.CustomerID,
	sum(od.SaleAmount) as TotalSpent,
	count(od.OrderID) as TotalOrders
from #OrderDetails od
join Customers c
on od.CustomerID=c.CustomerID
group by od.CustomerID, c.CustomerName
order by TotalSpent desc;

--Frequent buyers
select top 3 
	c.CustomerName, 
	od.CustomerID,
	sum(od.SaleAmount) as TotalSpent, ---not much necessary
	count(od.OrderID) as TotalOrders
from #OrderDetails od
join Customers c
on od.CustomerID=c.CustomerID
group by od.CustomerID, c.CustomerName
order by TotalOrders desc;

--Best selling Product
select
	s.OrderID,
	p.ProductID,
	p.ProductName,
	sum(o.OrderQuantity) as TotalSoldUnits
from Sales s
join Orders o on s.OrderID=o.OrderID
join Products p on p.ProductID=o.ProductID
group by s.OrderID,p.ProductID,p.ProductName
order by TotalSoldUnits desc;

--Invetory levels
with SoldStock as (
select
p.ProductID,
p.ProductName,
s.OrderID,
o.OrderQuantity as SoldQuantity
from Orders o
join Sales s on o.OrderId=s.OrderID
join Products p on p.ProductID=o.ProductID
),
RemainingStock as (
select
distinct p.ProductID,
p.ProductName,
p.StockQuantity-case when so.SoldQuantity is null then 0 else so.SoldQuantity end as RemainingStock
from SoldStock so
right join Products p on so.ProductID=p.ProductID
)
select*from RemainingStock;

--Monthly sales trends for business growth
--This gives the month and date the sale was made, organizes them in months in ascending order
select
format (o.OrderDate, 'yyyy-MM') as Month, 
sum (od.SaleAmount) as TotalSales
from #OrderDetails od
join Orders o on od.OrderID = o.OrderID
group by format(o.OrderDate, 'yyyy-MM')
order by Month asc;

--Employee sales performance based on revenue and commissions
with OrderDetails as(
select 
o.CustomerID ,
o.OrderID,
o.OrderQuantity,
p.ProductPrice,
(o.OrderQuantity * p.ProductPrice) as OrderAmount ,
case when o.OrderStatus= 'Delivered' then ((o.OrderQuantity*p.ProductPrice)+ o.ShippingFee) else null end as SaleAmount,
case when o.OrderStatus= 'Delivered' then cast(((o.OrderQuantity*p.ProductPrice)+ o.ShippingFee)*0.05 as int ) else null end  as Commission
from Orders o
join Products p
on o.ProductID=p.ProductID
),
EmployeeSalePerformance as (
Select
e.EmployeeName,
e.EmployeeID,
count(s.OrderID) as TotalOrders,
sum(od.OrderAmount) as TotalRevenue,
sum(od.Commission) as TotalCommission
from Employees e
join Sales s
on e.EmployeeID=s.EmployeeID
join OrderDetails od
on s.OrderID=od.OrderId
group by e.EmployeeName, e.EmployeeID
)
select*from EmployeeSalePerformance
order by TotalRevenue desc;

--CTE for customer segmentation
with OrderDetails as (
select
o.OrderID,
o.CustomerID,
o.OrderQuantity,
p.ProductPrice,
(o.OrderQuantity * p.ProductPrice) as OrderAmount,
case when o.OrderStatus = 'Delivered' then (o.OrderQuantity * p.ProductPrice + o.ShippingFee) else null end as SaleAmount,
case when o.OrderStatus = 'Delivered' then cast((o.OrderQuantity * p.ProductPrice + o.ShippingFee) * 0.05 as int) else null end as Commission
from Orders o
join Products p on o.ProductID = p.ProductID
),
FrequentBuyers as (
select 
	c.CustomerName, 
	od.CustomerID,
	sum(od.SaleAmount) as TotalSpent,
	count(od.OrderID) as TotalOrders
from OrderDetails od
join Customers c
on od.CustomerID=c.CustomerID
group by od.CustomerID, c.CustomerName
)
select*from FrequentBuyers
order by TotalOrders desc;