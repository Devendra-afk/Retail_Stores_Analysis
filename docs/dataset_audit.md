# Dataset Audit — Retail Store Analytics

> **Status:** Completed & Independently Validated  
> **Purpose:** Document dataset structure, schema grain, empirical data quality audit findings, entity relationships, and source-level limitations.  
> **Audit Principle:** Record verified empirical observations separately from assumptions.

---

## 1. Dataset Overview

- **Dataset Name:** Retail Store Sales Dataset (2023–2024)
- **Source:** [Chocolate Sales Dataset 2023–2024 — Kaggle](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024)
- **Dataset Nature:** Synthetically generated commercial retail transaction database
- **Reporting Period:** January 1, 2023 – December 31, 2024 (731 days, leap year)
- **File Format:** CSV (Comma-Separated Values, UTF-8)
- **Data Model:** Dimensional Star Schema with 1 Central Fact Table (`sales`) and 4 Dimension Tables (`calendar`, `customers`, `products`, `stores`)
- **Total Portfolio Volume:** 1,000,000 transaction line items totaling **$25,486,128.86 in gross revenue** and **$10,194,564.63 in operating profit**.

---

## 2. Table Inventory & Grain Assessment

### 2.1 `calendar.csv` (Date Dimension)
- **Row Count:** 731
- **Column Count:** 6
- **Grain:** Exactly one record per calendar date from 2023-01-01 through 2024-12-31.
- **Primary Key:** `date` (Verified 100% unique, zero duplicates).
- **Date Attributes:** `date` (YYYY-MM-DD), `year` (2023, 2024), `month` (1–12), `day` (1–31), `week` (1–53), `day_of_week` (0 to 6).
- **Day of Week Encoding:** 
  - `0` = Monday (105 days)
  - `1` = Tuesday (105 days)
  - `2` = Wednesday (104 days)
  - `3` = Thursday (104 days)
  - `4` = Friday (104 days)
  - `5` = Saturday (104 days)
  - `6` = Sunday (105 days)
- **Null Values:** 0 nulls across all fields.

### 2.2 `customers.csv` (Customer Dimension)
- **Row Count:** 50,000
- **Column Count:** 5
- **Grain:** Exactly one record per registered customer profile.
- **Primary Key:** `customer_id` (`C000001` through `C050000`, 100% unique, zero duplicates).
- **Attributes:**
  - `customer_id` (VARCHAR(10)): Unique customer identifier.
  - `age` (INT): Customer age, bounded between 18 and 70 (Mean: 44.02).
  - `gender` (VARCHAR(10)): Female (24,758; 49.52%) and Male (25,242; 50.48%).
  - `loyalty_member` (INT): Non-Member (`0`: 24,896; 49.79%) and Member (`1`: 25,104; 50.21%).
  - `join_date` (DATE): Account registration date spanning 2020-01-01 through 2025-12-31.
- **Null Values:** 0 nulls across all fields.

### 2.3 `products.csv` (Product Master Catalog)
- **Row Count:** 200
- **Column Count:** 6
- **Grain:** Exactly one record per catalog SKU.
- **Primary Key:** `product_id` (`P0001` through `P0200`, 100% unique, zero duplicates).
- **Attributes:**
  - `product_id` (VARCHAR(10)): Primary SKU identifier.
  - `product_name` (VARCHAR(100)): Descriptive product label (e.g., "White Chocolate 80%").
  - `brand` (VARCHAR(50)): 6 confectionery brands — Cadbury (37), Ferrero (37), Godiva (30), Hershey (28), Lindt (35), Mars (33).
  - `category` (VARCHAR(50)): 5 confectionery categories — Dark (42), Milk (26), Praline (53), Truffle (31), White (48).
  - `cocoa_percent` (INT): 5 discrete percentage tiers — 50% (51), 60% (30), 70% (43), 80% (37), 90% (39).
  - `weight_g` (INT): 5 package sizes — 50g (48), 80g (31), 100g (47), 120g (36), 200g (38).
- **Null Values:** 0 nulls across all fields.

### 2.4 `stores.csv` (Store Facility Dimension)
- **Row Count:** 100
- **Column Count:** 5
- **Grain:** Exactly one record per retail location.
- **Primary Key:** `store_id` (`S001` through `S100`, 100% unique, zero duplicates).
- **Attributes:**
  - `store_id` (VARCHAR(10)): Facility identifier.
  - `store_name` (VARCHAR(100)): Facility name ("Chocolate Store 1" to "Chocolate Store 100").
  - `city` (VARCHAR(50)): 7 metropolitan areas — Berlin (10), London (16), Melbourne (12), New York (15), Paris (16), Sydney (13), Toronto (18).
  - `country` (VARCHAR(50)): 6 sovereign nations — Australia (15), Canada (20), France (14), Germany (11), UK (16), USA (24).
  - `store_type` (VARCHAR(30)): 4 operating formats — Airport (30), Mall (26), Online (25), Retail (19).
- **Null Values:** 0 nulls across all fields.

### 2.5 `sales.csv` (Fact Table)
- **Row Count:** 1,000,000
- **Column Count:** 11
- **Grain:** Individual sales transaction line item.
- **Primary Key:** `order_id` (`0RD00000001` through `0RD01000000`, 100% unique, zero duplicates).
- **Measures:**
  - `quantity`: Units purchased (1 to 5; Total: 2,999,589 units; Mean: 3.00).
  - `unit_price`: Item list price ($10.00 to $20.00; Mean: $14.99).
  - `discount`: Discount rate applied (0.00 to 0.20; Mean: 5.62%).
  - `revenue`: Recorded sale amount after discount (Sum: **$25,486,128.86**).
  - `cost`: Cost of goods sold (Sum: **$15,291,554.40**).
  - `profit`: Recorded operating profit (Sum: **$10,194,564.63**).
