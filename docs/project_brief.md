# Project Brief — Retail Store Analytics

## Status
Analysis complete. All deliverables produced across SQL, Python, and Power BI.

## Objective
Build one end-to-end retail analytics case study that demonstrates a complete data analytics lifecycle: business framing, empirical data quality auditing, exploratory analysis, SQL modeling, dimensional schema design, Power BI dashboarding, and executive communication.

## Business Context
The project analyzes the **Chocolate Sales Dataset 2023–2024** sourced from [Kaggle](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024). It comprises 1,000,000 retail sales records across 200 chocolate catalog SKUs, 50,000 registered customers, 100 global retail stores, and a 731-day calendar spanning January 1, 2023 to December 31, 2024.

The dataset follows a dimensional star schema: a central `sales` fact table linked to four dimension tables (`products`, `customers`, `stores`, `calendar`). Available metrics include revenue, cost, profit, order quantity, unit price, and discount percentage at the individual order line grain.

> **Data Integrity Notice:** Empirical auditing confirms the dataset was synthetically generated. Distributions across brands, categories, demographic cohorts, and temporal periods exhibit near-uniform randomness. This case study demonstrates how a professional Data Analyst rigorously discovers, validates, and reports both business findings and data quality limitations.

## Intended Stakeholders
Retail leadership, merchandising category managers, store operations directors, and data analytics hiring teams seeking demonstrable proof of data wrangling, SQL modeling, and dashboard development competence.

## Analytical Stack & Responsibilities

| Technology | Role in Project |
|---|---|
| **MySQL** | Database DDL creation, staging strategy, data quality auditing, referential integrity testing, and analytical querying using JOINs, CTEs, and window functions (`RANK`, `ROW_NUMBER`, `LAG`). |
| **Python / Pandas / Seaborn** | Exploratory Data Analysis (EDA), distribution profiling, mathematical formula validation, and statistical visualization. |
| **Power Query** | ETL pipeline, type enforcement, portable data-source loading, and dimensional modeling. |
| **Power BI** | Star schema relationship architecture, 23 reusable DAX measures, and an interactive multi-page dashboard. |
| **Git / GitHub** | Professional repository organization, documentation, version control, and reproducible project artifacts. |

## Completed Project Deliverables

- [x] Comprehensive Dataset Audit documenting column inventories and empirical data anomalies ([dataset_audit.md](dataset_audit.md))
- [x] Star Schema Design Architecture with verified keys and cardinalities ([schema_design.md](schema_design.md))
- [x] Structured Business Question Bank with 20 core retail questions ([question_bank.md](question_bank.md))
- [x] 6 Modular SQL Scripts: database setup, auditing, product/brand, customer, store, and sales trends (`sql/`)
- [x] Fully Executed Python EDA Notebook (`python/notebooks/01_sales_eda.ipynb`)
- [x] Validated Business Findings and Strategic Recommendations ([insights.md](insights.md))
- [x] Power BI Multi-Page Analytical Dashboard (`powerbi/`)
- [x] Recruiter-friendly, professional project documentation ([README.md](../README.md))

## Core Analytical Principles
1. **Source Preservation:** Never mutate raw source files; perform all transformations reproducibly in code.
2. **Quality-First Auditing:** Uncover and document data discrepancies before drawing analytical conclusions.
3. **Cross-Tool Metric Reconciliation:** Ensure measures match exactly across SQL, Python, and Power BI ($25,486,128.86 gross revenue, $10,194,564.63 operating profit).
4. **Honest Reporting:** Clearly separate genuine business signals from synthetic pseudo-random data artifacts.
5. **Separation of Correlation from Causation:** Avoid asserting speculative causal mechanisms where the data only supports descriptive observations.
