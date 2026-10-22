// UniPay — Portfolio 4: MongoDB activity_log (document model)
// I ran this in mongosh against my Atlas or local DB:
//   mongosh "<connection-string>" activity_log.js

use('unipay');

db.activity_log.drop();

db.activity_log.insertMany([
  {
    studentEmail: 'student1@uni.edu',
    action: 'TRANSFER',
    details: {
      fromAccountId: 1,
      toAccountId: 2,
      amount: 1500,
      currency: 'NGN',
      transferId: 5001
    },
    channel: 'mobile',
    createdAt: ISODate('2026-10-16T10:00:00Z')
  },
  {
    studentEmail: 'student2@uni.edu',
    action: 'LOGIN',
    details: { device: 'Android', ip: '10.0.0.21' },
    channel: 'mobile',
    createdAt: ISODate('2026-10-16T09:55:00Z')
  },
  {
    studentEmail: 'admin@uni.edu',
    action: 'HIGH_VALUE_REVIEW',
    details: { transferId: 4120, amount: 4800, decision: 'FLAGGED' },
    channel: 'web',
    createdAt: ISODate('2026-10-16T11:30:00Z')
  }
]);

db.activity_log.createIndex({ studentEmail: 1, createdAt: -1 });
db.activity_log.createIndex({ action: 1 });

print('=== All activity logs ===');
printjson(db.activity_log.find().toArray());

print('=== Transfers only ===');
printjson(db.activity_log.find({ action: 'TRANSFER' }).toArray());