-- Session B: I start this in the second psql window after Session A has taken its FOR UPDATE locks.

\echo 'SESSION B: trying transfer 2000 from account 1 -> 2 (will wait on locks)'
BEGIN;

SELECT account_id, balance
FROM account
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;

\echo 'SESSION B: locks acquired (Session A must have committed)'

UPDATE account SET balance = balance - 2000 WHERE account_id = 1 AND balance >= 2000;
UPDATE account SET balance = balance + 2000 WHERE account_id = 2;
INSERT INTO transfer (from_account_id, to_account_id, amount, status)
VALUES (1, 2, 2000.00, 'COMPLETED');

COMMIT;

\echo 'SESSION B: committed. Final balances:'
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;
