/*
===============================================================================
Script Name : 02_Create_Tables.sql
Author      : Bamidele Akinola
Purpose     : Create sample tables inside the DBA_Lab database
===============================================================================
*/

USE DBA_Lab;
GO

/* Create Customers table */
IF OBJECT_ID(N'dbo.Customers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers
    (
        CustomerID INT IDENTITY(1,1) NOT NULL,
        FirstName VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        Email VARCHAR(150) NOT NULL,
        Phone VARCHAR(25) NULL,
        City VARCHAR(100) NULL,
        StateCode CHAR(2) NULL,
        CreatedDate DATETIME2 NOT NULL
            CONSTRAINT DF_Customers_CreatedDate DEFAULT SYSDATETIME(),

        CONSTRAINT PK_Customers
            PRIMARY KEY CLUSTERED (CustomerID)
    );
END;
GO


/* Create Products table */
IF OBJECT_ID(N'dbo.Products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Products
    (
        ProductID INT IDENTITY(1,1) NOT NULL,
        ProductName VARCHAR(150) NOT NULL,
        Category VARCHAR(100) NULL,
        Price DECIMAL(10,2) NOT NULL,
        QuantityInStock INT NOT NULL,
        IsActive BIT NOT NULL
            CONSTRAINT DF_Products_IsActive DEFAULT 1,
        CreatedDate DATETIME2 NOT NULL
            CONSTRAINT DF_Products_CreatedDate DEFAULT SYSDATETIME(),

        CONSTRAINT PK_Products
            PRIMARY KEY CLUSTERED (ProductID)
    );
END;
GO


/* Create Orders table */
IF OBJECT_ID(N'dbo.Orders', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Orders
    (
        OrderID INT IDENTITY(1,1) NOT NULL,
        CustomerID INT NOT NULL,
        OrderDate DATETIME2 NOT NULL
            CONSTRAINT DF_Orders_OrderDate DEFAULT SYSDATETIME(),
        OrderStatus VARCHAR(30) NOT NULL,
        TotalAmount DECIMAL(12,2) NOT NULL,

        CONSTRAINT PK_Orders
            PRIMARY KEY CLUSTERED (OrderID),

        CONSTRAINT FK_Orders_Customers
            FOREIGN KEY (CustomerID)
            REFERENCES dbo.Customers(CustomerID)
    );
END;
GO


/* Create OrderItems table */
IF OBJECT_ID(N'dbo.OrderItems', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderItems
    (
        OrderItemID INT IDENTITY(1,1) NOT NULL,
        OrderID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10,2) NOT NULL,

        CONSTRAINT PK_OrderItems
            PRIMARY KEY CLUSTERED (OrderItemID),

        CONSTRAINT FK_OrderItems_Orders
            FOREIGN KEY (OrderID)
            REFERENCES dbo.Orders(OrderID),

        CONSTRAINT FK_OrderItems_Products
            FOREIGN KEY (ProductID)
            REFERENCES dbo.Products(ProductID)
    );
END;
GO


/* Verify tables */
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
