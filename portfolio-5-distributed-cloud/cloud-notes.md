### Portfolio 5 - Distributed and Cloud Database (UniPay)

### What I aimed to achieve

Show that UniPay is not only running on my local Docker Postgres.  
I deployed the same database design to a **cloud Postgres host (Neon)** and loaded real sample data there.

### What I did (practical work)

1. Created a free project on [Neon](https://neon.tech).
2. Copied the Neon **connection string** from the dashboard (psql / PostgreSQL format, with `sslmode=require`).
3. From my machine, ran the UniPay SQL files against that Neon string with `psql`, for example:

```powershell
psql "postgresql://USER:PASSWORD@HOST/DATABASE?sslmode=require" -f .\portfolio-1-database-design\schema.sql
psql "postgresql://USER:PASSWORD@HOST/DATABASE?sslmode=require" -f .\portfolio-2-query-optimisation\seed.sql
```

4. `schema.sql` created the live cloud tables: `customer`, `account`, `transfer`.
5. `seed.sql` loaded about 100 students, 100 accounts, and about 5,000 transfers into Neon.
6. Checked the data in Neon **Tables** / SQL Editor with queries such as:

```sql
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM account;
SELECT COUNT(*) FROM transfer;
SELECT * FROM customer LIMIT 5;
```

7. Saved screenshots in `Screenshots/` (passwords / full connection strings hidden).

### Result

UniPay now exists in the cloud with:

- the Portfolio 1 schema  
- the Portfolio 2 seed data  

So the cloud database matches what I tested locally.

### Replication (read scale)

- **Primary:** all transfers (writes), with strong consistency
- **Read replica:** statement / top-spender reports (Portfolio 2 style reads)

Neon has a primary compute and can support read replicas depending on plan.  
Even on the free tier, the idea is:

- writes (transfers) go to the **primary**
- heavy reporting can go to a **replica**
- a little replica lag is OK for reports, but **not** OK when approving a money transfer

### Sharding (scale-out design note)

If UniPay grew to many campuses:

- **Shard key:** `customer_id` (or a hash of it)
- Keep one student's account and related transfers on the same shard when possible
- Cross-shard transfers are harder, so the simple 3-table design helps me explain the trade-off

I did not build a live sharded cluster. For this portfolio, the cloud deploy + this design note is enough.

### Consistency choices

- **Account balances / transfers (Postgres on Neon):** strong consistency, because money must not double-spend
- **Activity logs (MongoDB from Portfolio 4):** eventual consistency is OK, because the audit can lag slightly behind the transfer

### Short reflection

Putting UniPay on Neon shows the same schema can run as a hosted cloud database, not only on my laptop.  
For money, I still want strong consistency on the primary.  
For growth, read replicas can help reports, and sharding by `customer_id` is a possible next step if the campus system becomes very large.