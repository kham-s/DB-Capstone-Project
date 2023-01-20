/* Exercise: Create a virtual table to summarize data */

/* Task 1 */
CREATE VIEW OrdersView AS 
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
DELIMITER $$
CREATE PROCEDURE CancelOrder(IN id INT)
BEGIN
DELETE FROM Orders WHERE OrderID = id;
SELECT CONCAT("Order ", id, " is cancelled") AS Confirmation;
END$$
DELIMITER ;
/* Exercise: Create SQL queries to check available bookings based on user input */

/* Task 1 
   Fixtures have been updated to insert one staff member to validate integrity constraint on StaffID.
   Insert statements to answer exercise are put here but are also in the fixtures files.
*/

INSERT into Bookings (BookingID, BookingDate, TableNumber, CustomerID, StaffID) VALUES
(1, '2022-10-10', 5, 1, 1),
(2, '2022-11-12', 3, 3, 1),
(3, '2022-10-11', 2, 2, 1),
(4, '2022-10-13', 2, 1, 1);

/* For validation purpose, the following query can be run and output the expected result */
SELECT BookingID, BookingDate, TableNumber, CustomerID from Bookings;

/* Task 2 */
CREATE PROCEDURE CheckBooking(IN dt DATE, IN tb INT)
BEGIN
    IF EXISTS(SELECT BookingID FROM Bookings WHERE BookingDATE = dt AND tableNumber = tb) THEN
		SELECT CONCAT("Table ", tb, " is already booked - booking cancelled") AS 'Booking status';
	ELSE
		SELECT CONCAT("Table ", tb, " not booked") AS 'Booking status';
	END IF;
END

/* Calling the procedure give similar output */
call CheckBooking("2022-11-12", 3);

/* Task 3
   Data model changed to conform to exercise (I have created BookingSlot 'TIME' instead of BookingDate 'DATE' and changed TableNo field to TableNumber).
   I wished the specifications were more precise at the beginning of the exercise…
   It is asked that the procedure includes two input parameters, the booking date and the table number.
   But for a booking to pass integrity constraints (as I have specified the following fields as NOT NULL), a CustomerID and a StaffID must be included.
   For this exercise purpose, I just hardcoded CustomerID = 1 and StaffID = 1.
   I also changed BookingID to be generated automatically by setting it to AUTO INCREMENT so I don't have to query for next value.
 */
 DELIMITER $$
 CREATE PROCEDURE ManageBooking(IN dt DATE, IN tb INT)
BEGIN
	START TRANSACTION;
    INSERT INTO Bookings (CustomerID, StaffID, BookingDate, TableNumber) VALUES
    (1, 1, dt, tb);
    IF EXISTS(SELECT BookingID FROM Bookings WHERE BookingDATE = dt AND tableNumber = tb) THEN	
        ROLLBACK;
        SELECT CONCAT("Table ", tb, " is already booked - booking cancelled") AS 'Booking status';
	ELSE
		COMMIT;
		SELECT CONCAT("Table ", tb, " not booked - new booking made") AS 'Booking status';
	END IF;
END $$
DELIMITER ;

 /* Calling the procedure give similar output */
call ManageBooking("2022-10-10", 5);

/* Exercise: Create SQL queries to add and update bookings */

/* Task 1 
   I hardcoded StaffID for integrity constraint check to follow the procedure specification.
*/
 DELIMITER $$
CREATE PROCEDURE MakeBooking(IN bID INT, IN cID INT, IN tb INT, IN dt DATE)
BEGIN
	START TRANSACTION;
   INSERT INTO Bookings (BookingID, CustomerID, StaffID, BookingDate, TableNumber) VALUES
   (bID, cID, 1, dt, tb);
	COMMIT;
   SELECT "New booking added" AS Confirmation;
END $$
DELIMITER ;

/* Calling the procedure shows confirmation as asked */
call MakeBooking(9, 4, 5, "2022-12-10");

/* Task 2 */
DELIMITER $$
CREATE PROCEDURE `UpdateBooking` (IN bID INT, IN bDate DATE)
BEGIN
	Update Bookings SET BookingDate = bDate WHERE BookingID = bID;
END$$
DELIMITER ;

 /* Calling the procedure shows the previous booking date has been updated */
call ManageBooking("2022-10-10", 5);

/* Task 3 */
DELIMITER $$
CREATE PROCEDURE `CancelBooking` (IN bID INT)
BEGIN
	DELETE FROM Bookings WHERE BookingID = bID;
   SELECT CONCAT("Booking ", bID, " cancelled" AS Confirmation;
END$$
DELIMITER ;

/* Calling the procedure shows confirmation.
   A select statement also doesn't return any row
 */
call CancelBooking(9);
select * from Bookings where BookingID = 9;