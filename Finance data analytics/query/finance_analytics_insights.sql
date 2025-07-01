SELECT * FROM clean_accounts;

SELECT * FROM clean_customers;

SELECT * FROM clean_transactions;

SELECT * FROM clean_loan_applications;

SELECT * FROM clean_credit_score;

-- Calculate the average account balance for each account type, sorted from highest to lowest

SELECT account_type, ROUND(AVG(balance),2) AS avg_balance
FROM clean_accounts
GROUP BY account_type
ORDER BY avg_balance DESC
;


-- Identifying the top 5 customers with the highest total transaction amount

SELECT name, SUM(amount) AS highest_transaction
FROM clean_customers AS c
JOIN clean_accounts AS a
	ON c.customer_id = a.customer_id
JOIN clean_transactions AS t
	ON a.account_id = t.account_id
GROUP BY name
ORDER BY highest_transaction DESC
LIMIT 5
;

-- Finding the account type with the highest number of transactions.

SELECT account_type, COUNT(*) num_of_transactions
FROM clean_accounts AS a
JOIN clean_transactions AS t
	ON a.account_id = t.account_id
GROUP BY account_type
ORDER BY num_of_transactions DESC
LIMIT 1
;

-- Finding the loan type with the highest approval rate by calculating the percentage of approved applications for each loan type.

SELECT loan_type,COUNT(*) AS total_applications, 
SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) AS approved_count,
ROUND(SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END)* 100/COUNT(*),2) AS approval_rate
FROM clean_loan_applications
GROUP BY loan_type
ORDER BY approval_rate DESC
;

-- Comparing the number of Successful, Failed, and Pending transactions using CASE on the status column.

SELECT COUNT(*) AS total_transcations,
CASE 
	WHEN status = 'Rejected' THEN 'Failed'
    WHEN status = 'Pending' THEN 'Pending'
    ELSE 'Succesful'
END AS transaction_status
FROM clean_loan_applications
GROUP BY transaction_status
;


-- To determine which credit score band has the highest loan approval rate by categorizing credit scores and analyzing approvals in each group.

SELECT 
CASE 
	WHEN score < 580 THEN 'Poor'
    WHEN score BETWEEN 580 AND 699 THEN 'Fair'
    WHEN score BETWEEN 670 AND 739 THEN 'Good'
    WHEN score BETWEEN 740 AND 799 THEN 'Very Good'
    WHEN score >= 800 THEN 'Excellent'
    ELSE 'No History'
END AS credit_band,
COUNT(*) AS total_applications,
SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END ) AS approved_count,
ROUND(SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END ) * 100/ COUNT(*),2 ) AS approval_rate
FROM clean_credit_score AS c
JOIN clean_loan_applications AS l
	ON c.customer_id = l.customer_id
GROUP BY credit_band
ORDER BY approval_rate DESC
;

-- Identifying customers whose latest transaction pushed their total spending above the average total spending across all customers.

WITH customer_total AS 
(
	SELECT c.customer_id, c.name, SUM(t.amount) AS total_spent
    FROM clean_customers AS c
	JOIN clean_accounts AS ca 
		ON c.customer_id = ca.customer_id
	JOIN clean_transactions AS t 
		ON ca.account_id = t.account_id
    GROUP BY c.customer_id, c.name
),
latest_transaction AS 
(
	SELECT c.customer_id, t.transaction_date, t.amount AS latest_transac_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date DESC) AS rn
    FROM clean_customers AS c
    JOIN clean_accounts AS ca
		ON c.customer_id = ca.customer_id
	JOIN clean_transactions AS t
		ON ca.account_id = t.account_id
),
average_spent AS
(
	SELECT ROUND(AVG(total_spent),2) AS avg_total_spent
    FROM customer_total
)
SELECT ct.customer_id,ct.name,ct.total_spent,lt.latest_transac_amount,asp.avg_total_spent
FROM customer_total as ct
JOIN latest_transaction AS lt 
	ON ct.customer_id = lt.customer_id AND lt.rn = 1
JOIN average_spent AS asp
	ON 1=1 
WHERE (ct.total_spent - lt.latest_transac_amount) < asp.avg_total_spent
  AND ct.total_spent >= asp.avg_total_spent
ORDER BY ct.total_spent DESC;


-- Finding the top 5 merchants where customers have spent the most money, along with the number of transactions for each.

SELECT  t.merchant,SUM(t.amount) AS total_spent,COUNT(*) AS transaction_count
FROM clean_customers AS c
JOIN clean_accounts AS a
	ON c.customer_id = a.customer_id
JOIN clean_transactions AS t
	ON a.account_id = t.account_id
GROUP BY t.merchant
ORDER BY total_spent DESC
LIMIT 5
;


-- Identifying customers who have applied for more than one loan and calculate the average approved amount for them.

SELECT name, COUNT(loan_type) multiple_loan_applications,
ROUND(AVG(CASE WHEN status = 'Approved' THEN amount_applied ELSE NULL END ),2) AS avg_amount_approved
FROM clean_customers AS c
JOIN clean_loan_applications AS l
	ON c.customer_id = l.customer_id
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY avg_amount_approved DESC
;


-- Finding the average credit score of customers who were approved for a loan in the last 6 months.

SELECT ROUND(AVG(score),2) AS avg_credit_score, COUNT(DISTINCT c.customer_id) AS customer_considered
FROM clean_credit_score AS c
JOIN clean_loan_applications AS la
	ON c.customer_id = la.customer_id
WHERE la.status = 'Approved'
  AND la.approved_date >= (
    SELECT MAX(approved_date) FROM clean_loan_applications
  ) - INTERVAL 6 MONTH;
;


-- Identifying customers who made more than 3 transactions in a single day totaling over 10,000 — potential suspicious activity.

SELECT c.name, transaction_date, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM clean_customers AS c
JOIN clean_accounts AS a
	ON c.customer_id = a.customer_id
JOIN clean_transactions AS t
	ON t.account_id = a.account_id
GROUP BY name, transaction_date
HAVING COUNT(*) > 3 AND SUM(amount) > 10000
ORDER BY total_amount DESC
;


-- Showing the number of loan applications submitted each month over time.

SELECT DATE_FORMAT(application_date, '%y-%m') AS month,
COUNT(*) AS total_applications
FROM clean_loan_applications
GROUP BY month
ORDER BY month DESC
;

-- Categorize customers based on total spending into segments: 'Low', 'Medium', 'High', 'Very High'

SELECT c.customer_id, name,SUM(amount) AS total_spending,
CASE 
	WHEN SUM(amount) < 5000 THEN 'Low'
    WHEN SUM(amount) BETWEEN 5000 AND 25000 THEN 'Medium'
    WHEN SUM(amount) BETWEEN 25001 AND 75000 THEN 'High'
    ELSE 'Very High'
END AS spending_status   
FROM clean_customers AS c
JOIN clean_accounts AS a
	ON c.customer_id = a.customer_id
JOIN clean_transactions AS t
	ON t.account_id = a.account_id
GROUP BY c.customer_id, name
ORDER BY total_spending DESC;
;
