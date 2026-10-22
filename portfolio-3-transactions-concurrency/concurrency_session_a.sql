-- Session A: I run this first in one psql window, then run Session B in a second window.

\echo 'SESSION A: starting transfer 3000 from account 1 -> 2'
BEGIN;

SELECT account_id, balance
FROM account
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;

\echo 'SESSION A: locks held. NOW run concurrency_session_b.sql in the other window (it should WAIT).'
\echo 'When Session B is waiting, continue this script (it will COMMIT and release locks).'

UPDATE account SET balance = balance - 3000 WHERE account_id = 1 AND balance >= 3000;
UPDATE account SET balance = balance + 3000 WHERE account_id = 2;
INSERT INTO transfer (from_account_id, to_account_id, amount, status)
VALUES (1, 2, 3000.00, 'COMPLETED');

COMMIT;

\echo 'SESSION A: committed. Session B should proceed now.'
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;