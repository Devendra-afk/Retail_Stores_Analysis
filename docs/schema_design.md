# Dimensional Schema Design — Retail Store Analysis

## 1. Architectural Overview

The Retail Store Analysis project implements a classic **Dimensional Star Schema** optimized for high-performance analytical querying and business intelligence reporting. 

The schema consists of one central transaction Fact Table (`sales`) surrounded by four Dimension Tables (`products`, `customers`, `stores`, and `calendar`). This design provides optimal aggregation efficiency in SQL engines and star-schema optimization in Power BI's VertiPaq columnar in-memory engine.

---

## 2. Entity Relationship Diagram (ERD)

![Retail Store Analysis Schema](Schema_Design.png)

```
        +-------------------+              +-------------------+
        |     calendar      |              |     customers     |
        +-------------------+              +-------------------+
        | PK  date          |              | PK  customer_id   |
        |     year          |              |     age           |
        |     month         |              |     gender        |
        |     day           |              |     loyalty_member|
        |     week          |              |     join_date     |
        |     day_of_week   |              +---------+---------+
        +---------+---------+                        |
                  |                                  |
                  | 1                                | 1
                  |                                  |
                  | N                                | N
        +---------+----------------------------------+---------+
        |                      sales (Fact)                     |
        +-------------------------------------------------------+
        | PK  order_id                                          |
        | FK  order_date                                        |
        | FK  product_id                                        |
        | FK  store_id                                          |
        | FK  customer_id                                       |
        |     quantity                                          |
        |     unit_price                                        |
        |     discount                                          |
        |     revenue                                           |
        |     cost                                              |
        |     profit                                            |
        +---------+----------------------------------+---------+
                  | N                                | N
                  |                                  |
                  | 1                                | 1
        +---------+---------+              +---------+---------+
        |     products      |              |      stores       |
        +-------------------+              +-------------------+
        | PK  product_id    |              | PK  store_id      |
        |     product_name  |              |     store_name    |
        |     brand         |              |     city          |
        |     category      |              |     country       |
        |     cocoa_percent |              |     store_type    |
        |     weight_g      |              +-------------------+
        +-------------------+
```

---

## 3. Data Dictionary & Table Specifications

### 3.1 Fact Table: `sales`
- **Business Grain:** One line item per order transaction.
- **Row Count:** 1,000,000 records.
- **Total Gross Revenue:** $24,498,421.43
- **Total Operating Profit:** $9,692,201.21

| Column Name | SQL Data Type | Key Type | Description | Sample / Constraints |
|---|---|---|---|---|
| `order_id` | VARCHAR(15) | **Primary Key** | Unique sales transaction identifier | `0RD00000001` to `0RD01000000` |
| `order_date` | DATE | **Foreign Key** | Date transaction took place | References `calendar.date` |
| `product_id` | VARCHAR(10) | **Foreign Key** | Identifier for item purchased | References `products.product_id` |
| `store_id` | VARCHAR(10) | **Foreign Key** | Store facility where sale occurred | References `stores.store_id` |
| `customer_id` | VARCHAR(10) | **Foreign Key** | Customer who placed the order | References `customers.customer_id` |
| `quantity` | INT | Measure | Number of units purchased | Integer values 1 to 5 |
| `unit_price` | DECIMAL(10,2) | Measure | Baseline list price per unit | $10.00 to $20.00 |
| `discount` | DECIMAL(5,2) | Measure | Discount percentage applied | 0.00, 0.05, 0.10, 0.15, 0.20 |
| `revenue` | DECIMAL(10,2) | Measure | Net sales amount after discount | $8.00 to $99.95 |
| `cost` | DECIMAL(10,2) | Measure | Total cost of goods sold (COGS) | $4.00 to $70.00 |
| `profit` | DECIMAL(10,2) | Measure | Net profit before overhead (`revenue - cost`) | $2.00 to $45.00 |

### 3.2 Dimension Table: `products`
- **Business Grain:** One row per catalog chocolate product SKU.
- **Row Count:** 200 records.

| Column Name | SQL Data Type | Key Type | Description | Allowed Values / Ranges |
|---|---|---|---|---|
| `product_id` | VARCHAR(10) | **Primary Key** | Unique SKU identifier | `P0001` through `P0200` |
| `product_name` | VARCHAR(100) | Attribute | Full descriptive product label | e.g., "White Chocolate 80%" |
| `brand` | VARCHAR(50) | Attribute | Chocolate manufacturing brand | Cadbury, Ferrero, Godiva, Hershey, Lindt, Mars |
| `category` | VARCHAR(50) | Attribute | Confectionery category format | Bar, Bites, Praline, Truffle |
| `cocoa_percent` | INT | Attribute | Percentage cocoa solids | 50%, 60%, 70%, 80% |
| `weight_g` | INT | Attribute | Product package net weight in grams | 80g, 100g, 120g, 150g, 200g |

