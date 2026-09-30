/*
===============================================================================
Script Name : 04_Create_Indexes.sql
Author      : Bamidele Akinola
Purpose     : Create indexes to improve query performance in DBA_Lab
===============================================================================
*/

USE DBA_Lab;
GO


/* Create unique index on customer email */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Customers_Email'
      AND object_id = OBJECT_ID(N'dbo.Customers')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_Customers_Email
    ON dbo.Customers(Email);
END;
GO


/* Create index on customer location */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Customers_StateCode'
      AND object_id = OBJECT_ID(N'dbo.Customers')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customers_StateCode
    ON dbo.Customers(StateCode)
    INCLUDE
    (
        FirstName,
        LastName,
        City
    );
END;
GO


/* Create index on product category */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Products_Category'
      AND object_id = OBJECT_ID(N'dbo.Products')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Products_Category
    ON dbo.Products(Category)
    INCLUDE
    (
        ProductName,
        Price,
        QuantityInStock
    );
END;
GO


/* Create index on product name */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Products_ProductName'
      AND object_id = OBJECT_ID(N'dbo.Products')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Products_ProductName
    ON dbo.Products(ProductName);
END;
GO


/* Create index on customer ID in Orders */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Orders_CustomerID'
      AND object_id = OBJECT_ID(N'dbo.Orders')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
    ON dbo.Orders(CustomerID);
END;
GO


/* Create index on order date */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Orders_OrderDate'
      AND object_id = OBJECT_ID(N'dbo.Orders')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
    ON dbo.Orders(OrderDate)
    INCLUDE
    (
        CustomerID,
        OrderStatus,
        TotalAmount
    );
END;
GO


/* Create index on order status */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Orders_OrderStatus'
      AND object_id = OBJECT_ID(N'dbo.Orders')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_OrderStatus
    ON dbo.Orders(OrderStatus);
END;
GO


/* Create index on OrderItems OrderID */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_OrderItems_OrderID'
      AND object_id = OBJECT_ID(N'dbo.OrderItems')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_OrderItems_OrderID
    ON dbo.OrderItems(OrderID);
END;
GO


/* Create index on OrderItems ProductID */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_OrderItems_ProductID'
      AND object_id = OBJECT_ID(N'dbo.OrderItems')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_OrderItems_ProductID
    ON dbo.OrderItems(ProductID);
END;
GO


/* Verify indexes */
SELECT
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique
FROM sys.indexes AS i
WHERE i.object_id IN
(
    OBJECT_ID(N'dbo.Customers'),
    OBJECT_ID(N'dbo.Products'),
    OBJECT_ID(N'dbo.Orders'),
    OBJECT_ID(N'dbo.OrderItems')
)
AND i.name IS NOT NULL
ORDER BY
    TableName,
    IndexName;
GO
