# Dimensional Schema Design — Retail Store Analysis

## 1. Architectural Overview

The Retail Store Analysis project implements a **Dimensional Star Schema** optimized for high-performance analytical querying in SQL engines and star-schema processing in Power BI's VertiPaq tabular engine.

The schema consists of one central transaction Fact Table (`sales`) surrounded by four Dimension Tables (`products`, `customers`, `stores`, and `calendar`).

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
- **Total Gross Revenue:** **$25,486,128.86**
- **Total Operating Profit:** **$10,194,564.63**
- **Total COGS:** **$15,291,554.40**

| Column Name | SQL Data Type | Key Type | Description | Sample / Constraints |
|---|---|---|---|---|
| `order_id` | VARCHAR(15) | **Primary Key** | Unique sales transaction identifier | `0RD00000001` to `0RD01000000` |
| `order_date` | DATE | **Foreign Key** | Date transaction took place | References `calendar.date` |
| `product_id` | VARCHAR(10) | **Foreign Key** | Identifier for item purchased | References `products.product_id` |
| `store_id` | VARCHAR(10) | **Foreign Key** | Store facility where sale occurred | References `stores.store_id` |
| `customer_id` | VARCHAR(10) | **Foreign Key** | Customer who placed the order | References `customers.customer_id` |
| `quantity` | INT | Measure | Number of units purchased | Integer values 1 to 5 |
| `unit_price` | DECIMAL(10,2) | Measure | Baseline list price per unit | $10.00 to $20.00 |
| `discount` | DECIMAL(5,2) | Measure | Discount percentage applied | 0.00 to 0.20 (Mean: 5.62%) |
| `revenue` | DECIMAL(12,2) | Measure | Net sales amount after discount | $8.00 to $99.95 |
| `cost` | DECIMAL(12,2) | Measure | Total cost of goods sold (COGS) | $4.00 to $70.00 |
| `profit` | DECIMAL(12,2) | Measure | Net operating profit (`revenue - cost`) | $2.00 to $45.00 |

### 3.2 Dimension Table: `products`
- **Business Grain:** One row per catalog chocolate SKU.
- **Row Count:** 200 records.

| Column Name | SQL Data Type | Key Type | Description | Catalog Breakdown |
|---|---|---|---|---|
| `product_id` | VARCHAR(10) | **Primary Key** | Unique SKU identifier | `P0001` through `P0200` |
| `product_name` | VARCHAR(100) | Attribute | Full descriptive product label | e.g., "White Chocolate 80%" |
| `brand` | VARCHAR(50) | Attribute | Confectionery brand | Cadbury (37), Ferrero (37), Godiva (30), Hershey (28), Lindt (35), Mars (33) |
| `category` | VARCHAR(50) | Attribute | Product category format | Dark (42), Milk (26), Praline (53), Truffle (31), White (48) |
| `cocoa_percent` | INT | Attribute | Percentage cocoa solids | 50% (51), 60% (30), 70% (43), 80% (37), 90% (39) |
| `weight_g` | INT | Attribute | Product package net weight in grams | 50g (48), 80g (31), 100g (47), 120g (36), 200g (38) |

### 3.3 Dimension Table: `customers`
- **Business Grain:** One row per registered customer profile.
- **Row Count:** 50,000 records.

| Column Name | SQL Data Type | Key Type | Description | Distribution |
|---|---|---|---|---|
| `customer_id` | VARCHAR(10) | **Primary Key** | Unique customer identifier | `C000001` through `C050000` |
| `age` | INT | Attribute | Customer chronological age | Integer between 18 and 70 (Mean: 44.02) |
| `gender` | VARCHAR(10) | Attribute | Self-reported customer gender | 'Female' (49.5%), 'Male' (50.5%) |
| `loyalty_member` | INT | Attribute | Loyalty membership enrollment flag | 0 = Non-Member (49.8%), 1 = Member (50.2%) |
| `join_date` | DATE | Attribute | Registration date | 2020-01-01 through 2025-12-31 |

### 3.4 Dimension Table: `stores`
- **Business Grain:** One row per retail facility or storefront.
- **Row Count:** 100 records.

| Column Name | SQL Data Type | Key Type | Description | Distribution |
|---|---|---|---|---|
| `store_id` | VARCHAR(10) | **Primary Key** | Unique facility identifier | `S001` through `S100` |
| `store_name` | VARCHAR(100) | Attribute | Facility designation | "Chocolate Store 1" to "100" |
| `city` | VARCHAR(50) | Attribute | Metropolitan market location | Berlin (10), London (16), Melbourne (12), New York (15), Paris (16), Sydney (13), Toronto (18) |
| `country` | VARCHAR(50) | Attribute | Assigned country jurisdiction | Australia (15), Canada (20), France (14), Germany (11), UK (16), USA (24) |
| `store_type` | VARCHAR(30) | Attribute | Operating channel model | Airport (30), Mall (26), Online (25), Retail (19) |

### 3.5 Dimension Table: `calendar`
- **Business Grain:** One row per Gregorian calendar day.
- **Row Count:** 731 records (covers 2023 and 2024 leap year).

| Column Name | SQL Data Type | Key Type | Description | Values / Encoding |
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
   - **Enforcement:** Exactly 731 dates in 2023–2024; average of 1,368 sales transactions per day.

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
   - **Known Integrity Exception:** 9,764 transactions in `sales` reference `P0000` (4,895) and `P0201` (4,869), which do not exist in the 200-row product master. Handled via outer joins or an 'Unassigned SKU' dimension placeholder.
