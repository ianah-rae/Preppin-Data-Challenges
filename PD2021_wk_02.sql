/*
Preppin' Data | 2021 Week 2: Bike Sales Analysis

Challenge:
Clean and transform bike sales data to analyze sales performance
across brands, bike types, and stores.

Objectives:
- Clean the Model field to extract bike brand codes.
- Calculate order values using bike prices and quantities.
- Aggregate sales by brand and bike type to calculate total
  quantity sold, order value, and average bike value.
- Calculate the number of days between order and shipment.
- Aggregate sales by brand and store to calculate total
  quantity sold, order value, and average shipping time.
- Produce two summary tables for analysis.

Tool: Snowflake SQL
Concepts: Data cleaning, calculated fields, aggregations,
GROUP BY, date calculations, and CTEs.

Source: https://preppindata.blogspot.com/2021/01/2021-week-2.html
*/

SELECT *
FROM PD2021_WK02_BIKE_SALES;

WITH BRAND AS (
SELECT 
    MODEL,
    REGEXP_REPLACE(MODEL, '[^A-Za-z]', '') AS BRAND,
    BIKE_TYPE,
    VALUE_PER_BIKE,
    QUANTITY,
    ORDER_DATE,
    SHIPPING_DATE,
    STORE
    

FROM PD2021_WK02_BIKE_SALES

),

ORDER_VALUE AS (

SELECT 
    BRAND,
    BIKE_TYPE,
    SUM(QUANTITY) AS QUANTITY_SOLD,
    SUM(VALUE_PER_BIKE * QUANTITY) AS ORDER_VALUE,
    ROUND(AVG(VALUE_PER_BIKE), 1) AS AVG_BIKE_VALUE_SOLD_PER_BRAND_TYPE
    
FROM BRAND
GROUP BY BRAND, BIKE_TYPE

)
--SELECT *
--FROM ORDER_VALUE;
-- Query to return first output

DAYS_TO_SHIP AS(

SELECT 
    BRAND,
    STORE,
    SUM(VALUE_PER_BIKE * QUANTITY) AS TOTAL_ORDER_VALUE,
    SUM(QUANTITY) AS TOTAL_QUANTITY_SOLD,
    ROUND(AVG(DATEDIFF('DAY', TO_DATE(ORDER_DATE, 'DD/MM/YYYY'), TO_DATE(SHIPPING_DATE, 'DD/MM/YYYY'))), 1) AS DAYS_TO_SHIP,
    
   
FROM BRAND
GROUP BY BRAND, STORE

)

SELECT *
FROM DAYS_TO_SHIP;
