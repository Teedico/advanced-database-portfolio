### Portfolio 2: How I tested and improved my queries

### Why I did this

In UniPay, students check their transfer history and admins look for large transfers. If the `transfer` table grows, those queries can slow down. I wanted to load enough data to test this properly, check how Postgres runs my queries, add indexes, and compare the results.

### Steps I took

I started the Docker Postgres container for UniPay:

```powershell
cd advanced-database-portfolio
docker compose up -d
```

**1) Loaded sample data**

I ran `seed.sql` to add about 100 students and about 5,000 transfers. A nearly empty table would make every query look fast, so this gave me a fairer test.

```powershell
Get-Content .\portfolio-2-query-optimisation\seed.sql -Raw | docker compose exec -T db psql -U unipay -d unipay
```

**2) Ran my queries before adding indexes**

I ran the three queries in `queries.sql` with `EXPLAIN ANALYZE` and saved the output as `before-all.txt`:

- Q1: recent transfers for account 1 (a mini statement)
- Q2: top 10 students who sent the most money
- Q3: transfers of 4,000 or more

```powershell
Get-Content .\portfolio-2-query-optimisation\queries.sql -Raw | docker compose exec -T db psql -U unipay -d unipay | Out-File -Encoding utf8 .\portfolio-2-query-optimisation\explain-plans\before-all.txt
```

**3) Added the indexes**

I ran `indexes_after.sql`, which creates three indexes:

- sender account + date
- receiver account + date
- high amounts on completed transfers

```powershell
Get-Content .\portfolio-2-query-optimisation\indexes_after.sql -Raw | docker compose exec -T db psql -U unipay -d unipay
```

**4) Re-ran the same queries**

I ran `queries.sql` again, saved the output as `after-all.txt`, and compared it with `before-all.txt`.

```powershell
Get-Content .\portfolio-2-query-optimisation\queries.sql -Raw | docker compose exec -T db psql -U unipay -d unipay | Out-File -Encoding utf8 .\portfolio-2-query-optimisation\explain-plans\after-all.txt
```

### Results before the new indexes

- **Q1: about 0.159 ms.** Postgres used the from/to account indexes from Portfolio 1, then filtered by date.
- **Q2: about 2.949 ms.** Postgres did a sequential scan of `transfer`, then joined and grouped the results.
- **Q3: about 0.643 ms.** Also a sequential scan, which checked many rows and kept only the high-value ones.

### Results after the new indexes

- **Q1:** ______ ms. What I noticed: ______
- **Q2:** ______ ms. What I noticed: ______
- **Q3:** ______ ms. What I noticed: ______

### What I learned

A sequential scan is fine on 5,000 rows, but it will not scale well as the table grows. When I compared before and after, I looked at whether the plan changed (for example from a sequential scan to an index scan) as well as the time.

For UniPay, this matters for statement checks and high-value reviews which need to stay fast as more transfers are added.