/*
===============================================================================
Script Name : 03_Insert_Sample_Data.sql
Author      : Bamidele Akinola
Purpose     : Insert sample data into the DBA_Lab database
===============================================================================
*/

USE DBA_Lab;
GO


/* Insert sample customers */
INSERT INTO dbo.Customers
(
    FirstName,
    LastName,
    Email,
    Phone,
    City,
    StateCode
)
VALUES
('Michael', 'Akinola', 'michael.akinola@example.com', '2145550101', 'Dallas', 'TX'),
('Sarah', 'Johnson', 'sarah.johnson@example.com', '4695550102', 'Plano', 'TX'),
('David', 'Williams', 'david.williams@example.com', '9725550103', 'Irving', 'TX'),
('Jessica', 'Brown', 'jessica.brown@example.com', '8175550104', 'Arlington', 'TX'),
('James', 'Davis', 'james.davis@example.com', '2145550105', 'Dallas', 'TX');
GO


/* Insert sample products */
INSERT INTO dbo.Products
(
    ProductName,
    Category,
    Price,
    QuantityInStock
)
VALUES
('Classic T-Shirt', 'Shirts', 29.99, 100),
('Premium Hoodie', 'Hoodies', 69.99, 75),
('Denim Jacket', 'Jackets', 89.99, 40),
('Slim Fit Jeans', 'Pants', 59.99, 60),
('Baseball Cap', 'Accessories', 24.99, 120),
('Crewneck Sweatshirt', 'Sweatshirts', 54.99, 50);
GO


/* Insert sample orders */
INSERT INTO dbo.Orders
(
    CustomerID,
    OrderDate,
    OrderStatus,
    TotalAmount
)
VALUES
(1, '2026-09-20', 'Completed', 99.98),
(2, '2026-09-21', 'Completed', 69.99),
(3, '2026-09-22', 'Pending', 149.98),
(4, '2026-09-23', 'Completed', 59.99),
(5, '2026-09-24', 'Processing', 114.98);
GO


/* Insert sample order items */
INSERT INTO dbo.OrderItems
(
    OrderID,
    ProductID,
    Quantity,
    UnitPrice
)
VALUES
(1, 1, 1, 29.99),
(1, 2, 1, 69.99),

(2, 2, 1, 69.99),

(3, 3, 1, 89.99),
(3, 4, 1, 59.99),

(4, 4, 1, 59.99),

(5, 5, 1, 24.99),
(5, 6, 1, 54.99),
(5, 1, 1, 29.99);
GO


/* Verify inserted data */

SELECT * FROM dbo.Customers;
GO

SELECT * FROM dbo.Products;
GO

SELECT * FROM dbo.Orders;
GO

SELECT * FROM dbo.OrderItems;
GO
