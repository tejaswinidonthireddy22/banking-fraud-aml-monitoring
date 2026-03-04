-- ═══════════════════════════════════════════════════════
-- LOL Bank Pvt. Ltd. — Fraud Detection SQL Queries
-- Database: fraud_analysis.db (SQLite)
-- Table:    transactions (200,000 rows)
-- ═══════════════════════════════════════════════════════

-- 1. OVERALL SUMMARY
SELECT 
    State,
    COUNT(*) AS Total_Transactions,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Percentage,
    ROUND(AVG(Transaction_Amount), 2) AS Avg_Transaction_Amount
FROM   fraud
GROUP BY State
ORDER BY Fraud_Count DESC;

-- 2. FRAUD BY STATE
SELECT Transaction_Type,
               COUNT(*) AS Total,
               SUM(Is_Fraud) AS Fraud_Count,
               ROUND(SUM(Is_Fraud)*100.0/COUNT(*),2) AS Fraud_Rate_Pct,
               ROUND(SUM(CASE WHEN Is_Fraud=1 THEN Transaction_Amount ELSE 0 END),2) AS Fraud_Amount
        FROM fraud 
        GROUP BY Transaction_Type ORDER BY Fraud_Count DESC ;

-- 3. FRAUD BY TRANSACTION TYPE
SELECT
    Transaction_Type,
    COUNT(*) AS Total,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Pct,
    ROUND(SUM(CASE WHEN Is_Fraud=1 THEN Transaction_Amount ELSE 0 END), 2) AS Fraud_Amount
FROM transactions
GROUP BY Transaction_Type
ORDER BY Fraud_Count DESC;

-- 4. FRAUD BY MERCHANT CATEGORY

 SELECT Merchant_Category,
               COUNT(*) AS Total,
               SUM(Is_Fraud) AS Fraud_Count,
               ROUND(SUM(Is_Fraud)*100.0/COUNT(*),2) AS Fraud_Rate_Pct
        FROM fraud GROUP BY Merchant_Category ORDER BY Fraud_Rate_Pct DESC ;

-- 5. FRAUD BY DEVICE TYPE
SELECT Transaction_Time,
               COUNT(*) AS Total,
               SUM(Is_Fraud) AS Fraud_Count,
               ROUND(SUM(Is_Fraud)*100.0/COUNT(*),2) AS Fraud_Rate_Pct
        FROM fraud GROUP BY Transaction_Time ORDER BY Transaction_Time;

-- 6. FRAUD BY HOUR OF DAY (24-hour pattern)
SELECT Transaction_Time,
               COUNT(*) AS Total,
               SUM(Is_Fraud) AS Fraud_Count,
               ROUND(SUM(Is_Fraud)*100.0/COUNT(*),2) AS Fraud_Rate_Pct
        FROM fraud GROUP BY Transaction_Time ORDER BY Transaction_Time;
-- 7. FRAUD BY AGE GROUP
select Age,
     case
     when Age < 30 then 'young adlut'
     when Age  = 30 and Age < 45 then 'adult'
     when Age >= 45 and age < 60 then 'middle -aged '
     else 'senior'
	end as Age_group ,
    COUNT(*) AS Total,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Pct
     FROM bank GROUP BY Age  ORDER BY Age  ;

-- 8. FRAUD BY ACCOUNT TYPE
SELECT Account_Type,
               COUNT(*) AS Total,
               SUM(Is_Fraud) AS Fraud_Count,
               ROUND(SUM(Is_Fraud)*100.0/COUNT(*),2) AS Fraud_Rate_Pct
        FROM fraud  GROUP BY Account_Type ORDER BY Fraud_Count DESC ;
   ;
-- 9. HIGH-RISK STATE + TYPE CROSS-ANALYSIS
SELECT
    State,
    Transaction_Type,
    COUNT(*) AS Total,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Pct
FROM fraud
WHERE State IN (
    SELECT State FROM transactions GROUP BY State
    ORDER BY SUM(Is_Fraud) DESC LIMIT 5
)
GROUP BY State, Transaction_Type
ORDER BY State, Fraud_Rate_Pct DESC;

-- 10. NIGHT-TIME FRAUD DEEP DIVE (Hours 22–4)
SELECT
Transaction_time,
    State,
    COUNT(*) AS Total,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Pct
FROM fraud
WHERE Transaction_time  IN (22, 23, 0, 1, 2, 3, 4)
GROUP BY Transaction_time , State
ORDER BY Fraud_Rate_Pct DESC
LIMIT 20;

-- 11. AMOUNT BUCKET RISK ANALYSIS
SELECT
   Transaction_Amount ,
    COUNT(*) AS Total,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Pct
FROM transactions
GROUP BY Transaction_Amount
ORDER BY case  Transaction_Amount
    WHEN '<1K' THEN 1 WHEN '1K-5K' THEN 2 WHEN '5K-20K' THEN 3
    WHEN '20K-50K' THEN 4 WHEN '50K+' THEN 5 END;

-- 12. TOP 10 HIGHEST FRAUD-RATE STATE + CATEGORY COMBOS
SELECT
    State,
    Merchant_Category,
    COUNT(*) AS Total,
    SUM(Is_Fraud) AS Fraud_Count,
    ROUND(SUM(Is_Fraud) * 100.0 / COUNT(*), 2) AS Fraud_Rate_Pct
FROM fraud
GROUP BY State, Merchant_Category
HAVING Total >= 50
ORDER BY Fraud_Rate_Pct DESC
LIMIT 10;

   
