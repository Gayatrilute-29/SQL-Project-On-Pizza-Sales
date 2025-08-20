-- Q1) RETRIVE THE TOTAL NUMBER OF ORDERS PLACED.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
    
   --  The total number of order placed is 21350
    
    
-- Q2) CALCULATE THE TOTAL REVENUE GENERATED FROM PIZZA SALES.
 
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
FROM 
    order_details od
JOIN 
    pizzas p ON p.pizza_id = od.pizza_id;
    
 -- Total revenue is 817860.05

    
--  Q3) IDENTIFY THE HIGHEST PRICED PIZZA.


SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- The highest price pizza is THE GREEK PIZZA And its price 35.95


-- Q4) IDENTIFY THE MOST COMMON PIZZA SIZE ORDERED.

SELECT 
    pizzas.size, COUNT(order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- L SIZE  is the most common pizza size ordered by customers. and order count is 18526.

-- Q5)LIST THE TOP 5 MOST ORDERED PIZZA TYPES ALONG WITH THEIR QUANTITIES.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity desc limit 5 ;

 -- 5 most common pizza order  and  their quantity as follows 
-- 1] The Classic Deluxe Pizza -- 2453
-- 2] The Barbecue Pizza -- 2432
-- 3] The Hawalian Pizza -- 2422
-- 4] The pepperoni Pizza -- 2418
-- 5] The Thai Chicken Pizza -- 2371



-- Q6)JOIN THE NECESSARY TABLES TO FIND THE TOTAL QUANTITY OF EACH PIZZA CATEGORY ORDERED.


SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- The total quantity of each pizza orderd 
-- 1] Classic category and  quantity  14888
-- 2] Supreme category and quantity 11987 
-- 3]  Veggie category and quantity 11649
-- 4]  Chicken category and quantity 11050


-- Q7)DETERMINE THE DISTRIBUTION OF ORDERS BY HOUR OF THE DAY.

SELECT 
    HOUR(time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(time);

-- The distribution of orders by hour of the day
-- HOURS      ORDER_COUNT
-- 11         1231
-- 12         2520
-- 13         2455
-- 14         1472
-- 15         1468
-- 16         1920
-- 17         2336
-- 18         2399
-- 19         2009
-- 20         1642
-- 21         1198
-- 22         663 
-- 23         28
-- 10         8
-- 9          1


-- Q8)JOIN RELEVENT TABLES TO FIND THE CATEGORY-WISE DISTRIBUTION OF PIZZAS.


SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Category- wise distribution of pizzas
-- category    count of pizza
-- Chicken      6
-- Classic      8
-- Supreme      9
-- Veggie       9



-- Q9)GGROUP THE ORDERS BY DATE AND CALCULATE THE AVERAGE NUMBER OF PIZZAS ORDERED PER DAY.


select orders.date, sum(order_details.quantity)
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date;
  
  -- The output of this query to shown the  average number of pizzas orders per day

-- Q10)DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE.


SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
   
-- Top 3 most order pizza type andits revenue
-- Name                             REVENUE
-- The Greek Pizza                  5450661.30
-- The Italian Vegatables Pizza     2503487
-- The Thai Chicken Pizza           2491093.5


-- Q11)CALCULATE THE PERCENTAGE CONTRIBUTION OF EACH PIZZA TYPE TO TOTAL REVENUE.
        SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (
        SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price), 2)
        FROM
            order_details
        JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id
    ) * 100, 2) AS revenue
FROM
    pizza_types
JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    revenue DESC;  
    
    -- The percentage contributions  of each pizza type and its total revenue
--     
--     Category        Revenue
--     Classic          26.91
--     Supreme          25.46
--     Chicken          23.96
--     Veggie           23.68


-- Q12) ANALYZE THE CUMULATIVE REVENUE GENERATED OVER TIME.
SELECT 
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM (
    SELECT 
        orders.date AS order_date,
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM 
        order_details 
    JOIN 
        pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN 
        orders ON orders.order_id = order_details.order_id
    GROUP BY 
        orders.date
) AS sales;
-- Output of this query to show cumulative revenue per order date.



-- Q13)DETERMINE THE TOP 3 MOST ORDERED PIZZA TYPES BASED ON REVENUE FOR EACH PIZZA CATEGORY.


SELECT 
    name, 
    revenue 
FROM (
    SELECT 
        category,
        name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT 
            pizza_types.category,
            pizza_types.name,
            SUM(order_details.quantity * pizzas.price) AS revenue
        FROM 
            pizza_types 
        JOIN 
            pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN 
            order_details ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY 
            pizza_types.category, pizza_types.name
    ) AS a
) AS b
WHERE rn <= 3
limit 3;


-- Top 3 most ordered pizza types based on its revenue
-- Name                               Revenue
-- The Thai Chicken Pizza             43434.25
-- The Barbecue Chicken Pizza         42768
-- The California Chicken Pizza       41409.5