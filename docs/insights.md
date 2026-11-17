# Key Findings & Strategic Insights — Retail Store Analytics

> **Dataset:** Chocolate Sales Dataset 2023–2024 (Kaggle)  
> **Period:** January 1, 2023 – December 31, 2024 (731 days, leap year)  
> **Volume:** 1,000,000 sales transactions across 100 stores and 200 catalog SKUs

---

## 1. Executive Summary

| Portfolio Metric | Exact Value | Key Observation |
|---|---|---|
| **Total Gross Revenue** | **$25,486,128.86** | Stable revenue pace across 24 calendar months (~$1.06M/month) |
| **Total Operating Profit** | **$10,194,564.63** | Consistent portfolio operating margin of **40.00%** |
| **Total COGS** | **$15,291,554.40** | Direct product procurement and manufacturing costs |
| **Total Units Sold** | **2,999,589 units** | Average basket quantity of 3.00 units per transaction |
| **Total Transactions** | **1,000,000** | Distinct transactional order line items |
| **Average Order Value (AOV)** | **$25.49** | Stable transaction basket size across customer segments |
| **Average Selling Price (ASP)** | **$8.50** | Realized net revenue per chocolate unit |
| **Active Customer Base** | **50,000 customers** | Average 20 transactions & $509.72 spend per customer over 2 years |
| **Store Footprint** | **100 facilities** | 4 channel types across 7 global metropolitan markets |
| **Catalog Breadth** | **200 SKUs** | Plus 2 orphan SKUs (`P0000`, `P0201`) accounting for 9,764 transactions |

Over the 2023–2024 reporting window, the retail chocolate business generated **$25.49 million in gross revenue** and **$10.19 million in operating profit**. Operational metrics show balanced performance across brands, categories, demographic cohorts, and time periods — an empirical pattern characteristic of synthetically generated retail transaction datasets.

---

## 2. Product & Brand Performance Insights

### Brand Performance
All **6 confectionery brands** contribute substantially to portfolio revenue, generating between **$3.5M and $4.7M** each with uniform ~40.0% operating margins:

| Brand | SKUs | Total Quantity | Total Revenue ($) | Total Profit ($) | Profit Margin | Avg Rev / SKU |
|---|---|---|---|---|---|---|
| **Ferrero** | 37 | 552,056 | $4,689,031.21 | $1,876,268.09 | 40.01% | $126,730.57 |
| **Cadbury** | 37 | 548,993 | $4,666,426.41 | $1,865,555.75 | 39.98% | $126,119.63 |
| **Lindt** | 35 | 519,702 | $4,422,825.33 | $1,770,184.54 | 40.02% | $126,366.44 |
| **Mars** | 33 | 489,216 | $4,151,625.34 | $1,660,828.80 | 40.00% | $125,806.83 |
| **Godiva** | 30 | 446,436 | $3,789,363.14 | $1,514,949.08 | 39.98% | $126,312.10 |
| **Hershey** | 28 | 414,067 | $3,519,376.79 | $1,407,855.65 | 40.00% | $125,692.03 |
| *Orphan Keys (P0000/P0201)* | *2* | *29,119* | *$247,480.64* | *$98,922.72* | *39.97%* | *$123,740.32* |

### Category Performance
Revenue distributes across the **5 catalog categories** in proportion to SKU counts:

| Category | SKUs | Total Quantity | Total Revenue ($) | Total Profit ($) | Profit Margin | Share of Revenue |
|---|---|---|---|---|---|---|
| **Praline** | 53 | 784,435 | $6,665,641.32 | $2,665,242.79 | 39.98% | 26.15% |
| **White** | 48 | 714,967 | $6,070,172.20 | $2,428,117.37 | 40.00% | 23.82% |
| **Dark** | 42 | 623,247 | $5,298,123.27 | $2,120,672.08 | 40.03% | 20.79% |
| **Truffle** | 31 | 462,202 | $3,924,343.24 | $1,569,202.54 | 39.99% | 15.40% |
| **Milk** | 26 | 385,619 | $3,280,368.19 | $1,312,407.13 | 40.01% | 12.87% |
| *Unassigned (Orphans)* | *2* | *29,119* | *$247,480.64* | *$98,922.72* | *39.97%* | *0.97%* |

### Product Attributes: Weight & Cocoa %
- **Package Weight Tiers:** 50g ($6.06M; 48 SKUs) and 100g ($5.95M; 47 SKUs) lead total sales due to SKU count, but **Average Revenue per SKU** is uniform across all five sizes (~$125.5K to $126.5K per product across 50g, 80g, 100g, 120g, and 200g).
- **Cocoa Content Tiers:** Demand across 50%, 60%, 70%, 80%, and 90% cocoa formulations shows similar velocity, with average revenue per SKU clustering around ~$126K/SKU.

---

