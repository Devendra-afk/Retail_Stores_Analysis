Create database retail_store_analysis;
USE retail_store_analysis;


SELECT 'customers' AS table_name, COUNT(*) AS rows_loaded
FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'calendar', COUNT(*) FROM calendar;

select * from sales;
set global local_infile = 1;

LOAD DATA LOCAL INFILE
'D:/Study/DA_Projects/Retail_Stores_Analysis/sales.csv'
INTO TABLE sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE
'D:/Study/DA_Projects/Data/sales.csv'
INTO TABLE sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

truncate table stores;
load data local infile
'D:/Study/DA_Projects/Data/stores.csv'
into table stores
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

describe sales;




# CHECKING MISSING VALUES
select
	count(*) as row_count,
    sum(order_id is null) as missing_order_id,
    sum(order_date is null) as missing_order_date,
    sum(product_id is null) as missing_product_id,
    sum(store_id is null) as missing_store_id,
    sum(customer_id is null) as missing_customer_id,
    sum(quantity is null) as missing_quantity,
    sum(unit_price is null) as missing_unit_price,
    sum(discount is null) as missing_discount,
    sum(revenue is null) as missing_revenue,
    sum(cost is null) as missing_cost,
    sum(profit is null) as missing_profit
from sales;

# CHECKING DUPLCATE VALUES

select 
count(distinct order_id) as unique_order_id,
count(*) as total_order_ids
from sales;
# CHECKING QUANTITY
SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    AVG(quantity) AS avg_quantity,
    SUM(quantity = 0) AS zero_quantity_rows,
    SUM(quantity < 0) AS negative_quantity_rows
FROM sales;

select
	count(distinct customer_id) as unique_customers,
    count(customer_id) as total_customers,
    count(customer_id) - count(distinct customer_id ) as duplicates
from customers;

SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(product_name IS NULL) AS missing_product_name,
    SUM(brand IS NULL) AS missing_brand,
    SUM(category IS NULL) AS missing_category,
    SUM(cocoa_percent IS NULL) AS missing_cocoa_percent,
    SUM(weight_g IS NULL) AS missing_weight_g
FROM products;

select
	count(*) as total_product_id,
    count(distinct product_id) as unique_productID,
    count(*) - count(distinct product_id) as duplicates
from products;

SELECT
    MIN(cocoa_percent) AS min_cocoa_percent,
    MAX(cocoa_percent) AS max_cocoa_percent,
    MIN(weight_g) AS min_weight_g,
    MAX(weight_g) AS max_weight_g,
    SUM(cocoa_percent <= 0 OR cocoa_percent > 100) AS invalid_cocoa_rows,
    SUM(weight_g <= 0) AS invalid_weight_rows
FROM products;

#STORES TABLLE
# DUPLICATE CHECKING
select
	count(*) as total_store_id,
    count(distinct store_id) as unique_store_id,
    count(*) - count(distinct store_id) as duplicates
from stores;
# MISSING VALUE CHECK
select
	count(*) as total_rows,
    sum(store_name is null) as missing_store_name,
    sum(city is null) as missing_city,
    sum(country is null) as missing_country,
    sum(store_type is null) as missing_store_type
from stores;


#CALENDAR
describe calendar;

SELECT
    COUNT(*) AS total_rows,
    SUM(`date` IS NULL) AS missing_date,
    SUM(`year` IS NULL) AS missing_year,
    SUM(`month` IS NULL) AS missing_month,
    SUM(`day` IS NULL) AS missing_day,
    SUM(`week` IS NULL) AS missing_week,
    SUM(`day_of_week` IS NULL) AS missing_day_of_week
FROM calendar;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT `date`) AS unique_dates,
    COUNT(*) - COUNT(DISTINCT `date`) AS duplicates
FROM calendar;

SELECT
    MIN(`date`) AS first_date,
    MAX(`date`) AS last_date,
    MIN(`month`) AS min_month,
    MAX(`month`) AS max_month,
    MIN(`day`) AS min_day,
    MAX(`day`) AS max_day,
    MIN(`day_of_week`) AS min_day_of_week,
    MAX(`day_of_week`) AS max_day_of_week
FROM calendar;

select 
	sum(c.customer_id is null) as missing_customer_id,
    sum(p.product_id is null) as missing_product_id,
    sum(st.store_id is null) as missing_store_id,
    sum(ca.date is null) as missing_date
from sales s
left join customers c on s.customer_id = c.customer_id
left join products p on s.product_id = p.product_id
left join stores st on s.store_id = st.store_id
left join calendar ca on s.order_date = ca.date;


# finding the unmatched product IDS this product may not be sold

select s.product_id,
	count(*) as affected_sales
from sales s
left join products p
on s.product_id = p.product_id
where p.product_id is null
group by s.product_id
order by affected_sales desc;

select 
	min(product_id) as first_productid,
    max(product_id) as last_productid
from products;


	SELECT product_id
	FROM sales
	WHERE product_id IN ('P0000', 'P0201')
    LIMIT 20;
    
    # found product id 'p0000' and 'p0201' do not exist in the product table but does in the sales data.alter
    
