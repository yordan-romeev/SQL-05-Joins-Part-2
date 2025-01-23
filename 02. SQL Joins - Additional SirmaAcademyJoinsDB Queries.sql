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

-- ## 3: Identify Employees Who Handled Orders with Products from Multiple Categories
-- Write a query to find employees (FirstName and LastName) who have processed orders containing products from more than two categories. Use the `Orders`, `OrderDetails`, `Employees`, `Products`, and `Categories` tables.

SELECT DISTINCT e.FirstName, e.LastName
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Employees e ON e.EmployeeID = o.EmployeeID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY o.OrderID, e.FirstName, e.LastName
HAVING COUNT(DISTINCT c.CategoryName) > 2

-- ## 4: Total Revenue by Category and Supplier
-- Write a query to display the total revenue (`Quantity * Price`) generated for each `CategoryName` by each `SupplierName`. Use the `OrderDetails`, `Products`, `Categories`, and `Suppliers` tables. Group the results by `CategoryName` and `SupplierName`.

SELECT c.CategoryName, s.SupplierName , SUM (od.Quantity * p.Price) as TotalRevenue
FROM OrderDetails od
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Categories c ON c.CategoryID = p.CategoryID
    JOIN Suppliers s ON s.SupplierID = p.SupplierID
GROUP BY c.CategoryName, s.SupplierName

