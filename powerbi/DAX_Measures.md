# Power BI DAX Measures & Data Model Documentation

This document defines all **23 DAX measures** implemented in the **Retail Stores Sales Analysis (2023–2024)** Tabular Model (`model.bim`). Every calculation has been reconciled and cross-validated against Python (Pandas) and SQL query results to guarantee mathematical accuracy.

---

## 1. Core Financial Measures (Base Aggregations)

### `[Total Revenue]`
```dax
Total Revenue = SUM(sales[revenue])
```
- **Description:** Sum of net sales revenue after discounts across all 1,000,000 transactions.
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$25,486,128.86**

### `[Total Cost]`
```dax
Total Cost = SUM(sales[cost])
```
- **Description:** Total cost of goods sold (COGS).
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$15,291,554.40**

### `[Total Profit]`
```dax
Total Profit = SUM(sales[profit])
```
- **Description:** Net operating profit generated across transactions (`revenue - cost`).
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$10,194,564.63**

### `[Total Quantity]`
```dax
Total Quantity = SUM(sales[quantity])
```
- **Description:** Total volume of chocolate units sold.
- **Format:** Whole Number (`#,##0`)
- **Validated Benchmark:** **2,999,589 units**

### `[Total Orders]`
```dax
Total Orders = DISTINCTCOUNT(sales[order_id])
```
- **Description:** Total count of distinct sales transaction line items.
- **Format:** Whole Number (`#,##0`)
- **Validated Benchmark:** **1,000,000 orders**

---

## 2. Derived Performance & Efficiency Measures

### `[Profit Margin %]`
```dax
Profit Margin % = 
DIVIDE([Total Profit], [Total Revenue], 0)
```
- **Description:** Operating profit margin percentage.
- **Format:** Percentage (`0.00%`)
- **Validated Benchmark:** **40.00%** ($10,194,564.63 / $25,486,128.86)

### `[Average Order Value]`
```dax
Average Order Value = 
DIVIDE([Total Revenue], [Total Orders], 0)
```
- **Description:** Average revenue per transaction basket.
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$25.49**

### `[Average Selling Price]`
```dax
Average Selling Price = 
DIVIDE([Total Revenue], [Total Quantity], 0)
```
- **Description:** Effective realized net price per chocolate unit.
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$8.50**

### `[Average Discount %]`
```dax
Average Discount % = 
AVERAGE(sales[discount])
```
- **Description:** Mean promotional discount percentage across sales.
- **Format:** Percentage (`0.00%`)
- **Validated Benchmark:** **5.62%**

---

## 3. Time Intelligence & Year-over-Year (YoY) Measures

### `[2023 Revenue]`
```dax
2023 Revenue = 
CALCULATE(
    [Total Revenue],
    calendar[year] = 2023
)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$12,735,106.27**

### `[2024 Revenue]`
```dax
2024 Revenue = 
CALCULATE(
    [Total Revenue],
    calendar[year] = 2024
)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$12,751,022.59**

### `[YoY Revenue Growth $]`
```dax
YoY Revenue Growth $ = 
[2024 Revenue] - [2023 Revenue]
```
- **Format:** Currency (`+$#,##0.00;-$#,##0.00;$0.00`)
- **Validated Benchmark:** **+$15,916.32**

### `[YoY Revenue Growth %]`
```dax
YoY Revenue Growth % = 
DIVIDE([YoY Revenue Growth $], [2023 Revenue], 0)
```
- **Format:** Percentage (`+0.00%;-0.00%;0.00%`)
- **Validated Benchmark:** **+0.12%**

### `[2023 Profit]`
```dax
2023 Profit = 
CALCULATE(
    [Total Profit],
    calendar[year] = 2023
)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$5,093,596.88**

### `[2024 Profit]`
```dax
2024 Profit = 
CALCULATE(
    [Total Profit],
    calendar[year] = 2024
)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$5,100,967.75**

---

## 4. Entity Productivity Measures

### `[Revenue per Store]`
```dax
Revenue per Store = 
DIVIDE([Total Revenue], DISTINCTCOUNT(stores[store_id]), 0)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$254,861.29** across 100 stores

### `[Profit per Store]`
```dax
Profit per Store = 
DIVIDE([Total Profit], DISTINCTCOUNT(stores[store_id]), 0)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$101,945.65** across 100 stores

### `[Revenue per Customer]`
```dax
Revenue per Customer = 
DIVIDE([Total Revenue], DISTINCTCOUNT(customers[customer_id]), 0)
```
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$509.72** across 50,000 customers

### `[Orders per Customer]`
```dax
Orders per Customer = 
DIVIDE([Total Orders], DISTINCTCOUNT(customers[customer_id]), 0)
```
- **Format:** Decimal Number (`#,##0.00`)
- **Validated Benchmark:** **20.00 orders**

---

## 5. Daily Seasonality Measures

### `[Average Daily Revenue]`
```dax
Average Daily Revenue = 
DIVIDE([Total Revenue], DISTINCTCOUNT(sales[order_date]), 0)
```
- **Description:** Average gross revenue per calendar operating day (731 days).
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$34,864.75**

### `[Average Daily Orders]`
```dax
Average Daily Orders = 
DIVIDE([Total Orders], DISTINCTCOUNT(sales[order_date]), 0)
```
- **Description:** Average transaction count per calendar operating day.
- **Format:** Decimal Number (`#,##0.0`)
- **Validated Benchmark:** **1,368.0 orders/day**

---

## 6. Data Quality & Exception Handling Measures

### `[Orphan Product Revenue]`
```dax
Orphan Product Revenue = 
CALCULATE(
    [Total Revenue],
    sales[product_id] IN { "P0000", "P0201" }
)
```
- **Description:** Gross revenue generated by transaction records referencing non-catalog product keys.
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$247,480.64** (0.97% of total revenue; 9,764 orders)

### `[Catalog Product Revenue]`
```dax
Catalog Product Revenue = 
CALCULATE(
    [Total Revenue],
    NOT(sales[product_id] IN { "P0000", "P0201" })
)
```
- **Description:** Gross revenue generated by verified catalog items (`P0001` through `P0200`).
- **Format:** Currency (`$#,##0.00`)
- **Validated Benchmark:** **$25,238,648.22** (99.03% of total revenue)
