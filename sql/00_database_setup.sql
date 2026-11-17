-- =============================================================================
-- 00_database_setup.sql
-- Database and Table DDL with Staging & Loading Strategy
-- Retail Stores Sales Analysis (2023-2024)
-- =============================================================================

-- Step 1: Clean Database Initialization
DROP DATABASE IF EXISTS retail_store_analysis;
CREATE DATABASE retail_store_analysis
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE retail_store_analysis;

-- =============================================================================
-- Step 2: Dimension Tables DDL
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Table: calendar (Date Dimension)
-- Grain: One record per calendar day (731 days for 2023-2024 leap year)
-- Note on day_of_week: Source CSV stores integer 0-6 where:
--   0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday, 5=Saturday, 6=Sunday
-- -----------------------------------------------------------------------------
CREATE TABLE calendar (
    `date`        DATE        NOT NULL,
    `year`        INT         NOT NULL,
    `month`       INT         NOT NULL,
    `day`         INT         NOT NULL,
    `week`        INT         NOT NULL,
    `day_of_week` INT         NOT NULL COMMENT '0=Monday, 1=Tuesday, ..., 5=Saturday, 6=Sunday',
    PRIMARY KEY (`date`)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Table: customers (Customer Dimension)
-- Grain: One record per registered customer profile (50,000 customers)
-- -----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id    VARCHAR(10) NOT NULL,
    age            INT         NOT NULL,
    gender         VARCHAR(10) NOT NULL,
    loyalty_member INT         NOT NULL COMMENT '0=Non-Member, 1=Loyalty Member',
    join_date      DATE        NOT NULL,
    PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Table: products (Product Master Catalog)
-- Grain: One record per catalog SKU (200 products: P0001 - P0200)
-- -----------------------------------------------------------------------------
CREATE TABLE products (
    product_id    VARCHAR(10)   NOT NULL,
    product_name  VARCHAR(100)  NOT NULL,
    brand         VARCHAR(50)   NOT NULL,
    category      VARCHAR(50)   NOT NULL,
    cocoa_percent INT           NOT NULL COMMENT 'Cocoa solids percentage: 50, 60, 70, 80, 90',
    weight_g      INT           NOT NULL COMMENT 'Package weight in grams: 50, 80, 100, 120, 200',
    PRIMARY KEY (product_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- Table: stores (Store Facility Dimension)
-- Grain: One record per retail location (100 stores: S001 - S100)
-- -----------------------------------------------------------------------------
CREATE TABLE stores (
    store_id   VARCHAR(10)  NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    city       VARCHAR(50)  NOT NULL,
    country    VARCHAR(50)  NOT NULL,
    store_type VARCHAR(30)  NOT NULL COMMENT 'Airport, Mall, Online, Retail',
    PRIMARY KEY (store_id)
) ENGINE=InnoDB;

-- =============================================================================
-- Step 3: Fact Table DDL with Staging & Integrity Strategy
-- -----------------------------------------------------------------------------
-- ARCHITECTURAL DECISION ON FOREIGN KEYS:
-- The raw sales dataset contains 1,000,000 transaction records.
-- Exactly 9,764 records reference product IDs 'P0000' (4,895 rows) and 'P0201' (4,869 rows),
-- neither of which exists in products.csv (which contains P0001 through P0200).
--
-- If an immediate FOREIGN KEY constraint on product_id were enforced during ingestion,
-- MySQL would abort the load and drop 9,764 valid sales ($247,480.64 in revenue).
--
-- STRATEGY:
-- 1. Create table `sales` with strict foreign keys to `calendar`, `customers`, and `stores`.
-- 2. Leave `product_id` unconstrained at DDL stage to preserve 100% of transaction data,
--    enabling complete data quality auditing and reconciliation.
-- 3. In production dimensional modeling, orphan keys can be joined via LEFT JOIN or
--    mapped to a dummy 'Unassigned SKU' dimension record.
-- =============================================================================
CREATE TABLE sales (
    order_id    VARCHAR(15)   NOT NULL,
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
    PRIMARY KEY (order_id),
    CONSTRAINT fk_sales_calendar  FOREIGN KEY (order_date)  REFERENCES calendar (`date`),
    CONSTRAINT fk_sales_stores    FOREIGN KEY (store_id)    REFERENCES stores (store_id),
    CONSTRAINT fk_sales_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    -- CONSTRAINT fk_sales_products FOREIGN KEY (product_id) REFERENCES products(product_id)
    -- Intentionally omitted to retain 9,764 orphan-key records (P0000, P0201) for auditability.
) ENGINE=InnoDB;

-- Indexing for high-performance joins and aggregations
CREATE INDEX idx_sales_order_date  ON sales (order_date);
CREATE INDEX idx_sales_product_id  ON sales (product_id);
CREATE INDEX idx_sales_store_id    ON sales (store_id);
CREATE INDEX idx_sales_customer_id ON sales (customer_id);

-- =============================================================================
-- Step 4: DATA INGESTION (LOAD DATA INFILE)
-- Replace `<data_dir>` with the local path to raw CSV files (e.g. data/raw/).
-- Handlers account for both Windows (\r\n) and Unix (\n) line terminators.
-- =============================================================================
SET GLOBAL local_infile = 1;

-- 1. Ingest Calendar Dimension (731 rows)
-- LOAD DATA LOCAL INFILE '<data_dir>/calendar.csv'
-- INTO TABLE calendar
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (`date`, `year`, `month`, `day`, `week`, `day_of_week`);

-- 2. Ingest Customers Dimension (50,000 rows)
-- LOAD DATA LOCAL INFILE '<data_dir>/customers.csv'
-- INTO TABLE customers
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (customer_id, age, gender, loyalty_member, join_date);

-- 3. Ingest Products Catalog (200 rows)
-- LOAD DATA LOCAL INFILE '<data_dir>/products.csv'
-- INTO TABLE products
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (product_id, product_name, brand, category, cocoa_percent, weight_g);

-- 4. Ingest Stores Dimension (100 rows)
-- LOAD DATA LOCAL INFILE '<data_dir>/stores.csv'
-- INTO TABLE stores
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (store_id, store_name, city, country, store_type);

-- 5. Ingest Sales Fact Table (1,000,000 rows)
-- LOAD DATA LOCAL INFILE '<data_dir>/sales.csv'
-- INTO TABLE sales
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (order_id, order_date, product_id, store_id, customer_id, quantity, unit_price, discount, revenue, cost, profit);

-- =============================================================================
-- Step 5: Post-Load Ingestion Verification
-- Expected counts: calendar=731, customers=50,000, products=200, stores=100, sales=1,000,000
-- =============================================================================
SELECT 'calendar'  AS table_name, COUNT(*) AS row_count, 731       AS expected_count FROM calendar
UNION ALL
SELECT 'customers', COUNT(*), 50000   FROM customers
UNION ALL
SELECT 'products',  COUNT(*), 200     FROM products
UNION ALL
SELECT 'stores',    COUNT(*), 100     FROM stores
UNION ALL
SELECT 'sales',     COUNT(*), 1000000 FROM sales;
