# Dataset Audit — Retail Store Analytics

> **Status:** Completed & Validated  
> **Purpose:** Document dataset structure, schema grain, data quality auditing findings, entity relationships, and source-level limitations prior to reporting.  
> **Audit Principle:** Record verified empirical observations separately from business assumptions.

---

## 1. Dataset Overview

- **Dataset Name:** Retail Store Sales Dataset (2023–2024)
- **Source:** [Chocolate Sales Dataset 2023–2024 — Kaggle](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024)
- **Dataset Nature:** Synthetically generated retail transaction database
- **Reporting Period:** January 1, 2023 – December 31, 2024 (731 days, including leap year 2024)
- **File Format:** CSV (Comma-Separated Values, UTF-8)
- **Data Model:** Dimensional Star Schema with 1 Central Fact Table (`sales`) and 4 Dimension Tables (`calendar`, `customers`, `products`, `stores`)
- **Total Portfolio Volume:** 1,000,000 transaction records totaling $24,498,421.43 in gross revenue and $9,692,201.21 in gross operating profit.

---

## 2. Table Inventory & Grain Assessment

### 2.1 `calendar.csv` (Date Dimension)
- **Row Count:** 731
- **Column Count:** 6
- **Grain:** Exactly one record per calendar date from 2023-01-01 through 2024-12-31.
- **Primary Key:** `date` (Verified 100% unique, zero duplicates).
- **Date Attributes:** `date` (YYYY-MM-DD), `year` (2023, 2024), `month` (1–12), `day` (1–31), `week` (1–53), `day_of_week` (0=Monday to 6=Sunday).
- **Null Values:** 0 nulls across all fields.
- **Audit Findings:** Full temporal coverage across the 2-year analysis window with zero missing dates.

### 2.2 `customers.csv` (Customer Dimension)
- **Row Count:** 50,000
- **Column Count:** 5
- **Grain:** Exactly one record per registered customer profile.
- **Primary Key:** `customer_id` (`C000001` through `C050000`, 100% unique, zero duplicates).
- **Attributes:**
  - `customer_id` (VARCHAR(10)): Unique customer identifier.
  - `age` (INT): Customer age, bounded between 18 and 70 (Mean: 44.02).
  - `gender` (VARCHAR(10)): Binary classification — Female (25,057; 50.11%) and Male (24,943; 49.89%).
  - `loyalty_member` (INT/BOOLEAN): Membership flag — Non-Member (0: 25,078; 50.16%) and Member (1: 24,922; 49.84%).
  - `join_date` (DATE): Account creation date spanning 2020-01-01 through 2025-12-31.
- **Null Values:** 0 nulls across all fields.
- **Audit Findings:** Demographics show uniform random distributions across age, gender, and loyalty status.

### 2.3 `products.csv` (Product Dimension)
- **Row Count:** 200
- **Column Count:** 6
- **Grain:** Exactly one record per catalog SKU.
- **Primary Key:** `product_id` (`P0001` through `P0200`, 100% unique, zero duplicates).
- **Attributes:**
  - `product_id` (VARCHAR(10)): Primary SKU identifier.
  - `product_name` (VARCHAR(100)): Descriptive product label (e.g., "White Chocolate 80%").
  - `brand` (VARCHAR(50)): 6 unique chocolate manufacturers — Cadbury (35), Ferrero (34), Godiva (35), Hershey (33), Lindt (33), Mars (30).
  - `category` (VARCHAR(50)): 4 confection categories — Bar (53), Bites (46), Praline (49), Truffle (52).
  - `cocoa_percent` (INT): Discrete percentage tiers — 50%, 60%, 70%, 80%.
  - `weight_g` (INT): Package sizes — 80g (37), 100g (44), 120g (40), 150g (39), 200g (40).
- **Null Values:** 0 nulls across all fields.

### 2.4 `stores.csv` (Store Dimension)
- **Row Count:** 100
- **Column Count:** 5
- **Grain:** Exactly one record per retail facility.
- **Primary Key:** `store_id` (`S001` through `S100`, 100% unique, zero duplicates).
- **Attributes:**
  - `store_id` (VARCHAR(10)): Store identifier.
  - `store_name` (VARCHAR(100)): Facility name ("Chocolate Store 1" to "Chocolate Store 100").
  - `city` (VARCHAR(50)): 7 distinct metropolitan areas (Berlin, London, Melbourne, New York, Paris, Sydney, Toronto).
  - `country` (VARCHAR(50)): 6 distinct sovereign nations (Australia, Canada, France, Germany, UK, USA).
  - `store_type` (VARCHAR(30)): 4 operating formats — Retail (40), Mall (25), Online (20), Airport (15).
- **Null Values:** 0 nulls across all fields.

### 2.5 `sales.csv` (Fact Table)
- **Row Count:** 1,000,000
- **Column Count:** 11
- **Grain:** Individual sales transaction line item.
- **Primary Key:** `order_id` (`0RD00000001` through `0RD01000000`, 100% unique, zero duplicates).
- **Foreign Keys:**
  - `product_id` -> `products.product_id`
  - `customer_id` -> `customers.customer_id`
  - `store_id` -> `stores.store_id`
  - `order_date` -> `calendar.date`