### 3.3 Dimension Table: `customers`
- **Business Grain:** One row per registered loyalty / customer profile.
- **Row Count:** 50,000 records.

| Column Name | SQL Data Type | Key Type | Description | Allowed Values / Ranges |
|---|---|---|---|---|
| `customer_id` | VARCHAR(10) | **Primary Key** | Unique customer identifier | `C000001` through `C050000` |
| `age` | INT | Attribute | Customer chronological age | Integer between 18 and 70 |
| `gender` | VARCHAR(10) | Attribute | Self-reported customer gender | 'Female' (50.1%), 'Male' (49.9%) |
| `loyalty_member` | INT | Attribute | Loyalty membership enrollment flag | 0 = Non-Member, 1 = Member |
| `join_date` | DATE | Attribute | Registration date | 2020-01-01 through 2025-12-31 |

### 3.4 Dimension Table: `stores`
- **Business Grain:** One row per retail facility or digital storefront.
- **Row Count:** 100 records.

| Column Name | SQL Data Type | Key Type | Description | Allowed Values / Ranges |
|---|---|---|---|---|
| `store_id` | VARCHAR(10) | **Primary Key** | Unique facility identifier | `S001` through `S100` |
| `store_name` | VARCHAR(100) | Attribute | Facility designation | "Chocolate Store 1" to "100" |
| `city` | VARCHAR(50) | Attribute | Metropolitan market location | Berlin, London, Melbourne, New York, Paris, Sydney, Toronto |
| `country` | VARCHAR(50) | Attribute | Assigned country jurisdiction | Australia, Canada, France, Germany, UK, USA |
| `store_type` | VARCHAR(30) | Attribute | Operating channel model | Retail (40), Mall (25), Online (20), Airport (15) |

### 3.5 Dimension Table: `calendar`
- **Business Grain:** One row per Gregorian calendar day.
- **Row Count:** 731 records (covers 2023 and 2024 leap year).

| Column Name | SQL Data Type | Key Type | Description | Allowed Values / Ranges |
|---|---|---|---|---|
| `date` | DATE | **Primary Key** | Gregorian date identifier | 2023-01-01 to 2024-12-31 |
| `year` | INT | Attribute | Calendar year | 2023, 2024 |
| `month` | INT | Attribute | Numerical calendar month | 1 to 12 |
| `day` | INT | Attribute | Calendar day of month | 1 to 31 |
| `week` | INT | Attribute | ISO calendar week number | 1 to 53 |
| `day_of_week` | INT | Attribute | Numerical day of week | 0 (Monday) to 6 (Sunday) |

---

## 4. Key Relationships & Cardinalities

1. **`calendar` (1) ───< (N) `sales`**
   - **Primary Key:** `calendar.date`
   - **Foreign Key:** `sales.order_date`
   - **Cardinality:** 1 to Many (1:N)
   - **Enforcement:** Each date in 2023–2024 has ~1,368 sales transactions.

2. **`customers` (1) ───< (N) `sales`**
   - **Primary Key:** `customers.customer_id`
   - **Foreign Key:** `sales.customer_id`
   - **Cardinality:** 1 to Many (1:N)
   - **Enforcement:** 100% referential integrity; average of 20 orders per customer.

3. **`stores` (1) ───< (N) `sales`**
   - **Primary Key:** `stores.store_id`
   - **Foreign Key:** `sales.store_id`
   - **Cardinality:** 1 to Many (1:N)
   - **Enforcement:** 100% referential integrity; average of 10,000 orders per store.

4. **`products` (1) ───< (N) `sales`**
   - **Primary Key:** `products.product_id`
   - **Foreign Key:** `sales.product_id`
   - **Cardinality:** 1 to Many (1:N)
   - **Known Integrity Exception:** 9,764 transactions in `sales` reference `P0000` (4,932) and `P0201` (4,832), which do not exist in the 200-row product master. Handled in ETL/modeling via outer joins or an 'Unknown SKU' dimension placeholder.

---

## 5. Analytical Integrity & Star Schema Benefits

- **Performance Optimization:** Star schema eliminates complex multi-table snowflake joins, accelerating aggregations across 1,000,000 fact rows.
- **Measure Reusability:** Measures defined on `sales` (`Total Revenue`, `Total Profit`, `Total Units`) slice seamlessly across any combination of time, customer, product, and store dimensions without double-counting.
- **Compatibility:** Directly aligns with standard SQL reporting and Power BI's VertiPaq tabular storage architecture.
