### Portfolio 3 - (transactions-concurrency)

### Goal of this portfolio

I set out to prove that UniPay money transfers are **safe**:

- a transfer either fully succeeds or fully fails  
- two people cannot mess up the same wallet at the same time  



### Steps 

- **Step 1:** I ran a successful transfer (account 1 → 2). It showed `COMMIT` works (balances change correctly).
- **Step 2:** I tried a transfer that was too big. It showed `ROLLBACK` works (balances stay the same).
- **Step 3:** I opened two sessions and transferred at the same time. It showed locking stops double-spend / lost update.

I took screenshots for each demo and put them in `Screenshots`.


### Words in one line

- `BEGIN`: Start a transfer pack
- `COMMIT`: Save all changes
- `ROLLBACK`: Undo all changes
- `FOR UPDATE`: Lock the wallet rows so others wait


### Before I started

1. Docker was running: `docker compose up -d`
2. The schema and seed were already loaded (Portfolio 1 + 2)
3. Accounts **1** and **2** existed (the seed sets demo balances)

I started from the `advanced-database-portfolio` folder.


### Step 1 - Successful transfer (COMMIT)

I moved 1500 from account 1 to account 2 in one safe pack.

**Command:**

```powershell
Get-Content .\portfolio-3-transactions-concurrency\transfer_success.sql -Raw | docker compose exec -T db psql -U unipay -d unipay
```

I took a screenshot of the balances before and after. The sender went down, the receiver went up, and one new transfer row was added.


### Step 2 - Failed transfer (ROLLBACK)

I tried to send a huge amount that account 1 could not afford.

**Command:**

```powershell
Get-Content .\portfolio-3-transactions-concurrency\transfer_rollback.sql -Raw | docker compose exec -T db psql -U unipay -d unipay
```

I took a screenshot of the error and the balances staying unchanged. That proves the rollback.


### Step 3 - Two people at once (concurrency)

#### What I was trying to show

Two "people" (two terminal windows) try to use the same wallets.

- Person A locks the wallets first  
- Person B must **wait**  
- After A finishes, B can continue  
- Both transfers stay safe  

I used two terminal windows side by side and called them **A** and **B**.


#### 3.0 Prepare

1. I went to the `advanced-database-portfolio` folder  
2. I made sure Docker was running (`docker compose up -d`)  
3. I opened **Terminal A**  
4. I opened **Terminal B** (a second PowerShell / Cursor terminal)


#### 3.1 In Terminal A - join the database

I pasted this and pressed Enter:

```powershell
docker compose exec db psql -U unipay -d unipay
```

I got the prompt:

```text
unipay=#
```

I left Terminal A open.


#### 3.2 In Terminal B - join the database too

In the other window, I pasted the same command:

```powershell
docker compose exec db psql -U unipay -d unipay
```

I got the same prompt:

```text
unipay=#
```

Both windows were now connected to UniPay.


#### 3.3 In Terminal A - lock the wallets (not finished yet)

In Terminal A (at `unipay=#`), I pasted all of this and pressed Enter:

```sql
BEGIN;
SELECT account_id, balance
FROM account
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;
```

The balances for accounts 1 and 2 were printed. I did **not** type `COMMIT`, so A was holding the lock.

**Screenshot 1:** Terminal A showing the balances after `FOR UPDATE`.


#### 3.4 In Terminal B - try to lock the same wallets

In Terminal B, I pasted this and pressed Enter:

```sql
BEGIN;
SELECT account_id, balance
FROM account
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;
```

Terminal B looked stuck and did not show balances. That was expected, because B was **waiting** for A.

**Screenshot 2:** Terminal B waiting (no result yet), with A still open beside it.


#### 3.5 Back in Terminal A - finish A's transfer and unlock

I went back to Terminal A, pasted this and pressed Enter:

```sql
UPDATE account SET balance = balance - 3000 WHERE account_id = 1 AND balance >= 3000;
UPDATE account SET balance = balance + 3000 WHERE account_id = 2;
INSERT INTO transfer (from_account_id, to_account_id, amount, status)
VALUES (1, 2, 3000.00, 'COMPLETED');
COMMIT;
```

A showed `UPDATE`, `INSERT` and `COMMIT` success. As soon as A committed, B showed the balances because the lock was released.

**Screenshot 3:** Terminal A after `COMMIT`, and Terminal B unblocked.


#### 3.6 In Terminal B - finish B's transfer

In Terminal B (now unblocked), I pasted this and pressed Enter:

```sql
UPDATE account SET balance = balance - 2000 WHERE account_id = 1 AND balance >= 2000;
UPDATE account SET balance = balance + 2000 WHERE account_id = 2;
INSERT INTO transfer (from_account_id, to_account_id, amount, status)
VALUES (1, 2, 2000.00, 'COMPLETED');
COMMIT;
```

Then I checked the final balances:

```sql
SELECT account_id, balance FROM account WHERE account_id IN (1, 2) ORDER BY account_id;
```

**Screenshot 4:** B's `COMMIT` and the final balances.


#### 3.7 What this proved

- B waited while A held `FOR UPDATE`, so the second transfer could not change the wallets at the same time.
- A committed, then B continued, so the transfers ran one after another safely.
- Both commits worked, so there was no double-spend / lost update in this demo.

I saved the screenshots in the `Screenshots` folder (e.g. `Step 1 Screenshot Evidence.png`, `Step 2 Screenshot Evidence.png`, `Step 3a Terminal B waiting for Terminal A.png`, `Step 3b Terminal A after COMMIT.png`, `Step 3c COMMIT + final balances.png` ).

### Files

- `transfer_success.sql`: Demo successful transfer
- `transfer_rollback.sql`: Demo failed transfer / undo
- `concurrency_session_a.sql` / `b.sql`: Optional script versions of the two-window demo
- `Screenshots`: My evidence images
- `concurrency-demo.md`: Extra explanation of the concurrency demo