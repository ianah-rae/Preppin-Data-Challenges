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
FROM JOINED_DATA
GROUP BY ALL;