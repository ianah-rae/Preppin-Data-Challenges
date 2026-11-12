/*
Preppin' Data | 2023 Week 2: International Bank Account Numbers

Challenge:
Create International Bank Account Numbers (IBANs) for UK bank
transactions by combining account information from two datasets.

Objectives:
- Remove dashes from sort codes to create 6-digit strings.
- Join transaction data with a SWIFT code lookup table to
  retrieve SWIFT codes and check digits.
- Add "GB" as the country code for all transactions.
- Convert numeric identifiers to strings for concatenation.
- Construct IBANs using the country code, check digits,
  SWIFT code, sort code, and account number.
- Output only Transaction ID and IBAN (100 records).

Tool: Snowflake SQL
Concepts: LEFT JOIN, CTEs, REPLACE(), CONCAT(),
data type casting, column exclusion, and GROUP BY ALL.

Source: https://preppindata.blogspot.com/2023/01/2023-week-2-international-bank-account.html
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM PD2023_WK02_TRANSACTIONS;

SELECT *
FROM PD2023_WK02_SWIFT_CODES;

WITH joined_data AS(

    SELECT
        tr.* EXCLUDE (sort_code, transaction_id, account_number),
        s.* EXCLUDE bank,
        REPLACE(sort_code, '-', '') AS sort_code,
        transaction_id::STRING AS transaction_id,
        account_number::STRING AS account_number,
        'GB' AS country_code,
        CONCAT(country_code, check_digits, swift_code, sort_code, account_number) AS IBAN,
        
 
FROM PD2023_WK02_TRANSACTIONS AS tr
LEFT JOIN PD2023_WK02_SWIFT_CODES AS s
ON tr.bank = s.bank
)

SELECT 
    transaction_id, 
    REPLACE(IBAN, '-', '') AS IBAN
FROM JOINED_DATA;
