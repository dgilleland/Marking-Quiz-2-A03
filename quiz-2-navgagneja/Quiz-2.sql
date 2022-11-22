/* navpreet kaur 
 */

-- Place your solution to the lab in this file.

/* Database Setup */
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'Q2_Fall_2022')
BEGIN
    CREATE DATABASE [Q2_Fall_2022]
END
GO

USE [Q2_Fall_2022]
GO

--Drop Tables
DROP TABLE IF EXISTS OrderDetails
DROP TABLE IF EXISTS Orders
DROP TABLE IF EXISTS Products
DROP TABLE IF EXISTS Customers
DROP TABLE IF EXISTS Deliveries
DROP TABLE IF EXISTS Vehicles
GO

-- PART A - Constraints
-- Add the following constraints to the existing CREATE TABLE definitions (do NOT use the alter table statement in your answer).
-- If you are having difficulties executing the insert script with your constraints, comment out your constraint(s) and continue with the rest of the quiz, or consider doing this question last so it does not interfere with the creation of the tables and inserting the test data. (4 marks)

-- Table        | Column(s)  | Default   | Check
-- Orders       | OrderDate  | GetDate() |   
-- Orders       | PaidYN     | N         | 
-- OrderDetails | Quantity   |           | >= 0
-- Customers    | PostalCode |           | Z9Z9Z9
--
-- - Z means any upper-case character from A to Z
-- - 9 means any digit from 0 to 9


CREATE TABLE Vehicles
(
    VehicleNumber       int
        CONSTRAINT PK_Vehicles_VehicleNumber
            PRIMARY KEY CLUSTERED
                                    NOT NULL,
    DriverFirstName     varchar(35) NOT NULL,
    DriverLastName      varchar(35) NOT NULL
)


