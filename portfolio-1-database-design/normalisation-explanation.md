### Normalisation notes: UniPay Campus Wallet

**Starting point (A bad design)**

Say I stored everything in one wide table:

student_name, email, student_number, balance, from_name, to_name, amount, txn_date

This causes three problems:
- A student's details get repeated on every transfer they make.
- If a student changes their email, I'd have to update many rows and could miss one.
- If I delete a student's only transfer, I would lose the student's details too.

**1NF**

Every column holds one value. There's no list of transfers squeezed into a single cell. The table is still messy, but every column now holds a single value.

**2NF**

Assume the wide table is identified by student_number plus transfer_id. Name and email depend only on student_number, not on the whole key. That's a partial dependency. To fix it, I moved student details into their own table, `customer` and left only transfer facts in `transfer`.

**3NF**

Name and email depend on the student, and the balance depends on the wallet. Neither depends on the transfer itself. I split the wallet out into `account`, so identity sits in `customer`, money sits in `account` and each movement of money sits in `transfer`.

**Final schema**

- customer - who the student is (key: customer_id)
- account - the wallet and its balance (key: account_id, with customer_id as a unique foreign key)
- transfer - one money movement (key: transfer_id, with foreign keys to the sending and receiving accounts)

**Design decisions**

- One wallet per customer, so customer_id is unique in `account`. This matches the campus wallet rule.
- The balance lives on the account, which makes it easy to check and lock during a transfer.
- There's no separate ledger table. Each completed transfer is one row, which is enough for this portfolio.
- Constraints: balance must be 0 or more, amount must be above 0, and the sender and receiver can't be the same account.
