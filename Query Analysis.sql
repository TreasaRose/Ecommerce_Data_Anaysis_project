
--1:List all unique states where sellers are located.
SELECT DISTINCT SELLER_STATE as unique_state
FROM Sellers;
--Explanation: This query lists all unique states from the Sellers table where sellers are located by selecting distinct values from the SELLER_STATE column.

--2:Count the number of orders shipped in 2018.
SELECT COUNT(order_id) as number_of_orders_2018
FROM Orders
WHERE YEAR(order_purchase_timestamp) = 2018;
--Explanation: Counts the number of orders placed in 2018 by filtering the Orders table where the order_purchase_timestamp is in 2018.

--3:Find the total sales amount for each product category.
SELECT UPPER(PRODUCTS.product_category_name) as product_category,
    SUM("Order Payments".PAYMENT_VALUE) AS TOTAL_SALES
FROM PRODUCTS
JOIN "Order Items" ON PRODUCTS.PRODUCT_ID = "Order Items".PRODUCT_ID
JOIN "Order Payments" ON "Order Payments".ORDER_ID = "Order Items".ORDER_ID
GROUP BY product_category_name;
--Explanation: Calculates the total sales for each product category by joining the PRODUCTS, Order Items, and Order Payments tables. Sales are grouped by product_category_name.

--4:Calculate the percentage of orders delivered on weekends.
SELECT ROUND(100.0 * SUM(
    CASE WHEN DATEPART(WEEKDAY, order_delivered_customer_date) IN (1, 7) THEN 1
    ELSE 0 END) / COUNT(*), 2) AS PERCENTAGE_DELIVERED_ON_WEEKENDS
FROM ORDERS;
--Explanation: This query calculates the percentage of orders delivered on weekends by checking if the delivery date falls on Saturday (7) or Sunday (1) and dividing by the total count.

--5:Count the number of orders placed by customers from each city.
SELECT CUSTOMER_CITY,COUNT(ORDER_ID) AS ORDER_COUNT
FROM CUSTOMERS
JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
GROUP BY CUSTOMER_CITY
ORDER BY ORDER_COUNT DESC;
--Explanation: Lists the count of orders placed by customers from each city by joining CUSTOMERS and ORDERS and grouping by CUSTOMER_CITY.

--6: List of all orders with customer details and order status
SELECT Orders.order_id, Orders.order_status, Customers.customer_id, Customers.customer_city
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id;
--Explanation: Retrieves each order with its status and related customer details by joining Orders and Customers.

--7: List of all products sold by a particular seller
SELECT Products.product_category_name, Sellers.seller_id, "Order Items".price
FROM "Order Items"
JOIN Products ON "Order Items".product_id = Products.product_id
JOIN Sellers ON "Order Items".seller_id = Sellers.seller_id
WHERE Sellers.seller_id = '1464afc72f696af775557a821c2e253f';
--Explanation: Lists products sold by a specific seller by filtering Sellers with the specified seller ID and joining relevant tables.

--8: Total sales revenue by payment type
SELECT payment_type, SUM(payment_value) AS total_revenue
FROM "Order Payments"
GROUP BY payment_type;
--Explanation: Summarizes revenue generated by each payment type by grouping and summing payment_value in the Order Payments table.

--9: Average review score per product
SELECT Products.product_category_name, AVG(Reviews.review_score) AS avg_review_score
FROM Reviews
JOIN Orders ON Reviews.order_id = Orders.order_id
JOIN "Order Items" ON Orders.order_id = "Order Items".order_id
JOIN Products ON "Order Items".product_id = Products.product_id
GROUP BY Products.product_category_name
ORDER BY avg_review_score DESC;
--Explanation: Finds the average review score for each product category by joining relevant tables and grouping by product_category_name.

--10: Top 5 best-selling products
SELECT TOP 5 Products.product_category_name, COUNT("Order Items".product_id) AS total_sold
FROM "Order Items"
JOIN Products ON "Order Items".product_id = Products.product_id
GROUP BY Products.product_category_name
ORDER BY total_sold DESC;
--Explanation: Lists the top 5 best-selling product categories based on the number of items sold.

--11: Total number of orders by geolocation (city)
SELECT Geolocation.geolocation_city, COUNT(Orders.order_id) AS total_orders
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
JOIN Geolocation ON Customers.customer_city = Geolocation.geolocation_city
GROUP BY Geolocation.geolocation_city
ORDER BY total_orders DESC;
--Explanation: Counts orders from each city using geolocation data by joining Orders, Customers, and Geolocation.

--12: Revenue breakdown by seller
SELECT Sellers.seller_id, SUM("Order Items".price) AS total_revenue
FROM "Order Items"
JOIN Sellers ON "Order Items".seller_id = Sellers.seller_id
GROUP BY Sellers.seller_id
ORDER BY total_revenue DESC;
--Explanation: Calculates total revenue for each seller by joining Order Items and Sellers.

--13: Percentage of orders delivered on time vs. late
SELECT 
    COUNT(CASE WHEN Orders.order_approved_at <= Orders.order_purchase_timestamp THEN 1 END) * 100.0 / COUNT(*) AS on_time_percentage,
    COUNT(CASE WHEN Orders.order_approved_at > Orders.order_purchase_timestamp THEN 1 END) * 100.0 / COUNT(*) AS late_percentage
FROM Orders;
--Explanation: Calculates the percentage of orders delivered on time vs. late by comparing order_approved_at to order_purchase_timestamp.

