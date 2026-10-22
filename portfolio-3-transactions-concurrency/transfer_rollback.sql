-- Demo B: I run a transfer that fails because of insufficient funds, then ROLLBACK
-- I ran: psql -d unipay -v ON_ERROR_STOP=0 -f transfer_rollback.sql
-- I took a screenshot of the exception AND the unchanged balances.

\echo 'Balances BEFORE rollback demo'
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;

BEGIN;

SELECT account_id, balance
FROM account
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;

DO $$
DECLARE
    v_balance NUMERIC(12, 2);
    v_amount  NUMERIC(12, 2) := 999999;
BEGIN
    SELECT balance INTO v_balance FROM account WHERE account_id = 1;
    IF v_balance < v_amount THEN
        RAISE EXCEPTION 'Insufficient funds (have %, need %)', v_balance, v_amount;
    END IF;

    UPDATE account SET balance = balance - v_amount WHERE account_id = 1;
    UPDATE account SET balance = balance + v_amount WHERE account_id = 2;
    INSERT INTO transfer (from_account_id, to_account_id, amount, status)
    VALUES (1, 2, v_amount, 'COMPLETED');
END $$;

COMMIT;

-- If the DO block raised, the transaction aborted, so I explicitly roll back any open transaction:
ROLLBACK;

\echo 'Balances AFTER rollback (must match BEFORE)'
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;