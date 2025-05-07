
--CREATE DATABASE PIZZA_SALES;

SELECT * FROM [dbo].[pizzas];

SELECT * FROM [dbo].[pizza_types];

SELECT * FROM [dbo].[orders];

SELECT * FROM [dbo].[order_details];

-- 1) Retrieve the total number of orders placed.

Select count(order_id) as Total_Orders from orders;
-- 21350


--2) Calculate the total revenue generated from pizza sales.

Select CAST(SUM(order_details.quantity*pizzas.price) AS DECIMAL(10,2)) AS Total_Revenue FROM pizzas
INNER JOIN order_details 
on pizzas.pizza_id = order_details.pizza_id;

-- 817860.05

-- 3) Identify the highest-priced pizza.

SELECT TOP 1 CAST(price AS DECIMAL(10,2)) FROM pizzas
ORDER BY price DESC;

-- 35.95

SELECT TOP 1 pizza_types.name, CAST(price AS DECIMAL(10,2)) AS Pizza_Price from pizzas
INNER JOIN pizza_types
on pizzas.pizza_type_id =pizza_types.pizza_type_id
ORDER BY pizzas.price DESC;

-- The Greek Pizza	35.95

-- 4) Identify the most common pizza size ordered.

SELECT TOP 1 pizzas.size , count(order_details.quantity) AS ORDER_COUNT from pizzas
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by count(order_details.quantity) DESC;

-- L	18526

-- 5) List the top 5 most ordered pizza types along with their quantities.

SELECT TOP 5 pizzas.pizza_type_id , sum(order_details.quantity) as Pizza_Type_Quantity from pizzas
INNER JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_type_id 
ORDER BY sum(order_details.quantity) DESC;

/*	classic_dlx	2453
	bbq_ckn	2432
	hawaiian	2422
	pepperoni	2418
	thai_ckn	2371 */


SELECT top 5 pizza_types.name, sum(order_details.quantity) as Pizza_Quantity from pizzas
INNER JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by sum(order_details.quantity) DESC;

/*	The Classic Deluxe Pizza	2453
	The Barbecue Chicken Pizza	2432
	The Hawaiian Pizza	2422
	The Pepperoni Pizza	2418
	The Thai Chicken Pizza	2371  */
	

-- 6) Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category, sum(order_details.quantity) as Pizza_Quantity from pizzas
INNER JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by sum(order_details.quantity) DESC;

/*	Classic	14888
	Supreme	11987
	Veggie	11649
	Chicken	11050 */
	

-- 7) Determine the distribution of order quantity by hour of the day.

Select DATEPART(HOUR,orders.order_time) as Time_in_Hours , sum(order_details.quantity) as Quantity_Ordered from orders
inner join order_details
on orders.order_id = order_details.order_id
Group by DATEPART(HOUR,orders.order_time) 
order by DATEPART(HOUR,orders.order_time) ;

/*	9	4
	10	18
	11	2728
	12	6776
	13	6413
	14	3613
	15	3216
	16	4239
	17	5211
	18	5417
	19	4406
	20	3534
	21	2545
	22	1386
	23	68 */

-- 8) Determine the distribution of orders by hour of the day.

Select Datepart(Hour, order_time)as Time_in_Hours, Count(order_id)as Order_count from orders
Group by Datepart(Hour, order_time)
order by Datepart(Hour, order_time) ASC;

/*	9	1
	10	8
	11	1231
	12	2520
	13	2455
	14	1472
	15	1468
	16	1920
	17	2336
	18	2399
	19	2009
	20	1642
	21	1198
	22	663
	23	28 */

-- 9) Join relevant tables to find the category-wise distribution of pizzas.

Select Category, count(pizza_type_id) as Pizza_Types, STRING_AGG(name, ', ') AS Pizza_names from pizza_types
Group by Category;

/*	Chicken	6	The Barbecue Chicken Pizza, The California Chicken Pizza, The Chicken Alfredo Pizza, The Chicken Pesto Pizza, The Southwest Chicken Pizza, The Thai Chicken Pizza
	Classic	8	The Greek Pizza, The Classic Deluxe Pizza, The Big Meat Pizza, The Hawaiian Pizza, The Italian Capocollo Pizza, The Napolitana Pizza, The Pepperoni, Mushroom, and Peppers Pizza, The Pepperoni Pizza
	Supreme	9	The Pepper Salami Pizza, The Prosciutto and Arugula Pizza, The Sicilian Pizza, The Soppressata Pizza, The Italian Supreme Pizza, The Brie Carre Pizza, The Calabrese Pizza, The Spinach Supreme Pizza, The Spicy Italian Pizza
	Veggie	9	The Spinach Pesto Pizza, The Spinach and Feta Pizza, The Vegetables + Vegetables Pizza, The Five Cheese Pizza, The Four Cheese Pizza, The Green Garden Pizza, The Italian Vegetables Pizza, The Mediterranean Pizza, The Mexicana Pizza
*/

