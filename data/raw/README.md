# Raw Data Files

The raw CSV files are excluded from version control due to their size (the sales file alone contains 1,000,000 rows). To reproduce the analysis, download the dataset and place the files in this directory.

## Source

**Chocolate Sales Dataset 2023–2024**
[https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024)

## Required Files

| File | Description | Expected Rows |
|---|---|---|
| `sales.csv` | Sales transactions (fact table) — one row per order | 1,000,000 |
| `customers.csv` | Customer demographics — one row per customer | 50,000 |
| `products.csv` | Chocolate product attributes — one row per product | 200 |
| `stores.csv` | Store locations and types — one row per store | 100 |
| `calendar.csv` | Date dimension — one row per day (2023–2024) | 731 |

## Notes

- Do not modify the raw files. All cleaning and transformation should be done downstream in SQL, Python, or Power Query.
- After downloading, verify the row counts match the table above.
- See [`docs/dataset_audit.md`](../../docs/dataset_audit.md) for detailed column inventories and data quality findings.
