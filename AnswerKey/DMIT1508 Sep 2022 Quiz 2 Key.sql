Use Quiz2
Go

--Drop Tables
Drop Table OrderDetails
Drop Table Orders
Drop Table Products
Drop Table Customers
Drop Table Deliveries
Drop Table Vehicles
Go

-- PART A - Constraints
-- Add the following constraints to the existing create table definitions (do NOT use the alter table statement).
-- If you are having difficulties executing the insert script with your constraints, comment out your constraint(s) and continue with the rest of the quiz, or consider doing this question last so it does not interfere with the creation of the tables and inserting the test data. (4 marks)

-- Table		Column(s)	Default		Check
-- Orders		OrderDate	GetDate()	
-- Orders		PaidYN		N	
-- OrderDetails	Quantity				>=0
-- Customers	PostalCode				Z9Z9Z9

-- Z means any upper-case character from A to Z
-- 9 means any digit from 0 to 9


Create Table Vehicles
	(
	VehicleNumber		int 				not null
											Constraint PK_Vehicles_VehicleNumber
												Primary Key Clustered,
	DriverFirstName		varchar (35)		not null,
	DriverLastName		varchar (35)		not null
	)


Create Table Deliveries
	(
	DeliveryNumber		int 				not null
											Constraint PK_Deliveries_DeliveryNumber
												Primary Key Clustered,
	DeliveryDate		datetime			not null,
	VehicleNumber		int					not null
											Constraint FK_Deliveries_VehicleNumber_to_Vehicles_VehicleNumber
												References Vehicles (VehicleNumber)
	)