## 3. Customer Demographics & Behavior

| Customer Segment | Size | Total Revenue ($) | Avg Order Value (AOV) | 2-Year Spend / Cust | Observation |
|---|---|---|---|---|---|
| **Age: 18–25** | 7,635 (15.3%) | $3,884,281.33 | $25.48 | $508.75 | Baseline cohort |
| **Age: 26–35** | 9,275 (18.6%) | $4,733,427.26 | $25.49 | $510.34 | Uniform basket value |
| **Age: 36–45** | 9,452 (18.9%) | $4,805,665.41 | $25.51 | $508.43 | Consistent order frequency |
| **Age: 46–55** | 9,378 (18.8%) | $4,776,724.81 | $25.47 | $509.35 | Consistent basket size |
| **Age: 56–70** | 14,260 (28.5%) | $7,286,029.05 | $25.48 | $510.94 | Largest cohort by headcount |
| **Gender: Female** | 24,758 (49.5%) | $12,630,103.60 | $25.48 | $510.14 | Balanced customer split |
| **Gender: Male** | 25,242 (50.5%) | $12,856,025.26 | $25.49 | $509.31 | Identical purchasing metrics |
| **Loyalty: Member** | 25,104 (50.2%) | $12,773,029.06 | $25.45 | $508.80 | Near-identical basket size |
| **Loyalty: Non-Member** | 24,896 (49.8%) | $12,713,099.80 | $25.52 | $510.65 | Baseline spending parity |

**Analytical Context:** In this dataset, recorded loyalty members and non-members exhibit virtually identical average order values ($25.45 vs $25.52) and 2-year spend per customer ($508.80 vs $510.65). While real-world retail programs typically aim to drive frequency and basket expansion, in this synthetic data environment membership does not correlate with spending divergence.

---

## 4. Store Formats & Channel Operations

The portfolio operates 100 store facilities across 4 distinct retail models:

| Channel Model | Store Count | Total Orders | Total Revenue ($) | Total Profit ($) | Revenue / Store | Profit Margin |
|---|---|---|---|---|---|---|
| **Airport Kiosks** | 30 | 299,119 | $7,613,875.92 | $3,046,173.74 | $253,795.86 | 40.01% |
| **Mall Stores** | 26 | 260,061 | $6,628,228.67 | $2,650,844.14 | $254,931.87 | 39.99% |
| **Online Storefront** | 25 | 250,332 | $6,386,035.76 | $2,554,237.38 | $255,441.43 | 40.00% |
| **Street Retail** | 19 | 190,488 | $4,857,988.51 | $1,943,309.37 | $255,683.61 | 40.00% |

**Key Takeaway:** Individual store productivity is consistent across all four operating models (~$254,000 to $256,000 revenue per store over the 2-year period), demonstrating uniform sales distribution by store count.

---

## 5. Temporal Trends & Seasonality

### Intra-Week Seasonality
- **Tuesday** recorded the highest average daily revenue: **$34,982.97** (1,371.1 orders/day).
- **Saturday** recorded the second highest: **$34,944.97** (1,372.5 orders/day).
- **Thursday** recorded the lowest: **$34,788.94** (1,366.2 orders/day).
- **Variance:** Intra-week daily revenue varies by less than **0.6% ($194.03/day)** between the highest and lowest weekdays.

### Holiday Windows vs. Regular Operating Days
- **Regular Operating Days (703 days):** Average daily revenue of **$34,904.38** (Mean orders: 1,368.6/day).
- **Christmas Window (Dec 20–26; 14 days):** Average daily revenue of **$34,440.69** (Mean orders: 1,353.8/day; -1.3% variance).
- **Thanksgiving Window (Nov 20–26, 2023 & Nov 25–Dec 1, 2024; 14 days):** Average daily revenue of **$33,298.61** (Mean orders: 1,354.0/day; -4.6% variance).
- **Finding:** Neither holiday window exhibits the seasonal uplift typical in commercial confectionery retail, confirming synthetic date randomization.

---

## 6. Strategic Recommendations for Retail Management

1. **POS Catalog Integrity:**
   - Formalize catalog mappings for orphan product keys `P0000` and `P0201` in the master POS database to eliminate untracked sales ($247K revenue; 9,764 transactions).

2. **Loyalty Program Enhancement:**
   - Because current membership does not correlate with spending lift, restructure the program with spend-threshold reward hurdles and tiered benefits to encourage incremental basket size.

3. **Digital & Travel Hub Expansion:**
   - Online and Airport formats demonstrate equal margin efficiency (40.0%) with potentially lower brick-and-mortar overhead than street retail, making them viable candidates for capital investment.

4. **Data Infrastructure Standardization:**
   - Correct the store facility master table to align city-country pairings (currently 80% discordant).
   - Standardize checkout calculation precision to eliminate floating-point rounding variances.
