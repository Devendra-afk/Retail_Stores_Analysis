# Project Brief — Retail Store Analytics

## Status
Day 1 — initial framing. This brief is provisional until the raw CSV files have been inspected.

## Objective
Build one end-to-end retail analytics case study that demonstrates a complete workflow: data understanding, quality checks, business analysis, transformation, modelling, visualization, and communication.

## Business Context
The exact business context, dataset source, and available entities will be recorded after inspecting the downloaded files. Do not assume the dataset contains profit, discounts, returns, inventory, or customer demographics until the relevant fields are confirmed.

## Intended Stakeholders
Provisional: a retail manager or business owner who needs to understand sales performance and identify opportunities for improvement. Revise this once the dataset's scope is known.

## Planned Tools and Responsibilities
- **SQL:** aggregate data and answer defined business questions.
- **Python/Pandas:** profile data, explore distributions, and independently validate selected results.
- **Power Query:** clean and shape the tables used for reporting.
- **Power BI:** define relationships, create DAX measures, and build a decision-focused dashboard.
- **GitHub:** version code, documentation, and publishable findings.
- **LinkedIn:** share selected project progress and validated insights.

## Working Principles
1. Inspect the source before choosing final questions.
2. Record data quality issues before transforming data.
3. Preserve raw files locally and never overwrite source data.
4. Document cleaning decisions and their rationale.
5. Validate important metrics across tools where practical.
6. Distinguish observed facts from hypotheses and recommendations.
7. Do not publish personal or sensitive data or redistribute data without checking its license.

## Day 1 Acceptance Criteria
- [ ] Inventory every CSV file.
- [ ] Record row and column counts and inspect column names.
- [ ] Identify candidate keys, date fields, measures, and category fields.
- [ ] Note possible relationships between tables.
- [ ] Record initial quality concerns without modifying raw files.
- [ ] Refine the business problem and shortlist 5–8 feasible questions.

## Open Questions
- What is the dataset's name and source?
- What does one row represent in each CSV?
- Which fields uniquely identify rows or entities?
- Which business measures are actually available?
- What date range and geographic/product/customer coverage are present?
