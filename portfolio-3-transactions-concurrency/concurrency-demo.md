### Transactions and Concurrency - UniPay
Default isolation in PostgreSQL is **READ COMMITTED**. For wallet transfers I still used **row locks** (`SELECT … FOR UPDATE`) so two sessions cannot debit the same balance at once.

### Evidence 1 - COMMIT

```bash
psql -d unipay -f transfer_success.sql
```

My screenshot shows the balances before and after. Account 1 decreased by 1500, account 2 increased by 1500, and one new `transfer` row was added.

### Evidence 2 - ROLLBACK

```bash
psql -d unipay -f transfer_rollback.sql
```

My screenshot shows the `Insufficient funds` error and the balances unchanged after `ROLLBACK`.

### Evidence 3 - Concurrent transfers (lost-update prevention)

Without locking, two sessions could both read balance 20,000 and both debit — **lost update**.  
With `FOR UPDATE` + locking accounts in **ascending `account_id` order**:

1. I opened **two** `psql` sessions to database `unipay`.  
2. In Session A, I ran `concurrency_session_a.sql` until it held the locks.  
3. In Session B, I ran `concurrency_session_b.sql` and it **blocked/waited**.  
4. I let Session A finish (`COMMIT`), and Session B continued.  
5. I took screenshots of both windows and the final balances.

What I expected: both transfers apply safely, one after the other, and the balance never goes negative from a double-spend.

### Summary

- **Atomicity:** I put the debit, credit and `transfer` insert in one transaction, so they succeed together or not at all.
- **Consistency:** I used `CHECK (balance >= 0)` plus an application fund check, so a balance can't go negative.
- **Isolation:** I used `FOR UPDATE` locks, so when I ran Session B it had to wait for Session A to commit.
- **Durability:** After `COMMIT`, I restarted `psql` and the balances were still there.

I put the PNG screenshots in the `Screenshots` folder (e.g. `Step 1 Screenshot Evidence.png`, `Step 2 Screenshot Evidence.png`, `Step 3a Terminal B waiting for Terminal A.png`, `Step 3b Terminal A after COMMIT.png`, `Step 3c COMMIT + final balances.png` ).