### UniPay Campus Wallet: Case Study Description

**Scenario:** UniPay Campus Wallet, A simulated payment system for a university campus.

### What it is

For this portfolio I proposed a new case study I'm using UniPay Campus Wallet, study a system for a university. Every registered student gets one wallet. They use it to send small amounts to other students, like paying back a friend for lunch or collecting money for a group project and they can look at their own transfer history. I picked it because it's small enough to build properly in one semester but still has the things a real payment system needs: money moving between accounts, a history that has to stay accurate and a need for someone to keep an eye on large transfers.

### Who uses the database

- **Students** own a wallet, send and receive money, and view their statements.
- **Campus admins** review high-value transfers and check activity logs.

### What data is stored

- **Customers:** the student's name, email and student number.
- **Accounts:** one wallet per student, with its current balance.
- **Transfers:** every movement of money from one wallet to another.
- **Activity logs:** events like logins and transfer attempts.

### Key operations

- Register student - adds a customer and creates their wallet account.
- Transfer funds - takes money from the sender, adds it to the receiver and records the transfer.
- View statement - lists the transfers for one account within a date range.
- Top spenders - ranks students by the total amount they've sent.
- High-value review - lists transfers above ₦50,000 for the admin to check.
- Activity log - saves flexible event records in MongoDB.
