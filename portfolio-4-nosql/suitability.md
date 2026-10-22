### Why MongoDB for UniPay activity logs

### What I stored

Collection: `activity_log`  
Document fields vary by `action` (`TRANSFER`, `LOGIN`, `HIGH_VALUE_REVIEW`). Nested `details` hold action-specific data.

### Why a document model fits

- **Different actions, different fields:** nested `details` mean no ALTER TABLE. A relational alternative would need sparse nullable columns or EAV tables.
- **Append-only audit trail:** I insert documents and rarely update them. A relational alternative needs extra tables + a rigid schema.
- **Occasional admin queries:** I added indexes on `studentEmail` and `action`. This is possible in a relational database too, but less flexible.

### What stays in PostgreSQL

- **Balances and transfers** (source of truth) — need ACID, FKs, `CHECK (balance >= 0)`  
- MongoDB is **not** used to authorise a payment; it only records flexible events after/around operations  

### Suitability conclusion

I used a **polyglot** approach for UniPay: PostgreSQL for money correctness, MongoDB for flexible activity/audit documents. That matches Portfolio 4's requirement to justify when NoSQL is appropriate.

### Evidence I captured

1. A screenshot of the `activity_log` documents  
2. The output of `mongosh` running `activity_log.js`  
3. This short suitability note in the repo