CREATE TABLE Deliveries
(
    DeliveryNumber      int
        CONSTRAINT PK_Deliveries_DeliveryNumber
            PRIMARY KEY CLUSTERED   NOT NULL,
    DeliveryDate        datetime    NOT NULL,
    VehicleNumber       int         
        CONSTRAINT FK_Deliveries_VehicleNumber_to_Vehicles_VehicleNumber
            REFERENCES Vehicles (VehicleNumber)
                                    NOT NULL
)
CREATE TABLE Customers
(
    CustomerNumber      int         
        CONSTRAINT PK_Customers_CustomerNumber
            PRIMARY KEY CLUSTERED
                                    NOT NULL,
    FirstName           varchar(35) NOT NULL,
    LastName            varchar(35) NOT NULL,
    StreetAddress       varchar(35) NOT NULL,
    City                varchar(35) NOT NULL,
    Province            char(2)     NOT NULL,
    PostalCode          char(6)     NOT NULL,
    Constraint CK_PostalCode Check (PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
    PhoneNumber         char(12)    NOT NULL
)

CREATE TABLE Products
(
    ProductNumber       char(7)        
        CONSTRAINT PK_Products_ProductNumber
            PRIMARY KEY CLUSTERED
                                        NOT NULL,
    Description         varchar(50)     NOT NULL,
    CurrentPrice        decimal(7,2)    NOT NULL
)

CREATE TABLE Orders
(
    OrderNumber         int             
        CONSTRAINT PK_Orders_OrderNumber
            PRIMARY KEY CLUSTERED
                                        NOT NULL,
    OrderDate           datetime        NOT NULL,
    FloristNumber       int             NOT NULL,
    CustomerNumber      int             
        CONSTRAINT FK_Orders_CustomerNumber_To_Customers_CustomerNumber
            REFERENCES Customers(CustomerNumber)
                                        NOT NULL,
    GSTAmount           decimal (7,2)   NOT NULL,
    DeliveryNumber      int             
        CONSTRAINT FK_Orders_DeliveryNumber_To_Deliveries_DeliveryNumber
            REFERENCES Deliveries(DeliveryNumber)
                                        NOT NULL,
    DeliveredYN         char(1)         NOT NULL,
    PaidYN              char(1)         NOT NULL
    Constraint DF_PaidYN Default 'N' for PaidYN
)

CREATE TABLE OrderDetails
(
    OrderNumber         int       
        CONSTRAINT FK_OrderDetails_OrderNumber_To_Orders_OrderNumber
            REFERENCES Orders (OrderNumber)
                                        NOT NULL,
    ProductNumber       char(7)         
        CONSTRAINT FK_OrderDetails_ProductNumber_To_Products_ProductNumber
            REFERENCES Products (ProductNumber)
                                        NOT NULL,
    Quantity            int             NOT NULL
    Constraint CK_Quantity Check(Quantity >= 0) ,
    SellingPrice        decimal(7,2)    NOT NULL,
    CONSTRAINT PK_OrderDetails_OrderNumber_ProductNumber
        PRIMARY KEY CLUSTERED (OrderNumber, ProductNumber)
)
GO

-- Delete test data
-- Delete From OrderDetails
-- Delete From Orders
-- Delete From Products
-- Delete From Customers
-- Delete From Deliveries
-- Delete From Vehicles
-- Go

-- Insert test data
-- Vehicles
INSERT INTO Vehicles
    (VehicleNumber, DriverFirstName, DriverLastName)
VALUES    
    (1, 'Morgan', 'Freeman'),
    (2, 'Tim', 'Robbins'),
    (3, 'James', 'Whitmore'),
    (4, 'Gil', 'Bellows')

INSERT INTO Deliveries
    (DeliveryNumber, DeliveryDate, VehicleNumber)
VALUES
    (1, 'Sep 10, 2021', 1),
    (2, 'Sep 30, 2022', 2),
    (3, 'Oct 02, 2022', 3),
    (4, 'Oct 15, 2022', 3)

INSERT INTO Customers
    (CustomerNumber, FirstName, LastName, StreetAddress, City, Province, PostalCode, PhoneNumber)
VALUES
    (1,  'Liliana', 'Freeman', '801 Bueller Place', 'Fairview', 'AB', 'T2Z9Z9', '403-142-8498'),
    (2,  'Harvey', 'Little', '60702 Del Sol Trail', 'Morinville', 'AB', 'T5Z9Z9', '587-840-5718'),
    (3,  'Isabel', 'Benson', '4686 Grayhawk Parkway', 'Fort Macleod', 'AB', 'T4Z9Z9', '403-379-4800'),
    (4,  'Emma', 'Ianson', '6 American Ash Hill', 'Sundre', 'AB', 'T6Z9Z9', '825-118-0239'),
    (5,  'Percy', 'Moore', '79287 South Alley', 'Millet', 'AB', 'T6Z9Z9', '780-459-9713'),
    (6,  'Olivia', 'Scott', '35 Sachtjen Alley', 'Barrhead', 'AB', 'T6Z9Z9', '780-287-2272'),
    (7,  'Ivy', 'Fields', '866 Cordelia Parkway', 'Lloydminister', 'SK', 'S7Z9Z9', '639-385-9128'),
    (8,  'Eileen', 'Norburn', '33 Meadow Vale Parkway', 'Fairview', 'AB', 'T7Z9Z9', '587-205-4280'),
    (9,  'Carolyn', 'Forth', '18 Charing Cross Terrace', 'Edson', 'AB', 'T8Z9Z9', '780-726-4784'),
    (10, 'Jackson', 'Whittle', '10746 3rd Sreet', 'Beaumont', 'AB', 'T8Z9Z9', '587-161-6506')


INSERT INTO Products (ProductNumber, Description, CurrentPrice)
VALUES
    ('1701', 'Carnation', 1.50),
    ('1702', 'Long Stem Red Rose', 5.75),
    ('1703', 'Wedding Bouquet', 73.50),
    ('1704', 'Potted plant', 34.50),
    ('1705', 'Cut Flowers', 5.50),
    ('1706', 'Cactus/Succulent', 47.50),
    ('1707', 'Terrarium', 78.50)

INSERT INTO Orders
    (OrderNumber, OrderDate, FloristNumber, CustomerNumber, GSTAmount, DeliveryNumber, DeliveredYN, PaidYN)
VALUES
    (5, 'Sep 08, 2021', 1201, 1, 10.07, 1, 'Y', 'Y')

INSERT INTO OrderDetails
    (OrderNumber, ProductNumber, Quantity, SellingPrice)
VALUES
    (5, '1701', 24, 4.99)


INSERT INTO Orders
    (OrderNumber, OrderDate, FloristNumber, CustomerNumber, GSTAmount, DeliveryNumber, DeliveredYN, PaidYN)
VALUES
    (10, 'Sep 09, 2022', 1520, 1, 10.07, 2, 'Y', 'Y')

INSERT INTO OrderDetails
    (OrderNumber, ProductNumber, Quantity, SellingPrice)
VALUES
    (10, '1701', 24, 4.99)


INSERT INTO Orders
    (OrderNumber, OrderDate, FloristNumber, CustomerNumber, GSTAmount, DeliveryNumber, DeliveredYN, PaidYN)
VALUES
    (15, 'Sep 28, 2022', 502, 2, 20.07, 2, 'Y', 'Y')

INSERT INTO OrderDetails
    (OrderNumber, ProductNumber, Quantity, SellingPrice)
VALUES
    (15, '1702', 12, 12.99),
    (15, '1705', 18, 4.99)


INSERT INTO Orders
    (OrderNumber, OrderDate, FloristNumber, CustomerNumber, GSTAmount, DeliveryNumber, DeliveredYN, PaidYN)
VALUES
    (20, 'Oct 01, 2022', 831, 3, 30.07, 3, 'N', 'Y')

INSERT INTO OrderDetails
    (OrderNumber, ProductNumber, Quantity, SellingPrice)
VALUES
    (20, '1701', 12, 4.99),
    (20, '1702', 12, 12.99),
    (20, '1703', 2, 99.99)

INSERT INTO Orders
    (OrderNumber, OrderDate, FloristNumber, CustomerNumber, GSTAmount, DeliveryNumber, DeliveredYN, PaidYN)
VALUES
    (25, 'Oct 02, 2022', 15204, 3, 40.07, 3, 'N', 'N')

INSERT INTO OrderDetails
    (OrderNumber, ProductNumber, Quantity, SellingPrice)
VALUES
    (25, '1701', 6, 4.99),
    (25, '1702', 6, 15.99),
    (25, '1706', 1, 99.99),
    (25, '1704', 5, 4.44)

INSERT INTO Orders
    (OrderNumber, OrderDate, FloristNumber, CustomerNumber, GSTAmount, DeliveryNumber, DeliveredYN, PaidYN)
VALUES
    (30, 'Oct 25, 2022', 861, 4, 19.99, 3, 'N', 'N')
INSERT INTO OrderDetails
    (OrderNumber, ProductNumber, Quantity, SellingPrice)
VALUES
    (30, '1706', 1, 88.87),
    (30, '1704', 5, 2.88)
GO

-- **********************************************

-- PART B - Indexes
-- (1 mark) Create non clustered indexes on the foreign keys in the OrderDetails table.
-- ANSWER_HERE
Create nonclustered Index ix_OrderNumber
on OrderDetails(OrderNumber)

Create nonclustered Index ix_ProductNumber
on OrderDetails(ProductNumber)

GO


-- PART C - Alter
-- (2 marks) Assuming the tables all have data in them already, use the Alter Table statement to add a nullable column PrepaidCollect to  the Deliveries table. The column will be one character, will be optional, and the only valid values will be 'P' (Prepaid) or 'C' Collect.
-- ANSWER_HERE

alter table deleviries 
add PrepaidCollect varchar(1) null 
constraint df_validValues check (Value = 'P' or Value = 'C')


-- PART D – Queries
-- Execute the Quiz2.sql script to create and populate your tables. You will then be able to test and debug your queries. You may wish to add/update/delete data in the script to fully test your queries.
-- Use only the information you are given, do not hard-code values unless given in the problem statement.

-- 1. (2 Marks) List the order number, customer number, order date and GST amount for all the orders that were paid for but not delivered.

select OrderNumber, CustomerNumber, OrderDate ,GSTAmount from Orders
where PaidYN='Y' and DeliveredYN='N'


-- 2. (3 Marks) We want to know which products sell the most. Select the sum of the quantities sold for each product where the sum is greater than 275. Show the product description and the total quantity ordered.
-- ANSWER_HERE

select sum(quantity) as 'Quantity sold', Description as 'Product Description' from Products
inner join OrderDetails
on Products.ProductNumber=OrderDetails.ProductNumber
group by Description
having sum(Quantity) > 50

-- 3. (2 Marks) A September delivery schedule is needed. Select the driver's full name (as one column), vehicle number and delivery number for all orders in September of the current year (do not hard code the current year).
-- ANSWER_HERE

GO
select DriverFirstName+' '+ DriverLastName as 'Driver Full Name' , Vehicles.VehicleNumber , DeliveryNumber from Vehicles
inner join Deliveries
on Vehicles.VehicleNumber=Deliveries.DeliveryNumber
where Month(DeliveryDate) = 9


-- 4. (4 Marks) We are anticipating a drop in the GST by the federal government. To understand the impact of such a drop, write a query showing totals for each order; only include orders containing the product number 1701. Return the order number, the current GST (the sum of `selling price X quantity X 5%`), and the proposed GST (the sum of `selling price X quantity X 4%`).
-- ANSWER_HERE

select OrderNumber,(sum(SellingPrice)*Quantity*0.05) as 'Current GST', (SUM(SellingPrice)*Quantity*0.04) AS 'Proposed GST' from OrderDetails
where  ProductNumber =1701
group by OrderNumber,Quantity,SellingPrice



-- 5. (3 Marks) We would like to know which city the majority of our northern Alberta customers are from. List the city and the total number of customers who placed an order from that city with postal codes starting with T5 to T9. List the cities alphabetically.
-- ANSWER_HERE

select City,count(*) as 'Number Of Customers' from Customers
inner join Orders
on Customers.CustomerNumber=Orders.CustomerNumber
where PostalCode Between 'T5%' AND 'T9%'
GROUP BY City


-- PART E – Views
-- 1. (2 Marks) Create a view called ProductOrders that contains ProductNumber, Description, CurrentPrice, OrderNumber, Quantity and SellingPrice for all products.
-- ANSWER_HERE


create view or alter view ProductOrders , 
as 
select Products.ProductNumber, Description, CurrentPrice, OrderNumber,Quantity,SellingPrice
from Products inner join OrderDetails
on Products.ProductNumber=OrderDetails.ProductNumber


-- 2. (2 Marks) Using the view ProductOrders, select the Description and the average SellingPrice for each product that has an order.
-- ANSWER_HERE

select description, avg(SellingPrice) as 'Average Selling Price' from ProductOrders
group by Description


-- PART F – DML

-- 1. (2 marks) Decrease the CurrentPrice of all products by 15% that have a Description that starts with C.
-- ANSWER_HERE

 update Products
set CurrentPrice=CurrentPrice-0.15
where Description like 'C%'


-- 2. (2 Marks) Delete all customers who do not have any orders.
-- ANSWER_HERE

delete  Customers
from Customers left outer join Orders
on Customers.CustomerNumber=Orders.CustomerNumber
where OrderNumber is NULL