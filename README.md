# 🍫 Retail Stores Sales Analytics (2023–2024)

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg?logo=python&logoColor=white)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Power BI](https://img.shields.io/badge/Power_BI-Desktop-yellow.svg?logo=powerbi&logoColor=white)](https://powerbi.microsoft.com/)
[![Pandas](https://img.shields.io/badge/Pandas-2.2-150458.svg?logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Status](https://img.shields.io/badge/Status-Complete_%26_Validated-success.svg)]()
[![Portfolio](https://img.shields.io/badge/Data_Analyst-Portfolio_Project-purple.svg)]()

An end-to-end commercial retail sales analytics portfolio project demonstrating database modeling, empirical data quality auditing, exploratory data analysis (EDA), complex SQL querying, DAX modeling, and executive dashboard development across **1,000,000 transactions**.

---

## 📌 Executive Summary & Key Results

Over the 2023–2024 operating period (731 calendar days), the retail chocolate business generated **$24,498,421.43 in gross revenue** and **$9,692,201.21 in operating profit** across 100 stores and 200 catalog SKUs, achieving an overall operating margin of **39.56%**.

| Portfolio Metric | Validated Value | Benchmark Notes |
|---|---|---|
| **Total Gross Revenue** | **$24,498,421.43** | Cross-validated across MySQL, Pandas, and Power BI |
| **Total Operating Profit** | **$9,692,201.21** | Total COGS: $14,806,220.22 |
| **Overall Profit Margin** | **39.56%** | Consistent ~39.5% across all 6 brands |
| **Total Orders** | **1,000,000** | Distinct transactional order line items |
| **Total Volume Sold** | **2,999,021 units** | Average basket size of 3.00 units/order |
| **Average Order Value (AOV)**| **$24.50** | Stable basket size across customer segments |
| **Active Customer Base** | **50,000 customers** | Average 20 transactions & $490 spend per customer |
| **Retail Store Network** | **100 facilities** | 4 channel formats across 7 metropolitan markets |

---

## 📊 Power BI Executive Dashboard

The interactive Power BI report is structured into 4 decision-focused pages, modeling business performance from high-level C-suite KPIs down to SKU-level velocity and customer segmentation.

### Page 1: Executive Overview
*High-level portfolio financial KPIs, monthly pacing (2023 vs 2024), category revenue split, brand sales, and channel breakdown.*
![Executive Overview](screenshots/01_executive_overview.png)

---

### Page 2: Product & Brand Performance
*Top 10 revenue-generating SKUs, brand margin efficiency matrix, cocoa percentage tier analysis, and package weight distribution.*
![Product Performance](screenshots/02_product_performance.png)

---

### Page 3: Customer Demographics & Store Operations
*Customer age bracket spend, gender distribution, loyalty membership impact comparison, and average store productivity.*
![Customer and Store Analysis](screenshots/03_customer_store_analysis.png)

---

### Page 4: Sales Trends & Seasonality
*Day-of-week revenue variance, holiday uplift analysis (Christmas and Thanksgiving), and year-over-year monthly growth trajectories.*
![Sales Trends and Seasonality](screenshots/04_sales_trends.png)

---

## 🛠️ Technology Stack

| Layer | Technology | Primary Functionality |
|---|---|---|
| **Database Engine** | **MySQL 8.0** | DDL schema design, constraints, indexing, and business querying with CTEs and window functions (`RANK`, `ROW_NUMBER`, `LAG`). |
| **Exploratory Analytics** | **Python 3.11 / Pandas / NumPy** | Data ingestion, mathematical formula validation, statistical distributions, and hypothesis testing. |
| **Data Visualization** | **Matplotlib / Seaborn** | Publication-grade statistical plots, formatting engines, and chart interpretations. |
| **Business Intelligence** | **Microsoft Power BI Desktop** | Star schema relationship architecture, VertiPaq tabular modeling, reusable DAX measure repository. |
| **ETL & Data Prep** | **Power Query (M)** | Type safety enforcement, conditional column logic, and orphan key mitigation. |
| **Version Control** | **Git / GitHub** | Reproducible project structure, documentation, and version control. |

---

## 📁 Repository Architecture

```text
Retail_Stores_Analysis/
├── .gitignore                          # Excludes raw data while tracking deliverables
├── README.md                           # Master executive summary and project documentation
├── requirements.txt                    # Locked Python dependency specifications
│
├── data/
│   └── raw/
│       └── README.md                   # Instructions and Kaggle link for raw dataset
│
├── docs/
│   ├── project_brief.md                # Project charter, scope, and objectives
│   ├── dataset_audit.md                # Complete empirical data quality audit & anomaly log
│   ├── schema_design.md                # Star schema architecture, ERD, and data dictionary
│   ├── question_bank.md                # 20 business-critical analytical questions
│   ├── insights.md                     # Detailed analytical findings and strategic takeaways
│   └── Schema_Design.png               # High-resolution entity relationship diagram
│
├── powerbi/
│   ├── DAX_Measures.md                 # Full DAX code repository with validated benchmarks
│   ├── Retail_Stores_Sales_Analysis.pbip  # Power BI Project definition file
│   ├── Retail_Stores_Sales_Analysis.pbit  # Portable Power BI Template file
│   ├── Retail_Stores_Sales_Analysis.pbix  # Standalone Power BI Report
│   ├── Retail_Stores_Sales_Analysis.Report/   # PBIP report layout and visual containers
│   └── Retail_Stores_Sales_Analysis.Dataset/  # PBIP Tabular Model definitions (model.bim)
│
├── python/
│   └── notebooks/
│       └── 01_sales_eda.ipynb          # Clean, fully executed end-to-end Python EDA notebook
│
├── screenshots/                        # High-resolution dashboard page screenshots
│   ├── 01_executive_overview.png
│   ├── 02_product_performance.png
│   ├── 03_customer_store_analysis.png
│   └── 04_sales_trends.png
│
└── sql/                                # Modular, production-ready SQL scripts
    ├── 00_database_setup.sql           # Database creation, table DDL, and PK/FK definitions
    ├── 01_data_audit.sql               # Data quality, nulls, duplicates, and orphan checks
    ├── 02_product_brand_analysis.sql   # SKU rankings, brand performance, and category CTEs
    ├── 03_customer_analysis.sql        # Age cohort segmentation, gender, and loyalty queries
    ├── 04_store_performance.sql        # Channel format analysis, store productivity, and cities
    └── 05_sales_trends.sql             # Monthly trends, YoY growth rates, and holiday windows
```

---

## 🔍 Data Quality Auditing & Limitations

A senior-level data analysis project does not overlook data anomalies. Our empirical audit uncovered several critical source-level characteristics:

1. **Orphan Product Identifiers (`P0000` & `P0201`):**
   - Exactly **9,764 transaction records** (0.98% of total volume) reference product IDs `P0000` (4,932 records) and `P0201` (4,832 records) which do not exist in the 200-row `products` catalog.
   - *Handling:* Rather than deleting valid sales representing **$238,623.66 in gross revenue**, these records are handled via `COALESCE` / `IF(ISBLANK())` in SQL and Power BI as `Unassigned SKUs`.
2. **Floating-Point Rounding Variances ($\pm \$0.01$):**
   - 2,646 records differ from `quantity * unit_price * (1 - discount)` by $\pm \$0.01$.
   - 27,915 records differ from `revenue - cost` by $\pm \$0.01$.
   - *Handling:* Sourced from floating-point rounding during synthetic generation; recorded transaction values are preserved as the ground-truth financial ledger.
3. **Geographic Incoherence (80% Discordance):**
   - 80 out of 100 stores pair cities and countries randomly (e.g., Paris assigned to UK, Berlin to France, Melbourne to Canada).
   - *Handling:* Documented as a synthetic artifact; city and store-type metrics are evaluated independently rather than as a strict geographic hierarchy.
4. **Synthetic Uniformity:**
   - Day-of-week sales vary by less than **0.6%** ($34,788 to $34,982 per day).
   - Holiday windows (Christmas, Thanksgiving) display no statistically significant sales surge.
   - All 6 brands capture nearly identical revenue (~$4.0M to $4.1M each).
   - *Handling:* Findings are explicitly classified as descriptive characteristics of the dataset, avoiding unsupported causal claims.

*Detailed documentation: [`docs/dataset_audit.md`](docs/dataset_audit.md)*

---

## 💡 Key Business Findings & Strategic Recommendations

1. **Assortment Uniformity:** Godiva ($4.13M), Ferrero ($4.10M), Cadbury ($4.10M), and Lindt ($4.10M) perform with near-identical velocity. Top SKUs (P0091 Dark Chocolate 60% and P0107 Truffle 80%) cluster around $131K each.
2. **Channel Productivity:** While High-Street **Retail** represents 40% of locations, **Airport**, **Mall**, and **Online** channels produce identical store-level productivity (~$245K per store over 2 years).
3. **Loyalty Program Inefficiency:** Loyalty members and non-members average identical basket sizes ($24.50 vs $24.49) and annual spend ($490.15 vs $489.79), proving the loyalty scheme currently provides zero basket expansion.
4. **Actionable Recommendations:**
   - *POS Catalog Clean-Up:* Reconcile orphan SKUs `P0000` and `P0201` to prevent accounting leakage.
   - *Loyalty Restructuring:* Introduce minimum spend hurdles and tier-exclusive seasonal bundles to convert passive members into higher-frequency buyers.
   - *Channel Optimization:* Prioritize digital and airport channel expansion, which yield identical margins (39.6%) with lower physical overhead.

*Detailed report: [`docs/insights.md`](docs/insights.md)*

---

## 🚀 How to Reproduce & Run the Project

### 1. Clone the Repository
```bash
git clone https://github.com/Devendra-afk/Retail_Stores_Analysis.git
cd Retail_Stores_Analysis
```

### 2. Obtain Raw Data
Download the 5 CSV files from [Kaggle Chocolate Sales Dataset 2023–2024](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024) and place them into `data/raw/`:
- `sales.csv` (1,000,000 rows)
- `products.csv` (200 rows)
- `customers.csv` (50,000 rows)
- `stores.csv` (100 rows)
- `calendar.csv` (731 rows)

### 3. Run SQL Analysis (MySQL)
Execute the organized scripts in sequential order:
```sql
SOURCE sql/00_database_setup.sql;
SOURCE sql/01_data_audit.sql;
SOURCE sql/02_product_brand_analysis.sql;
SOURCE sql/03_customer_analysis.sql;
SOURCE sql/04_store_performance.sql;
SOURCE sql/05_sales_trends.sql;
```

### 4. Execute Python EDA Notebook
Install dependencies and run the Jupyter notebook:
```bash
pip install -r requirements.txt
jupyter notebook python/notebooks/01_sales_eda.ipynb
```

### 5. Open Power BI Dashboard
Open `powerbi/Retail_Stores_Sales_Analysis.pbix` (or `Retail_Stores_Sales_Analysis.pbip`) in Microsoft Power BI Desktop to explore the interactive visual model and DAX measures.

---

## 👨‍💻 Author & Contact

**Devendra**  
*Aspiring Data Analyst | SQL, Python, Power BI, Excel*  
- **GitHub:** [@Devendra-afk](https://github.com/Devendra-afk)  
- **Project Repository:** [Retail_Stores_Analysis](https://github.com/Devendra-afk/Retail_Stores_Analysis)

*Open to Data Analyst Internship and Junior Analytics opportunities.*
