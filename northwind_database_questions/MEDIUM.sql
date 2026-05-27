--Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table

SELECT products.product_name,suppliers.company_name,categories.category_name
FROM products
	join categories on products.category_id=categories.category_id
    join suppliers on products.supplier_id=suppliers.supplier_id; 

--Show the category_name and the average product unit price for each category rounded to 2 decimal places.

SELECT categories.category_name,ROUND(avg(unit_price),2) AS average_unit_price
FROM products
	join categories on products.category_id=categories.category_id
group by categories.category_name; 

--Show the city, company_name, contact_name from the customers and suppliers table merged together.
--Create a column which contains 'customers' or 'suppliers' depending on the table it came from.

SELECT city,company_name,contact_name,'customers' as relationship
FROM customers
	UNION 
SELECT city,company_name,contact_name,'suppliers' as relationship
FROM suppliers;

--Show the total amount of orders for each year/month.

SELECT YEAR(order_date) AS order_year,month(order_date) AS order_month,count(*) as no_of_orders
FROM orders
GROUP BY year(order_date),
		month(order_date);