- **Measures:**
  - `quantity`: Order units (1 to 5 units; Mean: 3.00; Total: 2,999,021 units).
  - `unit_price`: Item list price ($10.00 to $20.00; Mean: $14.99).
  - `discount`: Discount percentage applied (0.00 to 0.20; discrete values: 0%, 5%, 10%, 15%, 20%).
  - `revenue`: Recorded gross sale amount ($8.00 to $99.95; Sum: $24,498,421.43).
  - `cost`: Cost of goods sold ($4.00 to $70.00; Sum: $14,806,220.22).
  - `profit`: Recorded operating profit ($2.00 to $45.00; Sum: $9,692,201.21).
- **Null Values:** 0 nulls across all fields.

---

## 3. Entity Relationships & Referential Integrity

| Relationship | Cardinality | Join Keys | Integrity Status | Impact & Notes |
|---|---|---|---|---|
| Sales → Products | Many-to-One (N:1) | `sales.product_id` = `products.product_id` | **Violated** (9,764 orphan rows) | Two keys (`P0000`, `P0201`) in sales do not exist in products catalog |
| Sales → Customers | Many-to-One (N:1) | `sales.customer_id` = `customers.customer_id` | **100% Verified** | All 1,000,000 sales link cleanly to 50,000 unique customers |
| Sales → Stores | Many-to-One (N:1) | `sales.store_id` = `stores.store_id` | **100% Verified** | All 1,000,000 sales link cleanly to 100 stores |
| Sales → Calendar | Many-to-One (N:1) | `sales.order_date` = `calendar.date` | **100% Verified** | All 1,000,000 transactions map to the 731 dates |

---

## 4. Empirical Data Quality Findings & Anomalies

### 4.1 Orphan Product Identifiers (`P0000` & `P0201`)
- **Observation:** `sales.csv` contains 9,764 records (0.98% of total transactions) referencing product IDs outside the master product catalog:
  - `P0000`: 4,932 records ($120,629.62 in revenue, $47,758.33 in profit)
  - `P0201`: 4,832 records ($117,994.04 in revenue, $46,658.07 in profit)
- **Analytical Handling:** 
  - Do NOT delete or drop these records, as they represent valid financial transactions ($238,623.66 total revenue).
  - In SQL and Power BI, classify these records under Brand: `Unknown / Unassigned` and Category: `Unassigned` using `COALESCE` or `IF(ISBLANK())` measures.

### 4.2 Floating-Point Calculation Variances (~$0.01)
- **Revenue Calculation:**
  $$\text{Expected Revenue} = \text{ROUND}(\text{quantity} \times \text{unit\_price} \times (1 - \text{discount}), 2)$$
  - Exactly **2,646 records** (0.26% of transactions) differ from the recorded `revenue` column by $\pm \$0.01$.
- **Profit Calculation:**
  $$\text{Expected Profit} = \text{ROUND}(\text{revenue} - \text{cost}, 2)$$
  - Exactly **27,915 records** (2.79% of transactions) differ from the recorded `profit` column by $\pm \$0.01$.
- **Root Cause:** Standard floating-point rounding artifacts introduced during synthetic data generation.
- **Handling:** Maintain recorded financial columns as the source of truth for exact portfolio reconciliation.

### 4.3 Store Geographic Inconsistency (80% Discordance)
- **Observation:** When cross-referencing `city` and `country` against established real-world geography, **80 out of 100 stores** are mapped inconsistently (e.g., Paris assigned to UK, Berlin to France, Melbourne to Canada).
- **Audit Breakdown:**
  - 20 stores match valid real-world pairs (e.g., New York, USA; Toronto, Canada).
  - 80 stores contain mismatched pairings due to independent uniform randomization during dataset creation.
- **Handling:** Document clearly that `city` and `country` are synthetic attributes. Analyze city performance and store-type performance independently rather than building a rigid geographical hierarchy.

### 4.4 Synthetic Uniformity Across Dimensions
- Intra-week daily revenue fluctuates by less than 0.6% ($34,788 to $34,982 per day).
- Monthly revenue fluctuates by less than 2.0% across the 24 months.
- Customer age groups, genders, and loyalty tiers each exhibit virtually identical order volumes and spend per order.
- Brand revenue is evenly split across all 6 brands (~$4.0M to $4.1M each).
- **Implication:** The dataset exhibits hallmarks of uniform pseudo-random synthesis. Analyses must highlight these descriptive truths without asserting speculative real-world behavioral claims.

---

## 5. Remediation & Handling Strategy

1. **Database Schema:** Foreign key constraint on `sales.product_id` must either allow missing keys, or include a dummy record in `products` for `P0000` and `P0201` marked as 'Unknown SKU'.
2. **Power BI Data Model:** Relationships configured with single-direction filtering. Measures incorporate `COALESCE()` and explicit error-handling.
3. **Reporting & Presentation:** Explicitly acknowledge synthetic limitations in the README and portfolio presentation to showcase senior-level data quality discernment.
