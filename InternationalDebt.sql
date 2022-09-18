--This project explores the international debt collected by The World Bank.
--This dataset contains data regarding the amount of debt owed by developing nations. 


--This project will be used to answer the following questions
--What is the total amount of debt that is owed by the countries listed in the dataset?
--Which country owns the maximum amount of debt and what does that amount look like?
--What is the average amount of debt owed by countries across different debt indicators?




--First, pulling data from the international debt table and limiting output to 10

%%sql
postgresql:///international_debt
SELECT * FROM international_debt
LIMIT 10



--Finding the number of distinct countries
--Results: There are 124 unique countries

%%sql
SELECT 
    COUNT(DISTINCT country_name) AS total_distinct_countries
FROM international_debt;



--Finding the  distinct debt indicators


%%sql

SELECT 
    DISTINCT indicator_code AS distinct_debt_indicators
FROM international_debt
ORDER BY distinct_debt_indicators;


--Totaling the amount of debt owed by the countries
--Helps to give a sense of how the overall world's economy is holding up
--Result: Total Debt = 3,079,734.49

%%sql
SELECT 
    ROUND(SUM(debt)/1000000, 2) as total_debt
FROM international_debt; 



--Country with the highest debt
--The debt consists of different debts owed by a country across several categories
--The results will help the end user to understand the country's socio-economic scenarios
--Results: China, total debt = 285793494734.200001568


%%sql
SELECT 
    country_name, 
    SUM(debt) as total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
LIMIT 1;


--Average amount of debt across indicators
--Information will help give end user a better sense of the distribution of the amount of debt across different indicators
--Result: DT.AMT.DLXF.CD


%%sql
SELECT 
    indicator_code AS debt_indicator,
    indicator_name,
    AVG(debt) as average_debt
FROM international_debt
GROUP BY debt_indicator, indicator_name
ORDER BY average_debt DESC
LIMIT 10;



--The highest amount of principal repayments
--Find out which country owes the highest amount of debt in the category or long term debts (DT.AMT.DLXF.CD)
--Result: China 

%%sql
SELECT 
    country_name, 
    indicator_name
FROM international_debt
WHERE debt = (SELECT 
                  MAX(debt)
              FROM international_debt
              WHERE indicator_code='DT.AMT.DLXF.CD');




--The most common debt indicator
--Longterm debt is the top ccategory when it comes to the average amount of debt
--Result: There are a total of debt indicators

 %%sql

SELECT 
    indicator_code,
    COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC
LIMIT 20;


--Other viable debt issues and conclustion
--Find maximum amount of debt each counntry has
--Result: China has the max amount with 96218620835.699996948 in max debt

%%sql

SELECT 
    country_name, 
    MAX(debt) AS maximum_debt
FROM international_debt
GROUP BY country_name
ORDER BY maximum_debt DESC
LIMIT 10;