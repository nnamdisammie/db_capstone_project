CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, Cost
FROM Orders
WHERE Quantity > 2;

SELECT
    Customers.CustomerID,
    Customers.CustomerName,
    Orders.OrderID,
    Menus.MenuName,
    MenuItems.ItemName,
    Orders.OrderDate,
    Orders.TotalCost
FROM Customers
JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
JOIN Menus
ON Orders.MenuID = Menus.MenuID
JOIN MenuItems
ON Orders.MenuItemID = MenuItems.MenuItemID
WHERE Orders.TotalCost > 150;

SELECT Menus.MenuName
FROM Menus
WHERE Menus.MenuID = ANY (
    SELECT Orders.MenuID
    FROM Orders
    GROUP BY Orders.MenuID
    HAVING COUNT(*) > 2
);


DELIMITER //

CREATE PROCEDURE GetMaxOrderedQuantity()
BEGIN
    SELECT MAX(Quantity) AS MaxOrderedQuantity
    FROM Orders;
END //

DELIMITER ;


-- Create the prepared statement
PREPARE GetOrderDetailStmt FROM 'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';

-- Declare a variable and assign a value to it
SET @id = 1;

-- Execute the prepared statement with the variable as the input parameter
EXECUTE GetOrderDetailStmt USING @id;

-- Deallocate the prepared statement
DEALLOCATE PREPARE GetOrderDetailStmt;


DELIMITER //

CREATE PROCEDURE CancelOrder(IN orderId INT)
BEGIN
    DELETE FROM Orders WHERE OrderID = orderId;
END //

DELIMITER ;