--14: Calculate the number of orders per quarter in 2017.
SELECT DATEPART(QUARTER, ORDER_PURCHASE_TIMESTAMP) AS QUARTER, COUNT(ORDER_ID) AS ORDER_COUNT
FROM ORDERS  
WHERE YEAR(ORDER_PURCHASE_TIMESTAMP) = 2017
GROUP BY DATEPART(QUARTER, ORDER_PURCHASE_TIMESTAMP);
--Explanation: Counts orders per quarter in 2017 by extracting quarters and filtering by year.

--15:Find the average number of items per order for each seller.
WITH ITEMS_PER_ORDER AS (
    SELECT ORDER_ID,SELLER_ID,COUNT("Order Items".PRODUCT_ID) AS ITEM_COUNT
    FROM "Order Items"
    GROUP BY ORDER_ID, SELLER_ID)
SELECT SELLERS.SELLER_ID,ROUND(AVG(ITEMS_PER_ORDER.ITEM_COUNT), 2) AS AVG_ITEMS_PER_ORDER
FROM SELLERS
JOIN ITEMS_PER_ORDER ON SELLERS.SELLER_ID = ITEMS_PER_ORDER.SELLER_ID
GROUP BY SELLERS.SELLER_ID;
--Explanation: Uses a CTE to calculate the number of items per order for each seller, then finds the average items per order per seller.

--16:Calculate the percentage contribution to total revenue by each payment method.
SELECT payment_type,
    ROUND((SUM(PAYMENT_VALUE) / (SELECT SUM(PAYMENT_VALUE) FROM "Order Payments")) * 100, 2) AS PERCENTAGE_CONTRIBUTION
FROM "Order Payments"
GROUP BY payment_type
ORDER BY PERCENTAGE_CONTRIBUTION DESC;
--Explanation: Calculates the percentage of total revenue contributed by each payment type.

--17:Find the top 10 most sold products based on quantity.
SELECT TOP 10 PRODUCTS.product_category_name, SUM("Order Items".order_item_id) AS TOTAL_QUANTITY
FROM  PRODUCTS
JOIN "Order Items" ON PRODUCTS.PRODUCT_ID = "Order Items".PRODUCT_ID
GROUP BY PRODUCTS.product_category_name
ORDER BY TOTAL_QUANTITY DESC;
--Explanation: Lists the top 10 most-sold products by quantity, grouped by category.

--18:Calculate the total revenue generated by each seller, and rank them by revenue.
SELECT SELLER_ID,SUM("Order Payments".PAYMENT_VALUE) AS TOTAL_REVENUE,
    DENSE_RANK() OVER (ORDER BY SUM("Order Payments".PAYMENT_VALUE) DESC) AS REVENUE_RANK
FROM "Order Items"
JOIN "Order Payments" ON "Order Items".ORDER_ID = "Order Payments".ORDER_ID
GROUP BY SELLER_ID
ORDER BY TOTAL_REVENUE DESC;
--Explanation: Calculates each seller’s total revenue and ranks them by descending revenue.

--19:Find the product category with the highest revenue contribution each month.
SELECT DATEPART(MONTH, ORDER_PURCHASE_TIMESTAMP) AS MONTH,PRODUCTS.product_category_name,
    SUM("Order Payments".PAYMENT_VALUE) AS TOTAL_REVENUE,
    RANK() OVER (PARTITION BY DATEPART(MONTH, ORDER_PURCHASE_TIMESTAMP) ORDER BY SUM("Order Payments".PAYMENT_VALUE) DESC) AS REVENUE_RANK
FROM PRODUCTS
JOIN "Order Items" ON PRODUCTS.PRODUCT_ID = "Order Items".PRODUCT_ID
JOIN "Order Payments" ON "Order Items".ORDER_ID = "Order Payments".ORDER_ID
JOIN ORDERS ON "Order Items".ORDER_ID = ORDERS.ORDER_ID
GROUP BY DATEPART(MONTH, ORDER_PURCHASE_TIMESTAMP),PRODUCTS.product_category_name;
--Explanation: Finds the product category that made the most revenue each month. It calculates monthly revenue for each category, ranks them, and shows the highest-earning category per month.

--20:Identify products with a higher-than-average selling price in their respective category.
WITH CATEGORY_AVG_PRICE AS (
    SELECT product_category_name,AVG("Order Items".PRICE) AS AVG_PRICE
    FROM PRODUCTS
    JOIN "Order Items" ON PRODUCTS.PRODUCT_ID = "Order Items".PRODUCT_ID
    GROUP BY product_category_name)
SELECT PRODUCTS.PRODUCT_ID,"Order Items".PRICE,CATEGORY_AVG_PRICE.AVG_PRICE
FROM PRODUCTS
JOIN "Order Items" ON PRODUCTS.PRODUCT_ID = "Order Items".PRODUCT_ID
JOIN CATEGORY_AVG_PRICE ON PRODUCTS.product_category_name = CATEGORY_AVG_PRICE.product_category_name
WHERE"Order Items".PRICE > CATEGORY_AVG_PRICE.AVG_PRICE;
--Explanation: Identifies products priced higher than the average in their category. It calculates each category’s average price and then lists products that are above that average.

--21: What is the average review score for each payment type
SELECT "Order Payments".payment_type, AVG(Reviews.review_score) AS avg_review_score
FROM "Order Payments"
JOIN Orders ON "Order Payments".order_id = Orders.order_id
JOIN Reviews ON Orders.order_id = Reviews.order_id
GROUP BY "Order Payments".payment_type
ORDER BY avg_review_score DESC;
--Explanation: Calculates the average review score for each payment type, showing if certain payment methods have higher or lower customer review scores.
