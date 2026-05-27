/*
Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called 
"Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late, 
"Not Shipped" if shipped_date is null.

Order by employee last_name, then by first_name, and then descending by number of orders.
*/

SELECT employees.first_name,
		employees.last_name,
        COUNT(*) AS num_orders,
        CASE 
        	WHEN orders.shipped_date is null then 'Not Shipped'
        	WHEN orders.required_date>=orders.shipped_date THEN 'On Time' 
            ELSE 'Late' 
        end as shipped
FROM orders
		join employees ON orders.employee_id=employees.employee_id
GROUP BY employees.first_name,
		employees.last_name,
        CASE 
        	WHEN orders.shipped_date is null then 'Not Shipped'
        	WHEN orders.required_date>=orders.shipped_date THEN 'On Time' 
            ELSE 'Late' 
        end 
order by employees.last_name asc,employees.first_name asc,num_orders desc;

--Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places

SELECT YEAR(orders.order_date) as order_year, 
			  ROUND(SUM(products.unit_price*order_details.quantity*order_details.discount),2) AS discount_amount
FROM order_details
		join orders ON orders.order_id=order_details.order_id
        join products ON order_details.product_id=products.product_id
GROUP BY YEAR(orders.order_date)
order by YEAR(orders.order_date) desc;


