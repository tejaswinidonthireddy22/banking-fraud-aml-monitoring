# 🔐 LOL Bank Pvt. Ltd. — Fraud Detection System

> End-to-end fraud detection pipeline: data cleaning → SQL analysis → interactive dashboard

---

## 📋 Project Overview

This project builds a comprehensive fraud detection and analytics system for LOL Bank Pvt. Ltd. using **200,000 bank transactions**. It covers data ingestion, cleaning, SQL-based analysis, and a production-ready interactive HTML dashboard with live filters.

**Key Findings:**
- **5.04% overall fraud rate** across 200,000 transactions
- **₹49.71 Cr** in fraudulent transaction volume
- Lakshadweep (5.58%) and Tamil Nadu (5.62%) show highest fraud rates
- Midnight hours (0:00–4:00) show elevated fraud activity
- Clothing & Groceries merchant categories are highest-risk

- 💼 Business Impact
  
Prevented potential fraud loss: ₹49.71 Cr identified across 200K transactions
Faster regulatory compliance: SQL-based monitoring and interactive dashboards enable quick reporting
Improved risk decision-making: Transaction-level risk scoring highlights high-risk states, merchant categories, and hours
Actionable insights for management: Enables resource prioritization for high-risk segments
Supports customer trust & safety: Reduces fraudulent activities affectin
- 

---

## 🗂 Repository Structure

```
lol-bank-fraud-detection/
├── data/
│   └── Bank_Transaction_Fraud_Detection.csv    # Raw dataset (200K rows)
├── outputs/
│   ├── cleaned_transactions.csv                # Cleaned, PII-stripped dataset
│   ├── LOL_Bank_Fraud_Analysis.xlsx            # Excel workbook (5 sheets)
│   └── LOL_Bank_Fraud_Dashboard.html           # Interactive dashboard
├── pipeline.py                                 # Full ETL + analysis pipeline
├── analysis.sql                                # All SQL queries used
├── requirements.txt                            # Python dependencies
└── README.md
```
Tech Stack

Python: pandas, NumPy, openpyxl, matplotlib, seaborn
SQL:  MySQL  (for transaction analytics and reporting)
Power BI: Interactive dashboards and KPI visualizations
Excel: Advanced reporting & KPI dashboards
Version Control: Git & GitHub


---

