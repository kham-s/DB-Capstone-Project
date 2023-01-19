/* Exercise: Create a virtual table to summarize data */

/* Task 1 */
CREATE VIEW `OrdersView` AS 
SELECT OrderID, Quantity, Cost FROM Orders WHERE Quantity > 2;

/* Task 2 */
SELECT o.CustomerID, c.FullName, o.OrderID, o.Cost, m.MenuName, mi.CourseName
FROM Orders o INNER JOIN Customers c on o.CustomerID = c.CustomerID
INNER JOIN Menus m ON o.MenuID = m.MenuID
INNER JOIN MenuItems mi ON m.MenuItemsID = mi.MenuItemsID
WHERE o.Cost > 150
ORDER BY o.Cost ASC;

/* Task 3 */
SELECT MenuName FROM Menus WHERE menuID = ANY (SELECT DISTINCT MenuID FROM Orders WHERE Quantity > 2);

/* Exercise: Create optimized queries to manage and analyze data */

/* Task 1 */
DELIMITER $$
CREATE PROCEDURE GetMaxQuantity()
BEGIN
SELECT MAX(Quantity) FROM Orders;
END$$
DELIMITER ;

/* Task 2 
   Note that multiple results can be returned as a customer can make multiple orders…
   This is the case if you loaded my fixtures file.
*/
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, Cost FROM Orders WHERE CustomerID = ?';
set @id = 1;
Execute GetOrderDetail using @id;

/* Task 3 */
CREATE PROCEDURE CancelOrder(IN id INT)
BEGIN
DELETE FROM Orders WHERE OrderID = id;
SELECT CONCAT("Order ", id, " is cancelled") AS Confirmation;
END