- **Null Values:** 0 nulls across all fields.

---

## 3. Entity Relationships & Referential Integrity

| Relationship | Cardinality | Join Keys | Referential Integrity Status | Impact & Handling |
|---|---|---|---|---|
| Sales → Products | Many-to-One (N:1) | `sales.product_id` = `products.product_id` | **Violated (9,764 orphan rows)** | Keys `P0000` (4,895 rows) and `P0201` (4,869 rows) in sales do not exist in catalog |
| Sales → Customers | Many-to-One (N:1) | `sales.customer_id` = `customers.customer_id` | **100% Verified** | All 1,000,000 sales link cleanly to 50,000 unique customers |
| Sales → Stores | Many-to-One (N:1) | `sales.store_id` = `stores.store_id` | **100% Verified** | All 1,000,000 sales link cleanly to 100 stores |
| Sales → Calendar | Many-to-One (N:1) | `sales.order_date` = `calendar.date` | **100% Verified** | All 1,000,000 transactions map to the 731 dates |

---

## 4. Empirical Data Quality Findings & Calculations

### 4.1 Orphan Product Identifiers (`P0000` & `P0201`)
- **Observation:** Exactly **9,764 transaction records** (0.98% of total volume) reference product IDs that do not exist in `products.csv`:
  - `P0000`: 4,895 records ($124,196.82 in revenue, $49,663.85 in profit, 14,570 units)
  - `P0201`: 4,869 records ($123,283.82 in revenue, $49,258.87 in profit, 14,549 units)
  - **Total Orphan Value:** **$247,480.64 in revenue** (0.97% of total sales) and **$98,922.72 in profit**.
- **Analytical Handling:** 
  - These records represent real transactional activity and are preserved.
  - In SQL queries and Power BI models, they are categorized as `Unassigned / Orphan Keys` using `LEFT JOIN` and `COALESCE` logic.
  - DDL for `sales` omits the foreign key constraint on `product_id` to prevent data loss during ingestion.

### 4.2 Exact One-Cent Discrepancies vs. Discrepancies Greater Than One Cent
To evaluate calculation integrity, we compared source columns against standard accounting formulas:
1. **Revenue Formula:** $\text{Expected Revenue} = \text{ROUND}(\text{quantity} \times \text{unit\_price} \times (1 - \text{discount}), 2)$
   - **Exact Match ($\text{diff} = \$0.00$):** **991,079 rows (99.11%)**
   - **Negative One-Cent Difference ($\text{diff} = -\$0.01$):** **4,579 rows (0.46%)**
   - **Positive One-Cent Difference ($\text{diff} = +\$0.01$):** **4,342 rows (0.43%)**
   - **Total One-Cent Discrepancies:** **8,921 rows (0.89%)**
   - **Discrepancies Greater Than One Cent ($|\text{diff}| > \$0.01$):** **0 rows (0.00%)**!
2. **Profit Formula:** $\text{Expected Profit} = \text{ROUND}(\text{revenue} - \text{cost}, 2)$
   - **Exact Match ($\text{diff} = \$0.00$):** **914,521 rows (91.45%)**
   - **Negative One-Cent Difference ($\text{diff} = -\$0.01$):** **42,248 rows (4.22%)**
   - **Positive One-Cent Difference ($\text{diff} = +\$0.01$):** **43,231 rows (4.32%)**
   - **Total One-Cent Discrepancies:** **85,479 rows (8.55%)**
   - **Discrepancies Greater Than One Cent ($|\text{diff}| > \$0.01$):** **0 rows (0.00%)**!

> **Distinction:** An *exact one-cent discrepancy* arises from intermediate floating-point rounding during data generation (e.g. `25.485` rounding to `25.48` vs `25.49`). A *discrepancy greater than one cent* would indicate an underlying logic, currency, or data entry error. The fact that **zero rows** differ by more than $0.01 confirms that the calculations follow the intended formulas. Recorded source values are maintained as the ground-truth financial ledger.

### 4.3 Store Geographic Inconsistency (80% Discordance)
- **Observation:** When cross-referencing `city` and `country` against real-world geography, **80 out of 100 stores** contain discordant pairings (e.g., Paris assigned to UK, Berlin to France, Melbourne to Canada).
- **Breakdown:**
  - Consistent real-world pairings: **20 stores** (New York, USA: 4; Toronto, Canada: 6; Berlin, Germany: 2; London, UK: 3; Melbourne, Australia: 1; Paris, France: 2; Sydney, Australia: 2).
  - Discordant pairings: **80 stores** (due to independent uniform sampling).
- **Handling:** City and store-type metrics are analyzed independently rather than grouped into a rigid geographic hierarchy.

### 4.4 Synthetic Uniformity
- Day-of-week sales vary by less than **0.6%** ($34,788.94 to $34,982.97 per day).
- Monthly revenue fluctuates by less than **2.0%** across the 24 months.
- Customer age groups, genders, and loyalty tiers each exhibit virtually identical order volumes and spend per order.
- Brand revenue is distributed with consistent ~40.0% operating margins.
- **Handling:** Findings are documented as descriptive characteristics of the dataset, avoiding unsupported causal claims.
