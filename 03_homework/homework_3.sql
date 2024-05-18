-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */
SELECT COUNT(vendor_id) as booth_rental_count, vendor_id
FROM vendor_booth_assignments
GROUP BY vendor_id;

-- -------------- FOR FUN: --------------------------------------
-- SELECT 
--   vba.vendor_id, 
--   v.vendor_name, 
--   COUNT(vba.vendor_id) AS 'vendor_booth_rental_count'
-- FROM vendor_booth_assignments vba
-- INNER JOIN vendor v
--   ON vba.vendor_id = v.vendor_id
-- GROUP BY v.vendor_name
-- ORDER BY vba.vendor_id;
-- --------------------------------------------------------------

/* 2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 

HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword. */

SELECT
  c.customer_last_name,
  c.customer_first_name
FROM customer c
INNER JOIN customer_purchases cp
   ON c.customer_id = cp.customer_id
GROUP BY c.customer_first_name
HAVING SUM((cp.quantity * cp.cost_to_customer_per_qty)) > 2000
ORDER BY c.customer_last_name, c.customer_first_name;



-- -----------------------FOR FUN------------------------------
-- SELECT
--   c.customer_last_name,
--   c.customer_first_name,
--   ROUND(SUM((cp.quantity * cp.cost_to_customer_per_qty)), 2) as amount_purchased
-- FROM customer c
-- INNER JOIN customer_purchases cp
--    ON c.customer_id = cp.customer_id
-- GROUP BY c.customer_first_name
-- HAVING amount_purchased > 2000
-- ORDER BY c.customer_last_name, c.customer_first_name;
-- ------------------------------------------------------------

--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal

HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) 

-> To insert the new row use VALUES, specifying the value you want for each column:
VALUES(col1,col2,col3,col4,col5) 
*/

-- no point creating a temp table if it already exists.
DROP TABLE IF EXISTS new_vendor;
CREATE TEMP TABLE new_vendor AS
  SELECT * FROM vendor;
	
INSERT INTO new_vendor(
    vendor_id,
    vendor_name,
    vendor_type, 
    vendor_owner_first_name, 
	vendor_owner_last_name
  )
  VALUES(
    10,
    "Thomass Superfood Store",
    "Fresh Variety",
    "Thomas",
    "Rosenthal"
  );

-- Date
/*1. Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.

HINT: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month 
and year are! */
SELECT 
  customer_id,
  strftime('%m', market_date) AS purchase_month,
  strftime('%Y', market_date) AS purchase_year
FROM customer_purchases;

/* 2. Using the previous query as a base, determine how much money each customer spent in April 2019. 
Remember that money spent is quantity*cost_to_customer_per_qty. 

HINTS: you will need to AGGREGATE, GROUP BY, and filter...
but remember, STRFTIME returns a STRING for your WHERE statement!! */

SELECT 
  customer_id,
  strftime('%m', market_date) AS purchase_month,
  strftime('%Y', market_date) AS purchase_year,
  SUM((quantity * cost_to_customer_per_qty)) AS total_purchase_value
FROM customer_purchases 
WHERE purchase_month = '04' AND purchase_year = '2019'
GROUP BY customer_id;


-- potential adjustment: casting the puchase month and year to integers
-- depending on what's using this query. I.e: a strong typed language would
-- probably want an integer, so the WHERE clause would expect that.
-- but that doesn't really matter for this. So I kept it off.
/*
SELECT 
  customer_id,
  CAST(strftime('%m', market_date) AS INTEGER) AS purchase_month,
  CAST(strftime('%Y', market_date) AS INTEGER) AS purchase_year,
  SUM((quantity * cost_to_customer_per_qty)) AS total_purchase_value
FROM customer_purchases 
WHERE purchase_month = 04 AND purchase_year = 2019
GROUP BY customer_id;
*/

