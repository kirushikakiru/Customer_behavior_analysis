select * from customer limit 20
SELECT * FROM customer LIMIT 5;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'customer';

SELECT "Gender", SUM("Purchase Amount (USD)") AS revenue
FROM customer
GROUP BY "Gender";

SELECT "Customer ID", "Purchase Amount (USD)"
FROM customer
WHERE "Discount Applied" = 'Yes'
AND "Purchase Amount (USD)" >= (
SELECT AVG("Purchase Amount (USD)")
FROM customer
);

SELECT "Item Purchased", 
AVG("Review Rating") AS "Average Product Rating"
FROM customer
GROUP BY "Item Purchased"
ORDER BY AVG("Review Rating") DESC
LIMIT 5;

SELECT "Shipping Type",
ROUND(AVG("Purchase Amount (USD)"), 2)
FROM customer
WHERE "Shipping Type" IN ('Standard', 'Express')
GROUP BY "Shipping Type";

SELECT "Subscription Status",
COUNT("Customer ID") AS total_customer,
ROUND(AVG("Purchase Amount (USD)"), 2) AS avg_spend,
ROUND(SUM("Purchase Amount (USD)"), 2) AS total_revenue
FROM customer
GROUP BY "Subscription Status"
ORDER BY total_revenue DESC, avg_spend DESC;


SELECT "Item Purchased",
       ROUND(
           SUM(CASE 
                   WHEN "Discount Applied" = 'Yes' 
                   THEN 1 
                   ELSE 0 
               END)::numeric / COUNT(*) * 100,
           2
       ) AS "Discount Rate"
FROM customer
GROUP BY "Item Purchased"
ORDER BY "Discount Rate" DESC
LIMIT 5;

WITH "Customer Type" AS (
    SELECT "Customer ID",
           "Previous Purchases",
           CASE
               WHEN "Previous Purchases" = 1 THEN 'New'
               WHEN "Previous Purchases" BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS "Customer Segment"
    FROM customer
)

SELECT "Customer Segment",
       COUNT(*) AS "Number of Customers"
FROM "Customer Type"
GROUP BY "Customer Segment"; 

 
WITH "Item Counts" AS (
    SELECT 
        "Category",
        "Item Purchased",
        COUNT("Customer ID") AS total_orders,
        
        ROW_NUMBER() OVER (
            PARTITION BY "Category"
            ORDER BY COUNT("Customer ID") DESC
        ) AS item_rank
        
    FROM customer
    GROUP BY "Category", "Item Purchased"
)

SELECT 
    "Category",
    "Item Purchased",
    total_orders
FROM "Item Counts"
WHERE item_rank <= 3;

SELECT "Subscription Status",
       COUNT("Customer ID") AS repeat_buyers
FROM customer
WHERE "Previous Purchases" > 5
GROUP BY "Subscription Status";

SELECT 
    CASE
        WHEN "Age" BETWEEN 18 AND 25 THEN 'Young Adult'
        WHEN "Age" BETWEEN 26 AND 35 THEN 'Adult'
        WHEN "Age" BETWEEN 36 AND 50 THEN 'Middle Aged'
        ELSE 'Senior'
    END AS "Age Group",

    SUM("Purchase Amount (USD)") AS total_revenue

FROM customer

GROUP BY "Age Group"

ORDER BY total_revenue DESC;