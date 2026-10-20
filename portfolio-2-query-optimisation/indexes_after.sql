-- UniPay Portfolio 2: indexes I added after saving the baseline EXPLAIN ANALYZE plans.
-- I ran this file, then re-ran queries.sql to compare.

CREATE INDEX IF NOT EXISTS idx_transfer_from_created
    ON transfer (from_account_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transfer_to_created
    ON transfer (to_account_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transfer_amount_status
    ON transfer (amount DESC, status)
    WHERE status = 'COMPLETED';

ANALYZE transfer;
