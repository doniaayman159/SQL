/*
Part B: Data Warehousing & OLAP (50 points)
H.S. designs is an interior design company that specializes in home kitchen designs. The company offers a series of 
seminars for free at home shows, kitchen and appliance stores, and public locations as a way to build its customer 
base. The company earns revenues by selling books and videos that instruct people on kitchen designs. They also 
offer custom-design consulting services. The company has a database that keeps track of its customers, the seminars 
they attended, the contact details, and the purchases made. H.S. Designs will like to build a data warehouse to 
analyze the sales of its products. The fact table for such a data warehouse might be:
Sales (TimeID, CustomerID, ProductNumber, Quantity, UnitPrice, Total)
The TimeID points to the Timeline dimension table with the attributes (TimeID, Date, Month_text, e.g. october, 
Quarter_text, e.g., Qtr 3, Year). The customerID points to the Customer dimension table with the attributes 
(CustomerID, CustomerName, Email, PhoneAreaCode, City, State and ZIP). The ProductNumber points to the 
Product dimension table with the attributes (ProductNumber, ProductType and ProductName). The Quantity
attribute is the number of seminar ordered, the UnitPrice is the cost and the Total is what the customer paid. Using 
the SQL scripts provided, build a data warehouse for H.S. Designs named HSD_DW and insert data to populate the 
tables.
*/
-- 2.  a. Which customer(s) made an order in the past 90 days from May 31, 2018? Provide the 
-- CustomerName and CustomerID, Quantity and Total amounts of the orders.
SELECT c.CustomerName, c.CustomerID, s.Quantity, s.Total
FROM PRODUCT_SALES s
JOIN CUSTOMER c ON s.CustomerID = c.CustomerID
JOIN TIMELINE t ON s.TimeID = t.TimeID
WHERE t.Date >= '2018-03-03' AND t.Date <= '2018-05-31';

-- b. Which customer had an average order greater than the average order of all customers?
SELECT c.CustomerName, c.CustomerID
FROM CUSTOMER c
JOIN PRODUCT_SALES s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerName, c.CustomerID
HAVING AVG(s.Total) > (SELECT AVG(Total) FROM PRODUCT_SALES);

/* c. For each customer, determine the time between the sale of products as 
   Days_between_Product_Sales. Display the Customer ID, Customer Name, Product Number, 
   Product Name, Date, End Date, Days_between_Product_Sales. Consider using the lag function
   and order the result by the CustomerID. */
   SELECT c.CustomerID, c.CustomerName, p.ProductNumber, p.ProductName, t.Date,
   LAG(t.Date) OVER (PARTITION BY s.CustomerID ORDER BY t.Date) AS "End Date",
   DATEDIFF(day, LAG(t.Date) OVER (PARTITION BY s.CustomerID ORDER BY t.Date), t.Date) AS "Days_between_Product_Sales"
   FROM product_sales s
   JOIN customer c ON s.CustomerID = c.CustomerID
   JOIN Product p ON s.ProductNumber = p.ProductNumber
   JOIN timeline t ON s.TimeID = t.TimeID;



-- d. Write SQL query for the ”Roll-Up” operation to summarise the total sales per quarter.
SELECT
    CONCAT(DATEPART(YEAR, t.Date), '-Q', DATEPART(QUARTER, t.Date)) AS Quarter,
    SUM(ps.Total) AS TotalSalesPerQuartar
FROM
    product_sales ps
JOIN
    timeline t ON ps.TimeID = t.TimeID
GROUP BY
    CONCAT(DATEPART(YEAR, t.Date), '-Q', DATEPART(QUARTER, t.Date))
ORDER BY
    Quarter;