Create Table Customers
	(
	CustomerNumber		int 				not null
											Constraint PK_Customers_CustomerNumber
												Primary Key Clustered,
	FirstName			varchar (35)		not null,
	LastName			varchar (35)		not null,
	StreetAddress		varchar (35)		not null,
	City				varchar (35)		not null,
	Province			char (2)			not null,
	PostalCode			char (6)			not null
-- new constraint
											Constraint CK_Customers_PostalCode
												Check (PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
-- new constraint
	PhoneNumber			char (12)			not null
	)

Create Table Products
	(
	ProductNumber 		char (7)			not null
											Constraint PK_Products_ProductNumber
												Primary Key Clustered,
	Description			varchar (50)		not null,
	CurrentPrice		decimal (7,2)		not null
	)

Create Table Orders
	(
	OrderNumber			int					not null
											Constraint PK_Orders_OrderNumber
												Primary Key Clustered,
	OrderDate			datetime			not null
-- new constraint
											Constraint DF_Orders_OrderDate_GetDate
												Default GetDate(),
-- new constraint
	FloristNumber		int					not null,
	CustomerNumber		int					not null
											Constraint FK_Orders_CustomerNumber_To_Customers_CustomerNumber
												References Customers (CustomerNumber),
	GSTAmount			decimal (7,2)		not null,
	DeliveryNumber		int					not null
											Constraint FK_Orders_DeliveryNumber_To_Deliveries_DeliveryNumber
												References Deliveries (DeliveryNumber),
	DeliveredYN			char (1)			not null,
	PaidYN				char (1)			not null
-- new constraint
											Constraint DF_Orders_PaidYN_N
												Default 'N'
-- new constraint
	)

Create Table OrderDetails
	(
	OrderNumber			int					not null
											Constraint FK_OrderDetails_OrderNumber_To_Orders_OrderNumber
												References Orders (OrderNumber),
	ProductNumber		char (7)			not null
											Constraint FK_OrderDetails_ProductNumber_To_Products_ProductNumber
												References Products (ProductNumber),
	Quantity			int					not null
-- new constraint
											Constraint CK_OrderDetails_Quantity_GR_EQ_Zero
												Check (Quantity >= 0),
-- new constraint
	SellingPrice		decimal (7,2)		not null,
	Constraint PK_OrderDetails_OrderNumber_ProductNumber
		Primary Key Clustered (OrderNumber, ProductNumber)
	)

-- (1 mark) PART B - Indexes
-- Create non clustered indexes on the foreign keys in the OrderDetails table.

Create nonclustered Index IX_OrderDetails_OrderNumber On OrderDetails (OrderNumber)
Create nonclustered Index IX_OrderDetails_ProductNumber On OrderDetails (ProductNumber)

-- (2 mark)	PART C - Alter
--	Assuming the tables all have data in them already, use the Alter Table statement to add a column 
--	PrepaidCollect to the Deliveries table. The column will be one character, will be optional when 
--	inserting data, and the only valid values will be 'P' (Prepaid) or 'C' Collect.

	Alter Table Deliveries
		Add	PrepaidCollect	Char (1)	null
			Constraint CK_PrepaidCollect_PC 
				Check (PrepaidCollect IN ('P','C'))
	Go
	-- or --
	
	Alter Table Deliveries
		Add	PrepaidCollect	Char (1)	null
	GO	-- mandatory if using two statements
	Alter Table Deliveries
		Add	Constraint CK_PrepaidCollect_PC 
			Check (PrepaidCollect IN ('P','C'))
	Go


-- (/14) PART D – Queries
--	Execute the Quiz2.sql script to create and populate your tables. You will then be able to test and debug your queries. 
--	You may wish to add/update/delete data in the script to fully test your queries.
--	Use only the information you are given, do not hard-code values unless given.

-- 1. (2 Marks) List the order number, customer number, order date and GST amount for all the orders that were paid for but 
--		not delivered.
	Select	OrderNumber, CustomerNumber, OrderDate, GSTAmount
	From	Orders
	Where	PaidYN = 'Y' And
			DeliveredYN = 'N'
--	OrderNumber	CustomerNumber	OrderDate				GSTAmount
--	20			3				2022-10-01 00:00:00.000	30.07

-- 2. (3 Marks) We want to know which products sell the most. Select the sum of the quantities sold for each product where the 
--		sum is greater than 50. Show the product description and the total quantity ordered.
	Select	P.Description, Sum (OD.Quantity) "Quantity Sold"
	From	Products P
		Inner Join OrderDetails OD
			On P.ProductNumber = OD.ProductNumber
	Group By P.Description
	Having	Sum (OD.Quantity) > 50

--	Description	Quantity Sold
--	Carnation		66

--3. (2 Marks) A September delivery schedule is needed. Select the driver's full name (as one column), vehicle number and 
--		delivery number for all orders in September of the current year (do not hard code the current year).
	Select	V.DriverFirstName + ' ' + V.DriverLastName "Driver Name", V.VehicleNumber, D.DeliveryNumber
	From	Vehicles V
				Inner Join Deliveries D
					On V.VehicleNumber = D.VehicleNumber
	Where	Year(D.DeliveryDate) = Year(GetDate()) And
			DATENAME(mm, D.DeliveryDate) = 'September'

--	Driver Name	VehicleNumber	DeliveryNumber
--	Tim Robbins	2				2

--4. (4 Marks) We are anticipating a drop in the GST. For each order containing the product number 1701; select the 
--		order number, the current GST (the sum of selling price * quantity * 5%), and the proposed GST 
--		(the sum of selling price * quantity * 4%).
    Select	OrderNumber,
            Sum (SellingPrice * Quantity * .05) "Current GST",
            Sum (SellingPrice * Quantity * .04) "Proposed GST"
    From    OrderDetails 
    Where   ProductNumber = '1701'
    Group By OrderNumber


--	OrderNumber	Current	GST	Proposed GST
--	5			8.3832		5.9880
--	10			8.3832		5.9880
--	20			4.1916		2.9940
--	25			2.0958		1.4970

--5. (3 Marks) We would like to know which city the majority of our northern Alberta customers are from. List the city 
--		and the total number of customers who placed an order from that city with postal codes starting with 
--		T5 to T9. List the cities alphabetically.
	Select	C.City, COUNT (C.CustomerNumber) "Total Number of Customers"
	From	Customers C 
				Inner Join Orders O 
					ON C.CustomerNumber = O.CustomerNumber
	Where	C.PostalCode like 'T[5-9]%'
	Group By C.City
	Order By C.City

--	City			Total Number of Customers
--	Morinville	1
--	Sundre		1

-- (/4) PART E – Views
-- 1. (2 Marks) Create a view called ProductOrders that contains ProductNumber, Description, CurrentPrice, OrderNumber, 
--		Quantity and SellingPrice for all products.
Go
Create View ProductOrders
As
Select	PR.ProductNumber, PR.Description, PR.CurrentPrice, OD.OrderNumber, OD.Quantity, OD.SellingPrice
From	Products PR
			Left Outer Join OrderDetails OD
				On PR.ProductNumber = OD.ProductNumber
Go

-- 2. (2 Marks) Using the view ProductOrders, select the Description and the average SellingPrice for each product that 
--		has an order.
Select	Description, AVG(SellingPrice)  "Average Selling Price"
From	ProductOrders
Where	OrderNumber is not null
Group By Description

--	Description	Average Selling Price
--	Cactus/Succulent	94.430000
--	Carnation			4.990000
--	Cut Flowers			4.990000
--	Long Stem Red Rose	13.990000
--	Potted plant		3.660000
--	Wedding Bouquet		99.990000

--	This record should not show
--	Description			Average Selling Price
--	Terrarium			NULL

-- (/4) PART F – DML

-- 1. (2 marks) Decrease the CurrentPrice of all products by 15% that have a Description that starts with C.
Update	Products
Set		CurrentPrice = CurrentPrice * 0.85
Where	Description like 'C%'
Go
--	Items Before
--	ProductNumber	Description			CurrentPrice
--	1701   			Carnation			1.50
--	1705   			Cut Flowers			5.50
--	1706   			Cactus/Succulent	47.50

--	3 items updated

--	Items After
--	ProductNumber	Description			CurrentPrice
--	1701   			Carnation			1.28
--	1705   			Cut Flowers			4.68
--	1706   			Cactus/Succulent	40.38

--	2. (2 Marks) Delete all customers who do not have any orders.
Delete From Customers
Where	CustomerNumber Not In	(Select	CustomerNumber
								 From	Orders)
Go

--	6 rows deleted

--	Deleted rows
--	CustomerNumber	FirstName	LastName	StreetAddress				City			Province	PostalCode	PhoneNumber
--	5				Percy		Moore		79287 South Alley			Millet			AB			T6Z9Z9		780-459-9713
--	6				Olivia		Scott		35 Sachtjen Alley			arrhead			AB			T6Z9Z9		780-287-2272
--	7				Ivy			Fields		866 Cordelia Parkway		Lloydminister	SK			S7Z9Z9		639-385-9128
--	8				Eileen		Norburn		33 Meadow Vale Parkway		Fairview		AB			T7Z9Z9		587-205-4280
--	9				Carolyn		Forth		18 Charing Cross Terrace	Edson			AB			T8Z9Z9		780-726-4784
--	10				Jackson		Whittle		10746 3rd Sreet				Beaumont		AB			T8Z9Z9		587-161-6506

--	Rows left in table
--	CustomerNumber	FirstName	LastName	StreetAddress				City			Province	PostalCode	PhoneNumber
--	1				Liliana		Freeman		801 Bueller Place			Fairview		AB			T2Z9Z9		403-142-8498
--	2				Harvey		Little		60702 Del Sol Trail			Morinville		AB			T5Z9Z9		587-840-5718
--	3				Isabel		Benson		4686 Grayhawk Parkway		Fort Macleod	AB			T4Z9Z9		403-379-4800
--	4				Emma		Ianson		6 American Ash Hill			Sundre			AB			T6Z9Z9		825-118-0239
