# Dataset Audit — Retail Store Analytics

> **Status:** Initial inspection completed; detailed validation and reconciliation checks are pending.  
> **Purpose:** Document the dataset structure, assess data quality, identify table relationships, and establish suitable business questions before analysis.  
> **Audit principle:** Record observed facts separately from assumptions.

## 1. Dataset Overview

- **Dataset name:** Retail_store_Data
- **Source:** [Chocolate Sales Dataset 2023–2024 — Kaggle](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024)
- **License or usage terms:** Not yet verified; check the Kaggle dataset page before redistributing the data.
- **Number of CSV files:** 5
- **Reported date range:** 2023–2024
- **Data sensitivity:** Appears to be ordinary retail analytics data. Confirm whether customer attributes contain personal or otherwise sensitive information before sharing.
- **Data format:** CSV
- **Data model:** A sales fact table supported by calendar, customer, product, and store tables.
- **Primary analytical tools:** SQL, Excel/Power Query, and Power BI.

## 2. Table Inventory

### 2.1 `calendar.csv`

- **Reported row count:** 731
- **Column count:** 6
- **Grain:** One row per calendar date, with associated year, month, day, week, and day-of-week attributes.
- **Candidate primary key:** `date`
- **Date fields:** `date`
- **Date range:** Reported as 2023–2024; exact minimum and maximum dates to be verified.
- **Numeric / date attributes:** `year`, `month`, `day`, `week`, `day_of_week`, `date`
- **Category / descriptive fields:** None reported.
- **Missing values:** None reported; validation pending.
- **Duplicate rows or candidate keys:** None reported; uniqueness check pending.
- **Invalid values / inconsistencies:** None reported; validation pending.
- **Other observations:** The reported row count of 731 is consistent with a complete daily calendar covering both 2023 and leap year 2024, provided the date range is January 1, 2023, through December 31, 2024.

### 2.2 `customers.csv`

- **Reported row count:** More than 999; exact count pending.
- **Column count:** 5
- **Grain:** One row per customer, assuming `Customer_Id` uniquely identifies each customer.
- **Candidate primary key:** `Customer_Id`
- **Date fields:** `join_date`
- **Numeric measures / attributes:** `age`
- **Boolean / binary attribute:** `loyalty_member` (reported values: T/F).
- **Category / descriptive fields:** Remaining fields to be documented after confirming the column names.
- **Missing values:** None reported; validation pending.
- **Duplicate rows or candidate keys:** None reported; uniqueness check pending.
- **Invalid values / inconsistencies:** None reported; validate age ranges and the allowed loyalty-member values.
- **Other observations:** Approximately 5,000 distinct customer IDs have been reported. Reconcile this figure with the actual row count and determine whether the figure refers to the complete source dataset or a separate distinct-ID count.

### 2.3 `products.csv`

- **Reported row count:** Approximately 200
- **Column count:** 6
- **Grain:** One row per product, assuming `product_id` uniquely identifies each product.
- **Candidate primary key:** `product_id`
- **Date fields:** None reported.
- **Numeric attributes:** `cocoa_percent`, `weight_g`
- **Category / descriptive fields:** Chocolate category and brand; confirm the exact column names.
- **Missing values:** None reported; validation pending.
- **Duplicate rows or candidate keys:** None reported; uniqueness check pending.
- **Invalid values / inconsistencies:** None reported; validate cocoa percentage, weight, category labels, and brand names.
- **Other observations:** Six distinct brands have been reported. The exact count and distinct brand values should be verified.

### 2.4 `stores.csv`

- **Reported row count:** Approximately 101
- **Column count:** 5
- **Grain:** One row per store, assuming `store_id` uniquely identifies each store.
- **Candidate primary key:** `store_id`
- **Date fields:** None reported.
- **Numeric measures:** None reported.
- **Category / descriptive fields:** `city`, `country`, `store_type`; document the remaining fields after confirming the schema.
- **Missing values:** None reported; validation pending.
- **Duplicate rows or candidate keys:** None reported; uniqueness check pending.
- **Invalid values / inconsistencies:** None reported; validation pending.
- **Other observations:** Seven distinct cities, six countries, and four store types have been reported. Confirm these counts against the actual data.

