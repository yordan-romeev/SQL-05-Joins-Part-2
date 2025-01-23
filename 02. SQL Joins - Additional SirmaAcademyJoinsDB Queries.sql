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
            GROUP By od.OrderID ) AS TotalPrice ON TotalPrice.OrderID = o.OrderID

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

-- ## 5: Orders with Products from a Specific Supplier
-- Write a query to display the `OrderID`, `OrderDate`, `CustomerName`, and the `ProductName` of products ordered from a specific `SupplierName`. Use the `Orders`, `OrderDetails`, `Products`, `Suppliers`, and `Customers` tables.

SELECT o.OrderID, o.OrderDate, c.CustomerName, p.ProductName
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Suppliers s ON s.SupplierID = p.SupplierID
    JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE s.SupplierName = 'Forêts d''érables'

-- ## 6: Customers Who Ordered the Most Expensive Products
-- Write a query to find the `CustomerName`, `OrderID`, and `ProductName` for customers who ordered products with prices higher than the average price of all products. Use the `Orders`, `OrderDetails`, `Customers`, and `Products` tables.

SELECT c.CustomerName, o.OrderID, p.ProductName
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Customers c ON c.CustomerID = o.CustomerID
    JOIN Products p ON p.ProductID = od.ProductID
WHERE p.Price > (SELECT AVG(Price) FROM Products)

-- ## 7: Find Orders with the Most Product Categories
-- Write a query to list the `OrderID` and the number of distinct product categories ordered in each order. Include the `CustomerName` and the `EmployeeName` (FirstName and LastName). Use the `Orders`, `OrderDetails`, `Products`, `Categories`, `Customers`, and `Employees` tables.

SELECT o.OrderID, COUNT(DISTINCT c.CategoryName) as CategoriesInOrder, cs.CustomerName, e.FirstName + ' ' + e.LastName AS EmployeeName
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Employees e ON e.EmployeeID = o.EmployeeID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Categories c ON c.CategoryID = p.CategoryID
    JOIN Customers cs ON cs.CustomerID = o.CustomerID
GROUP BY o.OrderID, cs.CustomerName,  e.FirstName, e.LastName
ORDER BY CategoriesInOrder DESC

-- ## 8: Shippers Who Transported Products from a Specific Category
-- Write a query to find the `ShipperName`, `ProductName`, and total quantity of products transported in the `CategoryName` "Beverages." Use the `Orders`, `OrderDetails`, `Products`, `Categories`, and `Shippers` tables.

SELECT s.ShipperName, p.ProductName, SUM(od.Quantity) AS TotalQuantity
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Categories c ON c.CategoryID = p.CategoryID
    JOIN Shippers s ON s.ShipperID = o.ShipperID
WHERE c.CategoryName = 'Beverages'
GROUP BY s.ShipperName, p.ProductName

-- ## 9: Analyze Customer Spending Across Categories
-- Write a query to display the `CustomerName`, `CategoryName`, and the total amount spent (`Quantity * Price`) by each customer in each category. Use the `Orders`, `OrderDetails`, `Products`, `Categories`, and `Customers` tables.

SELECT cs.CustomerName, ct.CategoryName, SUM(od.Quantity * p.Price) AS TotalAmountSpent
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Categories ct ON ct.CategoryID = p.CategoryID
    JOIN Customers cs ON cs.CustomerID = o.CustomerID
GROUP BY cs.CustomerName, ct.CategoryName
ORDER BY cs.CustomerName, ct.CategoryName

-- ## 10: Suppliers with Revenue Contributions by Employee
-- Write a query to display the `SupplierName`, `EmployeeName` (FirstName and LastName), and the total revenue generated by that supplier through orders processed by the employee. Use the `Orders`, `OrderDetails`, `Products`, `Suppliers`, and `Employees` tables.

SELECT s.SupplierName, e.FirstName + ' ' + e.LastName as EmployeeName, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Suppliers s ON s.SupplierID = p.SupplierID
    JOIN Employees e ON e.EmployeeID = o.EmployeeID
GROUP BY s.SupplierName, e.FirstName, e.LastName