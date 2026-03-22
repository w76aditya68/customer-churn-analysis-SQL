 --  =========================================
 -- 1. CREATE DATABASE
 -- =========================================

CREATE DATABASE project2;
USE project2;

 -- =========================================
 -- 2. CREATE TABLE
 -- =========================================

 CREATE TABLE teleco_customer_churn (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges FLOAT,
    TotalCharges FLOAT,
    Churn VARCHAR(10)
);

-- Dataset: Telco Customer Churn (Kaggle)
-- Table imported using MySQL Workbench Import Wizard


-- =========================================
-- 3. DATA CLEANING
-- =========================================

-- Disable safe mode for update
SET SQL_SAFE_UPDATES = 0;
UPDATE teleco_customer_churn
SET TotalCharges = NULL
WHERE TotalCharges = '';

ALTER TABLE teleco_customer_churn MODIFY TotalCharges FLOAT;

-- =========================================
-- 4. BASIC EXPLORATION
-- =========================================

SELECT COUNT(*) AS total_customers FROM teleco_customer_churn;

SELECT Churn, COUNT(*) AS count
FROM teleco_customer_churn
GROUP BY Churn;

-- =========================================
-- 5. OVERALL CHURN RATE
-- =========================================

SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate_percent
FROM teleco_customer_churn;


-- =========================================
-- 6. CHURN BY GENDER
-- =========================================

SELECT gender,
       ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY gender;


-- =========================================
-- 7. CHURN BY SENIOR CITIZEN
-- =========================================

SELECT SeniorCitizen,
       ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY SeniorCitizen;

-- =========================================
-- 8. CHURN BY CONTRACT TYPE
-- =========================================

SELECT Contract,
       ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY Contract
ORDER BY churn_rate DESC;

-- =======================================
--  9. CHURN BY TENURE GROUP
-- =========================================

SELECT 
    CASE 
        WHEN tenure < 12 THEN 'New'
        WHEN tenure BETWEEN 12 AND 24 THEN 'Medium'
        ELSE 'Old'
    END AS customer_group,
    ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY customer_group
ORDER BY churn_rate DESC;


-- =========================================
-- 10. CHURN BY MONTHLY CHARGES
-- =========================================

SELECT 
    CASE 
        WHEN MonthlyCharges < 40 THEN 'Low'
        WHEN MonthlyCharges BETWEEN 40 AND 80 THEN 'Medium'
        ELSE 'High'
    END AS charge_group,
    ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY charge_group
ORDER BY churn_rate DESC;


-- =========================================
-- 11. CHURN BY PAYMENT METHOD
-- =========================================

SELECT PaymentMethod,
       ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- =========================================
-- 12. CHURN BY INTERNET SERVICE
-- =========================================

SELECT InternetService,
       ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY InternetService;


-- =========================================
-- 13. CHURN BY TECH SUPPORT
-- =========================================

SELECT TechSupport,
       ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY TechSupport;

-- =========================================
-- 14. HIGH RISK CUSTOMERS
-- =========================================

SELECT *
FROM teleco_customer_churn
WHERE tenure < 12
AND MonthlyCharges > 70
AND Contract = 'Month-to-month'
AND Churn = 'Yes';


-- =========================================
-- 15. CUSTOMER SEGMENTATION
-- =========================================

SELECT 
    CASE 
        WHEN tenure < 12 THEN 'New'
        ELSE 'Existing'
    END AS customer_type,
    Contract,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY customer_type, Contract
ORDER BY churn_rate DESC;

-- =========================================
-- 16. TOP CHURN DRIVERS
-- =========================================

SELECT 
    Contract,
    InternetService,
    TechSupport,
    ROUND(AVG(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100,2) AS churn_rate
FROM teleco_customer_churn
GROUP BY Contract, InternetService, TechSupport
ORDER BY churn_rate DESC
LIMIT 10;

-- =========================================
-- END OF ANALYSIS
-- This project identifies key churn drivers such as contract type,
-- tenure, pricing, and service usage.
-- =========================================