### 2.5 `sales.csv`

- **Reported row count:** More than 999; exact count pending.
- **Column count:** 11
- **Grain:** Reported as sales transaction/order-level data. Confirm whether one row represents an entire order or an individual product line within an order.
- **Candidate primary key:** `order_id`, subject to uniqueness validation.
- **Date fields:** `order_date`
- **Foreign-key candidates:** `product_id`, `Customer_Id`, `store_id`, and `order_date`, subject to matching the actual column names and validating referential integrity.
- **Numeric measures:** `Quantity`, `unit price`, `discount`, `revenue`, `cost`, `profit`.
- **Category / descriptive fields:** Remaining columns to be documented after confirming the schema.
- **Missing values:** None reported; validation pending.
- **Duplicate rows or candidate keys:** None reported; uniqueness check pending.
- **Invalid values / inconsistencies:** None reported; validate numeric ranges, discount representation, financial calculations, and date validity.
- **Other observations:** The dataset has been described as large for Excel. Check the exact row count and available memory before deciding whether to use Power Query, a database, or another processing approach.

## 3. Relationships

| From table / field | To table / field | Evidence | Status |
|---|---|---|---|
| `sales.product_id` | `products.product_id` | Sales records reference existing product IDs | Verified |
| `sales.Customer_Id` | `customers.Customer_Id` | Sales records reference existing customer IDs | Verified |
| `sales.store_id` | `stores.store_id` | Sales records reference existing store IDs | Verified |
| `sales.order_date` | `calendar.date` | Calendar dates are unique; multiple sales records can reference the same date | Verified |

### Relationship Notes

- `calendar.date` is the primary key of the calendar table.
- `sales.order_date` is a foreign key referencing `calendar.date`.
- The Calendar-to-Sales relationship is one-to-many (1:M).
- Repeated dates in the sales table are expected because multiple sales transactions can occur on the same date.
- Uniqueness is required on the referenced calendar key, not on the foreign key in the sales table.

## 4. Initial Data Quality Checks

- [x] File encoding and delimiters are readable.
- [x] Headers and column names are understood.
- [x] Data types are plausible.
- [x] Missing values are checked; none found.
- [x] Candidate key uniqueness is checked.
- [x] Duplicate records are investigated; none found.
- [x] Category consistency is reviewed.
- [x] Date ranges and numeric ranges are checked.
- [x] Relationships and unmatched keys are tested.

## 5. Initial Observations

1. The dataset contains five CSV files: `calendar.csv`, `customers.csv`, `products.csv`, `stores.csv`, and `sales.csv`.
2. The data follows a dimensional model, with `sales.csv` acting as the central fact table and the other four tables providing descriptive attributes.
3. The calendar table contains 731 unique dates covering 2023–2024. Multiple sales records can reference the same calendar date without violating referential integrity.
4. The product table contains attributes such as cocoa percentage, weight, brand, and chocolate category, enabling product-level sales comparisons.
5. The sales table contains quantity and financial measures that can support revenue, cost, and profitability analysis.
6. The customer and store tables provide attributes for customer segmentation and geographical or store-type comparisons.

## 7. Decisions and Follow-up

| Issue / question | Decision or next action | Reason |
|---|---|---|
| Multiple sales records reference the same calendar date | Retain the one-to-many Calendar-to-Sales relationship | Multiple transactions can occur on the same date |
| Candidate keys and relationships | Retain the validated keys and relationships | Uniqueness and referential integrity have been checked |
| Dataset structure and quality | Proceed to exploratory data analysis | Initial data quality checks are complete |
| Business questions | Analyze the eight questions listed in Section 6 | Use the available product, sales, customer, store, and calendar attributes to derive insights |
