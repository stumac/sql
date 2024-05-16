--SELECT
/* 1. Write a query that returns everything in the customer table. */
-- aliased the names because customer.customer_<<property_name>> feels plain weird in a result table to me
SELECT customer_id AS id,
 customer_last_name AS last_name,
 customer_first_name AS first_name,
 customer_zip AS zip 
FROM customer;


/* 2. Write a query that displays all of the columns and 10 rows from the customer table, 
sorted by customer_last_name, then customer_first_ name. */
SELECT customer_id AS id,
 customer_last_name AS last_name,
 customer_first_name AS first_name,
 customer_zip AS zip 
FROM customer ORDER BY last_name, first_name limit 10;


--WHERE
/* 1. Write a query that returns all customer purchases of product IDs 4 and 9. */
SELECT product_id, 
  vendor_id, 
  market_date,
  customer_id, 
  quantity,
  cost_to_customer_per_qty,
  transaction_time
FROM customer_purchases WHERE product_id IN (4,9);

-- SELECT DISTINCT product_id FROM customer_purchases;
-- Does not return a product id of 9. Do not expect to see 9 in the results above. 


/*2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), 
filtered by vendor IDs between 8 and 10 (inclusive) using either:
	1.  two conditions using AND
	2.  one condition using BETWEEN
*/
SELECT product_id, 
  vendor_id, 
  market_date,
  customer_id, 
  quantity,
  cost_to_customer_per_qty,
  transaction_time,
  (quantity * cost_to_customer_per_qty) AS price
FROM customer_purchases WHERE vendor_id BETWEEN 8 AND 10;

-- SELECT DISTINCT vendor_id FROM customer_purchases; 
--returns 7/8/4. so I don't expect to see a 9 or a 10


--CASE
/* 1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. 
Using the product table, write a query that outputs the product_id and product_name
columns and add a column called prod_qty_type_condensed that displays the word “unit” 
if the product_qty_type is “unit,” and otherwise displays the word “bulk.” */
SELECT product_id, product_name,
  CASE
	WHEN product_qty_type = 'unit' THEN 'unit'
	ELSE 'bulk'
  END AS prod_qty_type_condensed
FROM product;

/* 2. We want to flag all of the different types of pepper products that are sold at the market. 
add a column to the previous query called pepper_flag that outputs a 1 if the product_name 
contains the word “pepper” (regardless of capitalization), and otherwise outputs 0. */
SELECT product_id, product_name,
  CASE
	WHEN product_qty_type = 'unit' THEN 'unit'
	ELSE 'bulk'
  END AS prod_qty_type_condensed,
  CASE
	WHEN UPPER(product_name) LIKE UPPER('%pepper%') THEN 1
	ELSE 0
  END AS pepper_flag
FROM product;

--JOIN
/* 1. Write a query that INNER JOINs the vendor table to the vendor_booth_assignments table on the 
vendor_id field they both have in common, and sorts the result by vendor_name, then market_date. */

-- NOTE: There was no indication on whether the ordering should be ascending or
-- descending. I went with DESC on the market_date because I usually expect to 
-- see dates starting from the most recent at the top of a table. The
-- vendor_name I usually expect to go alphabetically starting from a (or numbers)
SELECT
	v.vendor_id,
	v.vendor_name,
	v.vendor_type,
	v.vendor_owner_first_name,
	v.vendor_owner_last_name,
	vba.booth_number as vendor_booth_number,
	vba.market_date
FROM vendor v
INNER JOIN vendor_booth_assignments vba
	ON v.vendor_id = vba.vendor_id
ORDER BY v.vendor_name, vba.market_date DESC;