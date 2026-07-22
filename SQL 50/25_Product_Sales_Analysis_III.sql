/*
Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key (combination of columns with unique values) of this table.
Each row records a sale of a product in a given year.
A product may have multiple sales entries in the same year.
Note that the per-unit price.

Write a solution to find all sales that occurred in the first year each product was sold.

For each product_id, identify the earliest year it appears in the Sales table.

Return all sales entries for that product in that year.

Return a table with the following columns: product_id, first_year, quantity, and price.
*/

SELECT S.product_id,
       S.year AS first_year,
       S.quantity,
       S.price
FROM Sales AS S
JOIN 
    (SELECT product_id,
            MIN(year) AS first_year 
    FROM Sales 
    GROUP BY product_id) AS T
ON S.product_id=T.product_id
AND S.year=T.first_year;