-- 10) Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT AVG(PIZZA_PER_DAY) as Average_pizza_per_day FROM
(Select orders.order_date , SUM(order_details.quantity) AS PIZZA_PER_DAY  from orders
inner join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) AS Pizza_per_day;

-- 138

-- 11) Determine the top 3 most ordered pizza types based on revenue.

Select  TOP 3 pizza_types.name as Pizza_Name, CAST(sum(pizzas.price * order_details.quantity) AS DECIMAL(10,2)) AS Pizza_Revenue from pizzas
inner join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by sum(pizzas.price * order_details.quantity) DESC ;

/*	The Thai Chicken Pizza	43434.25
	The Barbecue Chicken Pizza	42768.00
	The California Chicken Pizza	41409.50 */

-- 12) Calculate the percentage contribution of each pizza type to total revenue.

Select pizza_types.Category as Pizza_Name, CAST(sum(pizzas.price * order_details.quantity) AS DECIMAL(10,2)) AS Pizza_Revenue from pizzas
inner join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.Category;


Select pizza_types.Category as Pizza_Name, CONCAT(CAST(((CAST(sum(pizzas.price * order_details.quantity) AS DECIMAL(10,2)))/(Select CAST(SUM(order_details.quantity*pizzas.price) AS DECIMAL(10,2)) AS Total_Revenue FROM pizzas
INNER JOIN order_details 
on pizzas.pizza_id = order_details.pizza_id)*100) AS DECIMAL(10,2)),' %')  as Revenue_Percentage from pizzas
inner join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.Category ;

/*	Chicken	23.96 %
	Supreme	25.46 %
	Classic	26.91 %
	Veggie	23.68 %  */

-- 13) Analyze the cumulative revenue generated over time.

Select  orders.order_date as DATE, CAST(sum(pizzas.price*order_details.quantity)AS DECIMAL(10,2)) AS Every_day_sales, 
SUM(CAST(sum(pizzas.price*order_details.quantity)AS DECIMAL(10,2))) OVER (ORDER BY orders.order_date) AS Cumulative_sales from pizzas
inner join order_details
on pizzas.pizza_id = order_details.pizza_id
inner join orders
on order_details.order_id = orders.order_id
group by orders.order_date
ORDER BY orders.order_date ASC;


/* 2015-01-01	2713.85	2713.85
	2015-01-02	2731.90	5445.75
	2015-01-03	2662.40	8108.15
	2015-01-04	1755.45	9863.60
	2015-01-05	2065.95	11929.55
	2015-01-06	2428.95	14358.50
	2015-01-07	2202.20	16560.70
	2015-01-08	2838.35	19399.05
	2015-01-09	2127.35	21526.40
	--------------------------    */


-- 14) Determine the top 3 most ordered pizza types based on revenue for each pizza category.


SELECT pizza_types.category,pizza_types.name,CAST(SUM(pizzas.price*order_details.quantity) as DECIMAL(10,2))AS Category_revenue  FROM pizzas
INNER JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
INNER JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY  pizza_types.category,pizza_types.name
ORDER BY Category_revenue DESC;
-----

SELECT  category,  name ,Category_revenue, RANK() OVER(PARTITION BY CATEGORY ORDER BY Category_revenue DESC)  AS RANK_PIZZA_TYPE      
FROM (SELECT pizza_types.category,pizza_types.name,CAST(SUM(pizzas.price*order_details.quantity) as DECIMAL(10,2))AS Category_revenue  FROM pizzas
INNER JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
INNER JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY  pizza_types.category,pizza_types.name) AS a;

-----

SELECT CATEGORY, NAME, CATEGORY_REVENUE, RANK_PIZZA_TYPE 
FROM (SELECT  category,  name ,Category_revenue, RANK() OVER(PARTITION BY CATEGORY ORDER BY Category_revenue DESC)  AS RANK_PIZZA_TYPE      
FROM (SELECT pizza_types.category,pizza_types.name,CAST(SUM(pizzas.price*order_details.quantity) as DECIMAL(10,2))AS Category_revenue  FROM pizzas
INNER JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
INNER JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY  pizza_types.category,pizza_types.name) AS a) AS b
WHERE RANK_PIZZA_TYPE <= 3 ;

/*	Chicken	The Thai Chicken Pizza	43434.25	1
	Chicken	The Barbecue Chicken Pizza	42768.00	2
	Chicken	The California Chicken Pizza	41409.50	3
	Classic	The Classic Deluxe Pizza	38180.50	1
	Classic	The Hawaiian Pizza	32273.25	2
	Classic	The Pepperoni Pizza	30161.75	3
	Supreme	The Spicy Italian Pizza	34831.25	1
	Supreme	The Italian Supreme Pizza	33476.75	2
	Supreme	The Sicilian Pizza	30940.50	3
	Veggie	The Four Cheese Pizza	32265.70	1
	Veggie	The Mexicana Pizza	26780.75	2
	Veggie	The Five Cheese Pizza	26066.50	3                          */