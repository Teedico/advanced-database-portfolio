### Portfolio 2: Query optimisation

### Goal

I wanted to make UniPay's transfer history queries faster and compare the before and after results to see whether the indexes helped.

### What I did

| Step | What I did | Output |
|------|------------|--------|
| 1 | Ran `seed.sql` | About 100 students and 5,000 transfers |
| 2 | Ran `queries.sql` before adding indexes | `before-all.txt` |
| 3 | Ran `indexes_after.sql` | Three new indexes on `transfer` |
| 4 | Ran `queries.sql` again | `after-all.txt` |

I then wrote my comparison in `performance-analysis.md`.

### Commands

I ran everything from the `advanced-database-portfolio` folder with Docker running.

**0) Started the database**

```powershell
docker compose up -d
```

**1) Seeded the data**

```powershell
Get-Content .\portfolio-2-query-optimisation\seed.sql -Raw | docker compose exec -T db psql -U unipay -d unipay
```

**2) Saved the before results**

```powershell
Get-Content .\portfolio-2-query-optimisation\queries.sql -Raw | docker compose exec -T db psql -U unipay -d unipay | Out-File -Encoding utf8 .\portfolio-2-query-optimisation\explain-plans\before-all.txt
```

**3) Added the indexes**

```powershell
Get-Content .\portfolio-2-query-optimisation\indexes_after.sql -Raw | docker compose exec -T db psql -U unipay -d unipay
```

**4) Saved the after results**

```powershell
Get-Content .\portfolio-2-query-optimisation\queries.sql -Raw | docker compose exec -T db psql -U unipay -d unipay | Out-File -Encoding utf8 .\portfolio-2-query-optimisation\explain-plans\after-all.txt
```

### Files

| File | Purpose |
|------|---------|
| `seed.sql` | Adds the sample data |
| `queries.sql` | The three queries I tested with `EXPLAIN ANALYZE` |
| `indexes_after.sql` | Creates the indexes |
| `explain-plans/before-all.txt` | Plans and timings before the indexes |
| `explain-plans/after-all.txt` | Plans and timings after the indexes |
| `performance-analysis.md` | My before/after write-up |