/* =========================================================
   TASK: Customer Order Count
   Dataset: Superstore (Sales_Data)
   Goal  : Count orders per customer and identify frequent buyers
   Note  : The raw table has one row per ORDER LINE, so the same
           Order ID can repeat several times (one per product in
           that order). We must count DISTINCT Order IDs per
           customer, not raw rows, or every multi-item order would
           be over-counted.
   ========================================================= */

-- 0. (Optional) Table structure, if creating the table from scratch
-- CREATE TABLE sales_data (
--     row_id        INT,
--     order_id      VARCHAR(20),
--     order_date    DATE,
--     ship_date     DATE,
--     ship_mode     VARCHAR(30),
--     customer_id   VARCHAR(20),
--     customer_name VARCHAR(100),
--     segment       VARCHAR(30),
--     country       VARCHAR(50),
--     city          VARCHAR(50),
--     state         VARCHAR(50),
--     postal_code   VARCHAR(10),
--     region        VARCHAR(20),
--     product_id    VARCHAR(20),
--     category      VARCHAR(30),
--     sub_category  VARCHAR(30),
--     product_name  VARCHAR(200),
--     sales         DECIMAL(10,4),
--     quantity      INT,
--     discount      DECIMAL(5,2),
--     profit        DECIMAL(10,4)
-- );
-- Then bulk-load superstore.csv into sales_data.


-- 1. STEP 1: Build a de-duplicated list of orders (one row per Order ID)
--    This removes the duplicate order-lines before we count anything.
SELECT DISTINCT
    order_id,
    customer_id,
    customer_name
FROM sales_data;


-- 2. STEP 2: Count orders per customer (the core deliverable)
--    Uses COUNT(DISTINCT order_id) so multi-item orders are counted once.
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS order_count
FROM sales_data
GROUP BY customer_id, customer_name
ORDER BY order_count DESC;


-- 3. STEP 3: Identify "frequent buyers"
--    Threshold = 8 orders (the 75th percentile of the dataset, i.e. the
--    top ~30% of customers by order frequency) -- documented in README.
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS order_count,
    CASE
        WHEN COUNT(DISTINCT order_id) >= 8 THEN 'Yes'
        ELSE 'No'
    END AS frequent_buyer
FROM sales_data
GROUP BY customer_id, customer_name
ORDER BY order_count DESC;


-- 4. STEP 4: Top 10 customers by order count
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS order_count
FROM sales_data
GROUP BY customer_id, customer_name
ORDER BY order_count DESC
LIMIT 10;


-- 5. Cross-check: total unique orders in the dataset
--    (Sum of every customer's order_count from Query 2 must equal this.)
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM sales_data;


-- 6. Cross-check: how many customers qualify as frequent buyers
SELECT COUNT(*) AS frequent_buyer_count
FROM (
    SELECT customer_id
    FROM sales_data
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) >= 8
) t;
