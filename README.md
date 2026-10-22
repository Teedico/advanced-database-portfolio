### UniPay Campus Wallet - Advanced Database Portfolio

**Course:** MIT 8103 Advanced Database Systems  
**Case study used in all parts:** UniPay Campus Wallet  

### About UniPay

UniPay is a simple campus wallet app idea. Each student has **one wallet** Students can **send money** to each other and they can also **check history** of their wallet and recieve money from others.

**Tools I used**

- **PostgreSQL (Docker):** main money database
- **MongoDB:** activity / event logs
- **Neon (cloud Postgres):** to show it can run in the cloud
 

### Portfolio 1 - Design the database

**Aim:** To draw and build the structure before filling it with data.

- **What I did:** I decided the tables, how they link, and wrote `schema.sql`. I also drew an ER diagram and explained normalisation.
- **What I planned to achieve:** A solid foundation: students, wallets, and transfers, with rules like "balance cannot go below zero".
- **Folder:** [portfolio-1-database-design](portfolio-1-database-design/)

**Result:** Anyone can see *what* UniPay stores and *how* the pieces connect.

### Portfolio 2 - Make questions faster

**Aim:** Put lots of practice data in, ask questions, then add indexes so searching is smarter.

- **What I did:** I seeded ~5,000 transfers, ran queries, saved "before" plans, added indexes, ran the queries again, saved "after" plans, and wrote a short analysis.
- **What I planned to achieve:** Prove that indexes help Postgres find answers better (before vs after evidence).
- **Folder:** [portfolio-2-query-optimisation](portfolio-2-query-optimisation/) ([plain English detail](portfolio-2-query-optimisation/README.md))

**Result:** History and ranking queries are not only written, they are measured and improved.

### Portfolio 3 - Keep money transfers safe

**Aim:** When money moves, it must be correct even if two people act at the same time.

- **What I did:** I showed a successful transfer (`COMMIT`), a failed one that undoes changes (`ROLLBACK`), and two sessions transferring at once with locking.
- **What I planned to achieve:** Show ACID ideas in practice: all-or-nothing transfers, and no "both spent the same money" bug.
- **Folder:** [portfolio-3-transactions-concurrency](portfolio-3-transactions-concurrency/)

**Result:** Wallet balances stay trustworthy under normal and concurrent use.

### Portfolio 4 - Use NoSQL for activity logs

**Aim:** Money stays in PostgreSQL. Flexible "what happened" logs go in MongoDB.

- **What I did:** I created a MongoDB `activity_log` collection, inserted sample documents, and explained why documents fit this use case.
- **What I planned to achieve:** Meet the NoSQL requirement with a sensible UniPay reason (nested/flexible events), without putting balances in Mongo.
- **Folder:** [portfolio-4-nosql](portfolio-4-nosql/)

**Result:** Two stores, clear jobs: Postgres for money, Mongo for logs.

### Portfolio 5 - Run it in the cloud

**Aim:** Show the same database idea can live on a cloud host, and talk about scaling.

- **What I did:** I deployed the schema to Neon, took screenshots, and wrote short notes on replicas, sharding, and consistency.
- **What I planned to achieve:** Show UniPay is not only "local Docker". It can run remotely, and I understand basic distributed ideas.
- **Folder:** [portfolio-5-distributed-cloud](portfolio-5-distributed-cloud/)

**Result:** Cloud evidence + a simple explanation of how it could grow.

### How the five parts fit together

```text
1. Design tables          →  structure
2. Query + indexes        →  speed / reporting
3. Transactions           →  safe money movement
4. MongoDB logs           →  flexible activity history
5. Cloud                  →  host and scale ideas
```