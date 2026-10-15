# Business Questions- Retail Store Analysis

## 1. Objective

The objective of this project is to analyze retail chocolate sales to understand product demand, brand performance, customer purchasing patterns, pricing, profitability, and seasonal trends.

The analysis will use the available sales, products, customers, stores, and calendar datasets to derive actionable business insights and support data-driven decision-making.

## 2. Product and Brand Performance

### Q1. Which chocolate brands sell the highest quantities?

- **Business purpose:** Identify the most popular brands based on the quantity sold.
- **Key metrics:** Total quantity sold by brand.
- **Expected analysis:** Rank brands from highest to lowest quantity sold.

### Q2. Which chocolate categories are most in demand?

- **Business purpose:** Understand customer demand across chocolate categories.
- **Key metrics:** Total quantity sold and revenue by category.
- **Expected analysis:** Compare categories by quantity and revenue to identify popular product segments.

### Q3. Which brands generate the highest revenue?

- **Business purpose:** Identify the brands contributing most to overall sales revenue.
- **Key metrics:** Total revenue by brand and percentage contribution to total revenue.
- **Expected analysis:** Rank brands by revenue and compare their contribution to overall sales.

### Q4. Which brands generate the highest profit?

- **Business purpose:** Understand which brands contribute most to business profitability.
- **Key metrics:** Total profit and profit margin by brand, if the required data is available.
- **Expected analysis:** Compare revenue and profitability to distinguish high-selling brands from high-profit brands.

### Q5. How does pricing vary across chocolate brands?

- **Business purpose:** Compare the pricing of different brands and identify pricing patterns.
- **Key metrics:** Average, minimum, and maximum selling price by brand.
- **Expected analysis:** Evaluate differences in brand pricing and their relationship with sales performance.

## 3. Product Attributes and Customer Preferences

### Q6. Is cocoa percentage associated with chocolate sales performance?

- **Business purpose:** Explore whether chocolates with different cocoa percentages show different sales patterns.
- **Key metrics:** Cocoa percentage, quantity sold, and revenue.
- **Expected analysis:** Compare sales performance across cocoa percentages or cocoa-percentage ranges.

### Q7. Is chocolate weight associated with quantity sold, and how does brand preference compare?

- **Business purpose:** Understand whether product weight and brand are associated with purchasing patterns.
- **Key metrics:** Product weight, brand, selling price, and quantity sold.
- **Expected analysis:** Compare sales across weight ranges and brands while considering differences in pricing.

### Q8. What is the average cocoa percentage across chocolate categories?

- **Business purpose:** Understand how cocoa content differs between product categories.
- **Key metrics:** Average cocoa percentage by category.
- **Expected analysis:** Compare average cocoa content across categories and identify differences in product composition.

### Q9. How do purchasing patterns vary across customer age groups?

- **Business purpose:** Explore whether different age groups purchase different chocolate categories or brands.
- **Key metrics:** Customer age or age group, category, brand, and quantity sold.
- **Expected analysis:** Compare purchasing patterns across age groups, provided customer information can be reliably linked to sales.

### Q10. How do chocolate brand and category preferences vary by gender?

- **Business purpose:** Explore differences in purchasing patterns across recorded gender groups.
- **Key metrics:** Gender, brand, category, and quantity sold.
- **Expected analysis:** Compare product preferences across gender groups without assuming that observed differences represent causal or universal preferences.

## 4. Time and Seasonal Trends

### Q11. During which months or periods are chocolate sales highest?

- **Business purpose:** Identify peak sales periods and support inventory and promotional planning.
- **Key metrics:** Revenue and quantity sold by month, quarter, or season.
- **Expected analysis:** Identify high-performing and low-performing periods across the available date range.

### Q12. Are chocolate sales higher during Christmas and Thanksgiving periods?

- **Business purpose:** Investigate whether sales increase around major holidays covered by the dataset.
- **Key metrics:** Revenue and quantity sold during defined holiday periods compared with suitable non-holiday periods.
- **Expected analysis:** Compare holiday-period performance with comparable baseline periods, accounting for the available years and dates.

### Q13. Which days of the week have the highest chocolate sales?

- **Business purpose:** Understand weekly sales patterns to support staffing, promotions, and inventory planning.
- **Key metrics:** Average daily revenue and quantity sold by day of the week.
- **Expected analysis:** Compare weekdays and weekends using consistent daily measures.

## 5. Store and Geographic Performance

### Q14. Which stores are the most profitable?

- **Business purpose:** Identify stores that contribute most to overall profitability.
- **Key metrics:** Revenue, total profit, and profit margin by store, where available.
- **Expected analysis:** Rank stores by profitability and compare their sales performance.

### Q15. Which cities have the highest chocolate sales?

- **Business purpose:** Understand geographic differences in chocolate demand.
- **Key metrics:** Quantity sold and revenue by city.
- **Expected analysis:** Rank cities by sales volume and revenue. Interpret these as recorded sales rather than total population consumption.

### Q16. Which chocolate brands sell best in each city?

- **Business purpose:** Identify geographic differences in brand performance.
- **Key metrics:** Quantity sold and revenue by city and brand.
- **Expected analysis:** Compare leading brands across cities and identify locally strong brands.

### Q17. How do revenue and profitability vary across cities?

- **Business purpose:** Compare geographic performance beyond sales volume alone.
- **Key metrics:** Revenue, profit, and profit margin by city, if available.
- **Expected analysis:** Identify cities with strong sales and profitability and distinguish high-revenue locations from high-margin locations.

### Q18. How does sales performance vary by store type?

- **Business purpose:** Understand which store types contribute most to chocolate sales.
- **Key metrics:** Revenue and quantity sold by store type.
- **Expected analysis:** Compare sales performance across store types using consistent measures.

## 6. Store Type and Customer/Brand Patterns

### Q19. Does the customer mix by gender vary across store types?

- **Business purpose:** Explore differences in the recorded customer mix across store types.
- **Key metrics:** Customer counts or transaction counts by gender and store type, depending on the available data.
- **Expected analysis:** Compare customer or transaction distributions across store types, ensuring that customers are not double-counted unintentionally.

### Q20. Which chocolate brands perform best across different store types?

- **Business purpose:** Understand whether brand performance differs across retail formats.
- **Key metrics:** Quantity sold and revenue by brand and store type.
- **Expected analysis:** Identify leading brands within each store type and compare their relative performance.

## 7. Data and Metric Validation

Before answering these questions, the project will verify:

- Which required columns and relationships exist in the source datasets.
- The grain of the sales table and the correct method for joining the tables.
- How revenue, quantity sold, and profit are represented or calculated.
- Whether the dataset includes cost or profit data needed for profitability analysis.
- Whether customer demographics can be linked reliably to individual sales records.
- Whether the date range supports meaningful holiday and seasonal comparisons.
- Whether missing values, duplicates, or unmatched keys affect the results.

## 8. Expected Outcome

The analysis aims to identify the strongest-performing brands, categories, stores, and locations; explore product and customer purchasing patterns; and uncover temporal trends in chocolate sales.

The final findings will be used to develop evidence-based business recommendations and a Power BI dashboard. Conclusions will be based on the available data, with limitations documented where necessary.