## 🔧 Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        DATA PIPELINE                            │
│                                                                 │
│  [CSV Input]                                                    │
│      │                                                          │
│      ▼                                                          │
│  ┌──────────────────────────────────────────┐                   │
│  │  STEP 1: DATA CLEANING (pandas)          │                   │
│  │  • Parse Transaction_Date → datetime     │                   │
│  │  • Extract Hour from Transaction_Time    │                   │
│  │  • Create Age_Group, Amount_Bin buckets  │                   │
│  │  • Drop PII columns (Name, Email, Phone) │                   │
│  │  • Validate nulls, types, ranges         │                   │
│  └──────────────────┬───────────────────────┘                   │
│                     │                                           │
│                     ▼                                           │
│  ┌──────────────────────────────────────────┐                   │
│  │  STEP 2: SQL ANALYSIS (SQLite via pandas)│                   │
│  │  • Fraud by State (34 states)            │                   │
│  │  • Fraud by Transaction Type (5 types)   │                   │
│  │  • Fraud by Merchant Category (6 cats)   │                   │
│  │  • Fraud by Device & Hour                │                   │
│  │  • Fraud by Age Group & Account Type     │                   │
│  └──────────────────┬───────────────────────┘                   │
│                     │                                           │
│                     ▼                                           │
│  ┌──────────────────────────────────────────┐                   │
│  │  STEP 3: EXCEL EXPORT (openpyxl)         │                   │
│  │  • Sheet 1: Executive KPI Summary        │                   │
│  │  • Sheet 2: State Analysis + Charts      │                   │
│  │  • Sheet 3: Device & Category Analysis   │                   │
│  │  • Sheet 4: Hourly & Age Trends          │                   │
│  │  • Sheet 5: SQL Queries Reference        │                   │
│  └──────────────────┬───────────────────────┘                   │
│                     │                                           │
│                     ▼                                           │
│  ┌──────────────────────────────────────────┐                   │
│  │  STEP 4: INTERACTIVE DASHBOARD (PowerBI) │                   │
│  │  • Filter by State, Txn Type, Category   │                   │
│  │  • 8 dynamic Chart.js visualisations     │                   │
│  │  • KPI cards, state table w/ risk badges │                   │
│  │  • CSV export of filtered results        │                   │
│  └──────────────────────────────────────────┘                   │
└─────────────────────────────────────────────────────────────────┘
```


## 📊 Dataset Schema

| Column | Type | Description |
|--------|------|-------------|
| `Customer_ID` | string | Unique customer identifier |
| `Age` | int | Customer age |
| `State` | string | Customer's state (34 Indian states/UTs) |
| `Account_Type` | string | Savings / Business / Checking |
| `Transaction_ID` | string | Unique transaction ID |
| `Transaction_Date` | date | Date of transaction |
| `Transaction_Time` | time | Time of transaction (HH:MM:SS) |
| `Transaction_Amount` | float | Amount in INR |
| `Transaction_Type` | string | Transfer / Credit / Debit / Bill Payment / Withdrawal |
| `Merchant_Category` | string | Restaurant / Groceries / Electronics / Clothing / Health / Entertainment |
| `Device_Type` | string | Mobile / Desktop / ATM / POS |
| `Is_Fraud` | int | **Target**: 0 = Legitimate, 1 = Fraud |

---

## 🔍 SQL Queries

### Fraud Rate by State
```sql
SELECT State,
       COUNT(*) AS Total_Transactions,
       SUM(Is_Fraud) AS Fraud_Count,
       ROUND(SUM(Is_Fraud)*100.0/COUNT(*), 2) AS Fraud_Rate_Pct,
       ROUND(AVG(Transaction_Amount), 2) AS Avg_Amount
FROM transactions
GROUP BY State
ORDER BY Fraud_Count DESC;
```

### Fraud by Transaction Type
```sql
SELECT Transaction_Type,
       COUNT(*) AS Total,
       SUM(Is_Fraud) AS Fraud_Count,
       ROUND(SUM(Is_Fraud)*100.0/COUNT(*), 2) AS Fraud_Rate_Pct,
       ROUND(SUM(CASE WHEN Is_Fraud=1 THEN Transaction_Amount ELSE 0 END), 2) AS Fraud_Amount
FROM transactions
GROUP BY Transaction_Type
ORDER BY Fraud_Count DESC;
```

### Hourly Fraud Pattern
```sql
SELECT Hour,
       COUNT(*) AS Total,
       SUM(Is_Fraud) AS Fraud_Count,
       ROUND(SUM(Is_Fraud)*100.0/COUNT(*), 2) AS Fraud_Rate_Pct
FROM transactions
GROUP BY Hour
ORDER BY Hour;
```

---

## 📈 Key Insights

| Dimension | Highest Risk | Fraud Rate |
|-----------|-------------|------------|
| State | Tamil Nadu | 5.62% |
| Hour | Midnight (0:00) | 5.32% |
| Age Group | 18–25 | 5.24% |
| Merchant | Clothing | 5.20% |
| Account | Business | 5.17% |
| Txn Type | Transfer | 5.19% |

---

## 🛡 Data Privacy

PII columns removed from analytical outputs:
- `Customer_Name`, `Customer_Email`, `Customer_Contact`, `Transaction_Location`

Raw data should be stored in a secure, access-controlled environment.

---

## 🏗 Future Improvements

- [ ] Machine learning model (Random Forest / XGBoost) for real-time scoring
- [ ] Anomaly detection using Isolation Forest
- [ ] Real-time streaming pipeline (Kafka + Spark)
- [ ] API endpoint for transaction scoring
- [ ] Explainability layer (SHAP values)

---

## 📄 License

Internal use only — LOL Bank Pvt. Ltd. Data Analytics Team..
