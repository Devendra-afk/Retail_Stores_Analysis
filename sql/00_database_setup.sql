-- =============================================================================
-- 00_database_setup.sql
-- Database and table creation for Retail Store Analysis
-- =============================================================================

CREATE DATABASE IF NOT EXISTS retail_store_analysis;
USE retail_store_analysis;

-- -----------------------------------------------------------------------------
-- Table: customers
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id   VARCHAR(10)  PRIMARY KEY,
    age           INT          NOT NULL,
    gender        VARCHAR(10)  NOT NULL,
    loyalty_member VARCHAR(5)  NOT NULL,
    join_date     DATE         NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: products
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
    product_id    VARCHAR(10)  PRIMARY KEY,
    product_name  VARCHAR(100) NOT NULL,
    brand         VARCHAR(50)  NOT NULL,
    category      VARCHAR(50)  NOT NULL,
    cocoa_percent DECIMAL(5,2) NOT NULL,
    weight_g      DECIMAL(7,2) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: stores
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stores (
    store_id   VARCHAR(10)  PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city       VARCHAR(50)  NOT NULL,
    country    VARCHAR(50)  NOT NULL,
    store_type VARCHAR(30)  NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: calendar
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS calendar (
    `date`       DATE        PRIMARY KEY,
    `year`       INT         NOT NULL,
    `month`      INT         NOT NULL,
    `day`        INT         NOT NULL,
    `week`       INT         NOT NULL,
    `day_of_week` VARCHAR(15) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: sales  (references customers, products, stores)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sales (
    order_id    VARCHAR(15)   PRIMARY KEY,
    order_date  DATE          NOT NULL,
    product_id  VARCHAR(10)   NOT NULL,
    store_id    VARCHAR(10)   NOT NULL,
    customer_id VARCHAR(10)   NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,
    discount    DECIMAL(5,2)  NOT NULL,
    revenue     DECIMAL(12,2) NOT NULL,
    cost        DECIMAL(12,2) NOT NULL,
    profit      DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (store_id)    REFERENCES stores(store_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- =============================================================================
-- DATA LOADING
-- Enable local_infile if loading CSV data via LOAD DATA LOCAL INFILE
-- =============================================================================
SET GLOBAL local_infile = 1;

-- Load customers
-- LOAD DATA LOCAL INFILE '<path_to>/customers.csv'
-- INTO TABLE customers
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;

-- Load products
-- LOAD DATA LOCAL INFILE '<path_to>/products.csv'
-- INTO TABLE products
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;

-- Load stores
-- LOAD DATA LOCAL INFILE '<path_to>/stores.csv'
-- INTO TABLE stores
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES;

-- Load sales
-- LOAD DATA LOCAL INFILE '<path_to>/sales.csv'
-- INTO TABLE sales
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;

-- =============================================================================
-- VERIFICATION: Row counts per table
-- =============================================================================
SELECT 'customers' AS table_name, COUNT(*) AS rows_loaded FROM customers
UNION ALL
SELECT 'products',  COUNT(*) FROM products
UNION ALL
SELECT 'stores',    COUNT(*) FROM stores
UNION ALL
SELECT 'sales',     COUNT(*) FROM sales
UNION ALL
SELECT 'calendar',  COUNT(*) FROM calendar;
