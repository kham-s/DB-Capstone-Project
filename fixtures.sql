/* Some fixtures to execute the queries on */
INSERT into MenuItems (MenuitemsID, CourseName, StarterName, DesertName) VALUES
(1, "Kabasa", "Kabasa", "Lokum"),
(2, "Greek Salad", "Greek Salad", "Baklavas"),
(3, "Aperitivo", "Aperitivo", "None");

INSERT into Menus (MenuID, menuitemsID, MenuName, Cuisine, Cost) VALUES
(1, 1, "Manti", "Turk", 50.00),
(2, 2, "Moussaka", "Greek", 66.66),
(3, 3, "Aperitivo", "Italian", 30.00);

INSERT into Customers (CustomerID,FullName, Email, ContactNumber) VALUES 
(1,"Vanessa McCarthy", "janedoe@mail.com", "123456798"),
(2,"Marcos Romero", "marcos@mail.com", "123456789");


INSERT into Orders (OrderID, CustomerID,MenuID, Quantity, Cost) VALUES
(1,1,1,5,250.00),
(2,2,2,3,200.00),
(3,1,2,1,66.66),
(4,1,3,1, 30.00),
(5,2,3,3, 60.00);