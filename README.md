# 💸 Finance Data Insights Project

This project focuses on cleaning, analyzing, and visualizing banking and loan-related data using SQL and Python. It simulates a real-world finance dataset with customers, transactions, accounts, loans, and credit scores.

---

## 🧪 Data Generation & Import Notes

- Synthetic data was generated using **Python + Faker** across five entities: `customers`, `accounts`, `transactions`, `loan_applications`, and `credit_scores`.
- Data was deliberately made messy with:
  - Missing values
  - Inconsistent casing
  - Duplicates
  - Unstructured phone numbers
- ⚠️ **Issue Encountered:** During import into **MySQL**, some rows were not imported due to **empty string values in duplicate rows**.
  - ✅ **Fix:** We updated the Python script to **replace all `NaN` and empty strings with `NULL`** before exporting to CSV. This ensured full data integrity and correct row counts in MySQL.

---

## 🗃️ Dataset Overview
The dataset is composed of 5 relational tables:

| Table Name          | Description                                                        | Row Count |
| ------------------- | ------------------------------------------------------------------ | --------- |
| `customers`         | Customer demographics: name, contact, DOB, location, occupation    | 2,000     |
| `accounts`          | Bank accounts linked to customers with type and balance            | 2,000     |
| `transactions`      | Transaction records including type, amount, merchant, and category | 25,000    |
| `loan_applications` | Loan applications with amount, status, type, and timestamps        | 1,895     |
| `credit_scores`     | Customer credit scores with timestamp                              | 4,983     |

--

## 🧹 Data Cleaning (SQL)

Each table was cleaned with the following steps:
- Trimmed whitespace
- Filled null or missing values using `COALESCE` and `NULLIF`
- Capitalized name/location/occupation using a **custom `INITCAP()` function**
- Standardized US-style phone numbers using regex
- Removed empty merchant names, cleaned categories, and fixed numeric nulls

---

## 📊 Key Insights & Queries (SQL)

1. Calculate the average account balance by account type
2. Identify the top 5 customers with highest transaction totals
3. Find the account type with the highest transaction count
4. Calculate the approval rate per loan type
5. Classify transactions as Successful, Failed, or Pending using `CASE`
6. Determine approval rates by credit score buckets
7. Find customers whose latest transaction pushed spending above average
8. List top 5 merchants by total spending and transaction count
9. Find customers with multiple loan applications and approval rates
10. Average credit score for loans approved in last 6 months
11. Detect suspicious transaction activity (e.g., 3+ large transactions/day)
12. Show monthly loan application trends over time
13. Segment customers into spending tiers: Low, Medium, High, Very High

---

## 📈 Visualizations (Python)

Visuals were built using:
- **`pandas`** for querying and aggregation
- **`matplotlib`** and **`seaborn`** for bar charts and trends

Sample charts include:
- Avg balance by account type
- Loan status distribution
- Credit score vs. approval
- Spending segments

---

## 🔗 Entity Relationship Diagram

![Finance ERD](assets/finance_erd.png)

---

## 🧰 Tools & Tech Stack

- **SQL (MySQL)** – cleaning, transformations, advanced querying
- **Python** – data generation, visualizations, automation
- **Pandas**, **Seaborn**, **Matplotlib**
- **SQLAlchemy** for MySQL-Python integration
- **Jupyter Notebook**
- **DBDiagram.io** for ERD

---

## 📌 Objective

To simulate a real-world finance analytics workflow and showcase:
- Advanced SQL cleaning and analysis
- Python-powered visual storytelling
- Realistic business insights from raw financial data

---

## 🧠 Author

**Rehan Ahmed Rikati**  
Data Analyst | SQL Enthusiast | Python Explorer  

---

## 🗂️ License

MIT — Free to use with attribution.

