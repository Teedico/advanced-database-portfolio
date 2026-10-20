-- UniPay Portfolio 2: seed data (about 100 students and 5,000 transfers).
-- I ran this after the Portfolio 1 schema so the tables already existed.

-- I cleared the existing data first and reset the ID counters.
TRUNCATE TABLE transfer RESTART IDENTITY CASCADE;
TRUNCATE TABLE account RESTART IDENTITY CASCADE;
TRUNCATE TABLE customer RESTART IDENTITY CASCADE;

-- I generated 100 students.
INSERT INTO customer (full_name, email, student_number)
SELECT
    'Student ' || g,
    'student' || g || '@uni.edu',
    'SN' || LPAD(g::text, 4, '0')
FROM generate_series(1, 100) AS g;

-- I created one wallet per student, each starting at 100000.00.
INSERT INTO account (customer_id, balance, status)
SELECT customer_id, 100000.00, 'ACTIVE'
FROM customer;

-- I generated 5,500 random candidate transfers over the last 90 days,
-- dropped any where sender and receiver were the same, and kept 5,000.
INSERT INTO transfer (from_account_id, to_account_id, amount, status, created_at)
SELECT
    from_id,
    to_id,
    amount,
    'COMPLETED',
    created_at
FROM (
    SELECT
        (1 + floor(random() * 100))::int AS from_id,
        (1 + floor(random() * 100))::int AS to_id,
        round((50 + random() * 4950)::numeric, 2) AS amount,
        NOW() - ((random() * 90)::int || ' days')::interval
            - ((random() * 86400)::int || ' seconds')::interval AS created_at
    FROM generate_series(1, 5500) AS s
) AS candidates
WHERE from_id <> to_id
LIMIT 5000;

-- The random transfers don't change balances, so I reset them to known values for the Portfolio 3 demos.
UPDATE account SET balance = 50000.00 WHERE status = 'ACTIVE';
UPDATE account SET balance = 20000.00 WHERE account_id = 1;
UPDATE account SET balance = 10000.00 WHERE account_id = 2;

-- I refreshed the planner statistics so the EXPLAIN ANALYZE plans would be realistic.
ANALYZE customer;
ANALYZE account;
ANALYZE transfer;

-- I checked the row counts.
SELECT
    (SELECT COUNT(*) FROM customer) AS customers,
    (SELECT COUNT(*) FROM account) AS accounts,
    (SELECT COUNT(*) FROM transfer) AS transfers;