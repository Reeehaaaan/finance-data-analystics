# Create customer table

CREATE TABLE customers (
    customer_id INT,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    date_of_birth DATE,
    account_open_date DATE,
    location VARCHAR(100),
    occupation VARCHAR(100)
);


# Create accounts table

CREATE TABLE accounts (
    account_id INT,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(15,2),
    status VARCHAR(50),
    last_updated DATE
);


# Create transactions table

CREATE TABLE transactions (
    transaction_id INT,
    account_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(10), -- 'credit' or 'debit'
    amount DECIMAL(15,2),
    merchant VARCHAR(100),
    category VARCHAR(100)
);


# Create loan_applocations table

CREATE TABLE loan_applications (
    loan_id INT,
    customer_id INT,
    loan_type VARCHAR(50),
    amount_applied DECIMAL(15,2),
    status VARCHAR(50),
    application_date DATE,
    approved_date DATE
);


# Create credit_score table

CREATE TABLE credit_scores (
    customer_id INT,
    score INT,
    score_date DATE
);
