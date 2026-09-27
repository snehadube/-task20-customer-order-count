# Customer Order Count

**Track:** Data Analytics &bull; Veda Technology Internship
**Dataset:** Superstore (`superstore.csv` &ndash; 9,994 order-line rows)
**Tools:** Excel, SQL

## Task
Count orders per customer and identify frequent buyers.

## Why it isn't a simple COUNTIF on the raw data
Each row in the raw dataset is one **product line**, not one **order** &ndash; an
order with 3 products in it produces 3 rows with the *same* Order ID. Counting
raw rows per customer would over-count anyone who buys several items per order.
The fix: de-duplicate on **Order ID** first, then count.

## Approach
1. **De-duplicate** the raw data down to one row per Order ID (`Unique_Orders`
   sheet / `SELECT DISTINCT` in SQL).
2. **Group by Customer ID** and count the de-duplicated orders per customer.
3. **Flag frequent buyers** &ndash; threshold set at **&ge; 8 orders**
   (the 75th percentile of the distribution, i.e. the top ~30% most active
   customers).
4. **Rank** customers to find the Top 10 by order count.
5. **Cross-check**: sum of every customer's order count = total unique orders
   in the dataset (5,009 = 5,009 &check;).

## Files
| File | What it is |
|---|---|
| `Customer_Order_Count.xlsx` | Excel workbook &ndash; see sheet guide below |
| `customer_order_count.sql` | SQL queries that reproduce the same results |
| `Customer_Order_Count_Report.pdf` | Project report (objective, method, KPIs, charts) |
| `README.md` | This file |

### Excel workbook sheets
- **Sales_Data** &ndash; raw Superstore data, unmodified.
- **Unique_Orders** &ndash; one row per Order ID (de-duplicated order lines).
- **Summary** &ndash; every customer's order count (`COUNTIF`), frequent-buyer
  flag (`IF`), a hidden "Rank Key" helper column used for ranking, and a
  cross-check block confirming the totals reconcile.
- **Top_Customers** &ndash; Top 10 customers by order count, built with
  `LARGE` / `INDEX` / `MATCH` formulas (not hardcoded), plus a bar chart.

## Results
- **5,009** unique orders across **793** unique customers.
- Average **6.3** orders/customer, median **6**.
- **241 customers (30.4%)** qualify as frequent buyers (&ge; 8 orders).
- **Top customer:** Emily Phan &ndash; 17 orders.

## Interview questions (from the task brief)
**Q: Customer vs order count &ndash; what's the difference?**
Customer count = how many *distinct people* bought something. Order count =
how many *separate purchase transactions* happened. One customer can place
many orders, so order count is always &ge; customer count for that customer,
and total order count across all customers is independent of how many
distinct customers there are.

**Q: Why is Customer ID important?**
Customer Name isn't guaranteed unique (two different people could share a
name), and it can be entered inconsistently. Customer ID is the stable,
unique key that lets you correctly group every order back to the right
person, which is what makes the `GROUP BY` / `COUNTIF` grouping reliable.
