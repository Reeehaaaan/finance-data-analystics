-- Custom INITCAP() function to capitalize the first letter of each word in a string (like PostgreSQL's INITCAP)

DELIMITER $$

CREATE FUNCTION INITCAP(input TEXT) RETURNS TEXT
DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE output TEXT DEFAULT LOWER(input);
  
  WHILE i <= CHAR_LENGTH(output) DO
    IF i = 1 OR SUBSTRING(output, i - 1, 1) = ' ' THEN
      SET output = CONCAT(
        LEFT(output, i - 1),
        UPPER(SUBSTRING(output, i, 1)),
        SUBSTRING(output, i + 1)
      );
    END IF;
    SET i = i + 1;
  END WHILE;

  RETURN output;
END$$

DELIMITER ;

-- Cleaning customers table and creating clean_customers with trimmed names, filled missing emails/phones, title-cased text, and formatted US-style phone numbers

SELECT * FROM customers;

CREATE TABLE clean_customers AS
SELECT customer_id, INITCAP(TRIM(name)) AS name,
COALESCE(NULLIF(TRIM(email), ''), 'Email Unknown') AS email,
CASE
    WHEN LENGTH(REGEXP_REPLACE(phone, '[^0-9]', '')) >= 10 THEN
      CONCAT(
        '(', 
        SUBSTRING(REGEXP_REPLACE(phone, '[^0-9]', ''), -10, 3), ') ',
        SUBSTRING(REGEXP_REPLACE(phone, '[^0-9]', ''), -7, 3), '-',
        SUBSTRING(REGEXP_REPLACE(phone, '[^0-9]', ''), -4)
      )
    ELSE 'Phone Unknown'
END AS phone,
date_of_birth, account_open_date,
INITCAP(TRIM(location)) AS location, INITCAP(TRIM(occupation)) AS occupation
FROM customers;

SELECT * FROM clean_customers;


-- Creating clean_accounts table from accounts to maintain a clean version for analysis

SELECT * FROM accounts;

CREATE TABLE clean_accounts AS 
SELECT * FROM accounts;

SELECT * FROM clean_accounts;

-- Cleaning transactions table and creating clean_transactions with trimmed merchant names, cleaned categories, and null-safe values

SELECT * FROM transactions;

CREATE TABLE clean_transactions AS 
SELECT transaction_id, account_id, transaction_date, transaction_type, amount,
COALESCE(NULLIF(TRIM(merchant), ''),'Merchant Unknown') AS merchant,
INITCAP(TRIM(category)) AS category
FROM transactions
;

SELECT * FROM clean_transactions;

-- Cleaning loan_applications and creating clean_loan_applications with trimmed loan_type and filling null values in amount_applied


SELECT * FROM loan_applications;

CREATE TABLE clean_loan_applications AS 
SELECT loan_id, customer_id, 
INITCAP(TRIM(loan_type)) AS loan_type, 
COALESCE(TRIM(amount_applied), 'N/A') AS amount_applied,
INITCAP(status) AS status, application_date, approved_date
FROM loan_applications
;

SELECT * FROM clean_loan_applications;

-- -- Cleaning credit_scores and creating clean_credit_score by replacing NULL scores with -1 to indicate missing values

SELECT * FROM credit_scores;

CREATE TABLE clean_credit_score AS 
SELECT customer_id, COALESCE(score , -1) AS score, score_date
FROM credit_scores;

SELECT * FROM clean_credit_score;