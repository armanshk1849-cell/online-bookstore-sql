CREATE TABLE Books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(50),
Genre VARCHAR (100),
Published_Year DATE,
Price NUMERIC (10,2),
Stock INT
);

SELECT * FROM Books;

DROP TABLE Books

COPY books
FROM 'C:/Program Files/PostgreSQL/18/data/Books.csv'
DELIMITER ','
CSV HEADER;
 

--Wanted to alter data type from date to INT(USING NULL was IMP coz date and int are not cmpatible to replace)
ALTER TABLE Books
ALTER COLUMN Published_year TYPE INT USING NULL;


ALTER TABLE Books
ALTER COLUMN Title TYPE VARCHAR (100);

CREATE TABLE Customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR (100),
Email VARCHAR (100),
Phone VARCHAR(15),
City VARCHAR (100),
Country VARCHAR(100)
);

SELECT * FROM Customers

DROP TABLE Customers

--Wanted to alter data type from VARCHAR to INT(USING NULL was IMP coz varchar and int are not cmpatible to replace)
ALTER TABLE Customers
ALTER COLUMN Phone TYPE VARCHAR (15);

CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_date DATE,
Quantity INT,
Amount NUMERIC (10,2)
);

COPY Orders
FROM  'C:\Program Files\PostgreSQL\18\data\Orders.csv'
DELIMITER ','
CSV header;

ALTER TABLE Orders
ALTER COLUMN Order_id TYPE INT;

DROP TABLE Orders

SELECT * FROM Orders

--select all 3
SELECT * FROM Books
SELECT * FROM Orders
SELECT * FROM Customers

--1.list of customers who have atleast placed 2 orders(group by used because customer_id is duplicate)

SELECT customer_id, COUNT (order_id)
FROM Orders
GROUP BY customer_id
HAVING COUNT (order_id)>=2

--2. retrieve total number of books from each genre(TOTAL numbers = SUM and EACH = GROUP BY)

SELECT SUM(o.quantity), b.genre
FROM Orders o
JOIN Books b 
ON o.book_id=b.book_id
GROUP BY b.genre

--3.find avg price of fantasy genre

SELECT AVG(price) 
FROM Books 
WHERE genre='Fantasy'

--4.list of customers name who have atleast placed 2 orders(group by used because customer_id is duplicate)

SELECT  c.name, COUNT (o.order_id)
FROM Orders o
join Customers c ON c.customer_id=o.customer_id
GROUP BY  c.name
HAVING COUNT (o.order_id)>=2


--5. most recently ordered book

SELECT o.order_date, b.title
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
ORDER BY o.order_date DESc
LIMIT 1

--6. most frequently ordered book

SELECT book_id, COUNT(order_id)
FROM Orders
GROUP BY (book_id)
ORDER BY COUNT(order_id) DESC
LIMIT 1


--7. most frequently ordered book(name)

SELECT b.title, COUNT(o.order_id)
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY (b.title)
ORDER BY COUNT(o.order_id) DESC
LIMIT 1

--8. TOP 3 most expensive books in fantasy genre

SELECT title,price,author
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3

--9.Retrieve the total quantity of books sold by the author

SELECT SUM(o.quantity), b.author
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY (b.author)

--10.list the cities where the customer have spent over 30 USD
SELECT * FROM Books
SELECT * FROM Orders
SELECT * FROM Customers

SELECT sum(o.amount), c.city
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.city
HAVING SUM(o.amount) >30

--11.Find the customer who spent the most on orders

SELECT c.name, SUM(o.amount)
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.name
ORDER BY SUM(o.amount) DESC
LIMIT 1

--12. Calculate the stock remaining after fullfilling all the orders

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS ORDER_QTY,
       b.stock - COALESCE(SUM(o.quantity),0) AS REMAINING_QTY
FROM Books b
LEFT JOIN Orders o ON o.book_id=b.book_id
GROUP BY b.book_id
ORDER BY b.book_id asc












