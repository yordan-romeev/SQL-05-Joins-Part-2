USE SirmaAcademyJoinDB
GO

-- ## 1: List Detailed Order Information
-- Write a query to display the `OrderID`, `CustomerName`, `EmployeeName` (FirstName and LastName), `ShipperName`, and the total price of all products in the order. Use the `Orders`, `OrderDetails`, `Customers`, `Employees`, `Products`, and `Shippers` tables.

SELECT o.OrderID, c.CustomerName, e.FirstName + ' ' + e.LastName as EmployeeName, s.ShipperName, TotalPrice.Total
FROM Orders o
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Employees e ON e.EmployeeID = o.EmployeeID
    JOIN Shippers s ON s.ShipperID = o.ShipperID
    JOIN (SELECT od.OrderID, SUM(od.Quantity * p.Price) as Total
    FROM OrderDetails od JOIN Products p ON od.ProductID = p.ProductID
    GROUP By od.OrderID) AS TotalPrice ON TotalPrice.OrderID = o.OrderID
