USE SirmaAcademyJoinDB
GO

-- ## 1: List Detailed Order Information
-- Write a query to display the `OrderID`, `CustomerName`, `EmployeeName` (FirstName and LastName), `ShipperName`, and the total price of all products in the order. Use the `Orders`, `OrderDetails`, `Customers`, `Employees`, `Products`, and `Shippers` tables.

SELECT o.OrderID, c.CustomerName, e.FirstName + ' ' + e.LastName as EmployeeName, s.ShipperName, TotalPrice.Total
FROM Orders o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Employees e ON e.EmployeeID = o.EmployeeID
    JOIN Shippers s ON s.ShipperID = o.ShipperID
    JOIN (  SELECT od.OrderID, SUM(od.Quantity * p.Price) as Total
    FROM OrderDetails od JOIN Products p ON od.ProductID = p.ProductID
    GROUP By od.OrderID) AS TotalPrice ON TotalPrice.OrderID = o.OrderID

-- ## 2: Products Supplied by Each Supplier for Specific Customers
-- Write a query to display the `SupplierName`, `ProductName`, `CustomerName`, and the total quantity ordered by the customer. Use the `Orders`, `OrderDetails`, `Products`, `Suppliers`, and `Customers` tables. Group the results by `SupplierName`, `ProductName`, and `CustomerName`.

SELECT s.SupplierName, p.ProductName, c.CustomerName, SUM(od.Quantity) as TotalQuantity
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Suppliers s ON s.SupplierID = p.SupplierID
    JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY s.SupplierName, p.ProductName, c.CustomerName