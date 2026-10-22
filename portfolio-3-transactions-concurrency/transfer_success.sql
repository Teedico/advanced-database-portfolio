-- Demo A: I run a successful atomic transfer (account 1 -> 2, amount 1500)
-- I ran: psql -d unipay -f transfer_success.sql

\echo 'Balances BEFORE'
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;

BEGIN;

-- I lock both wallets in account_id order (prevents deadlock)
SELECT account_id, balance
FROM account
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;

-- I debit only if there are enough funds
UPDATE account
SET balance = balance - 1500
WHERE account_id = 1
  AND balance >= 1500;

UPDATE account
SET balance = balance + 1500
WHERE account_id = 2;

INSERT INTO transfer (from_account_id, to_account_id, amount, status)
VALUES (1, 2, 1500.00, 'COMPLETED');

COMMIT;

\echo 'Balances AFTER COMMIT (account 1 down by 1500, account 2 up by 1500)'
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;