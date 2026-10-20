-- UniPay Portfolio 2: the three queries I ran with EXPLAIN ANALYZE before and after adding the indexes.

\echo '=== Q1: Statement for account 1 (last 30 days) ==='
EXPLAIN ANALYZE
SELECT
    t.transfer_id,
    t.from_account_id,
    t.to_account_id,
    t.amount,
    t.status,
    t.created_at
FROM transfer t
WHERE (t.from_account_id = 1 OR t.to_account_id = 1)
  AND t.created_at >= NOW() - INTERVAL '30 days'
ORDER BY t.created_at DESC;

\echo '=== Q2: Top 10 students by total amount sent ==='
EXPLAIN ANALYZE
SELECT
    c.student_number,
    c.full_name,
    SUM(t.amount) AS total_sent,
    COUNT(*) AS transfer_count
FROM transfer t
JOIN account a ON a.account_id = t.from_account_id
JOIN customer c ON c.customer_id = a.customer_id
WHERE t.status = 'COMPLETED'
  AND t.created_at >= NOW() - INTERVAL '90 days'
GROUP BY c.student_number, c.full_name
ORDER BY total_sent DESC
LIMIT 10;

\echo '=== Q3: High-value transfers (amount >= 4000) ==='
EXPLAIN ANALYZE
SELECT
    t.transfer_id,
    t.from_account_id,
    t.to_account_id,
    t.amount,
    t.created_at
FROM transfer t
WHERE t.amount >= 4000
  AND t.status = 'COMPLETED'
ORDER BY t.amount DESC, t.created_at DESC
LIMIT 50;