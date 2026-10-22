### Portfolio 4 - (NoSQL / MongoDB)

### Goal of this portfolio

I set out to show that UniPay can use a **NoSQL (document) database** for activity logs.

Simple split:

- **PostgreSQL** keeps money (balances + transfers), because it must be strict and safe (ACID).
- **MongoDB** keeps activity logs (what happened), because it has a flexible shape and makes it easy to add new event types.

I used **Docker Mongo locally** + **mongosh** only.

### Steps

- **Step 1:** I started MongoDB in Docker. This gave me a local NoSQL database running.
- **Step 2:** I ran `activity_log.js` with mongosh. This inserted the sample activity logs.
- **Step 3:** I took a screenshot of the mongosh output. This is my evidence for submission.
- **Step 4:** I read `suitability.md`. It gives a short explanation of why Mongo fits logs.

### Before I started

1. Docker Desktop was running  
2. `mongosh` was installed (`mongosh --version`)  
3. I was in the `advanced-database-portfolio` folder  

### Step 1 - Start MongoDB (Docker)

Since the container did **not** exist yet, I ran:

```powershell
docker run -d --name unipay-mongo -p 27017:27017 mongo:7
```

If I had seen "name is already in use", I would have started it instead:

```powershell
docker start unipay-mongo
```

I checked it was up:

```powershell
docker ps --filter name=unipay-mongo
```

### Step 2 - Insert sample activity logs (mongosh)

```powershell
mongosh "mongodb://localhost:27017" .\portfolio-4-nosql\activity_log.js
```

**What this did**

- connected to local Mongo on port 27017  
- used database `unipay`  
- filled collection `activity_log`  
- printed the documents  

The result was live NoSQL activity-log data for UniPay.

### Step 3 - Screenshot evidence

I took a screenshot of the mongosh terminal output showing the inserted documents.

I also opened mongosh again to view them:

```powershell
mongosh "mongodb://localhost:27017"
```

Then inside mongosh:

```javascript
use('unipay')
db.activity_log.find().pretty()
```

I typed `exit` to leave.

I saved the screenshot in this folder (or a `screenshots/` subfolder).

### Step 4 - Suitability note

I read `suitability.md`.

In my own words:

- Postgres = money (strict)  
- Mongo = flexible logs  

### Files

- `activity_log.js`: Inserts and shows sample logs
- `sample-documents.json`: Example document shapes
- `suitability.md`: Why MongoDB fits this use case
- Screenshot(s): My practical evidence