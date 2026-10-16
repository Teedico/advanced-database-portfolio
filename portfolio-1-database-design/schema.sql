DROP TABLE IF EXISTS transfer CASCADE;
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

CREATE TABLE customer (
    customer_id     SERIAL PRIMARY KEY,
    full_name       VARCHAR(120) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    student_number  VARCHAR(30)  NOT NULL UNIQUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE account (
    account_id   SERIAL PRIMARY KEY,
    customer_id  INT            NOT NULL UNIQUE
                     REFERENCES customer (customer_id)
                     ON DELETE RESTRICT,
    balance      NUMERIC(12, 2) NOT NULL DEFAULT 0
                     CHECK (balance >= 0),
    status       VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE'
                     CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED')),
    opened_at    TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE TABLE transfer (
    transfer_id      SERIAL PRIMARY KEY,
    from_account_id  INT            NOT NULL
                         REFERENCES account (account_id)
                         ON DELETE RESTRICT,
    to_account_id    INT            NOT NULL
                         REFERENCES account (account_id)
                         ON DELETE RESTRICT,
    amount           NUMERIC(12, 2) NOT NULL
                         CHECK (amount > 0),
    status           VARCHAR(20)    NOT NULL DEFAULT 'COMPLETED'
                         CHECK (status IN ('COMPLETED', 'FAILED', 'REVERSED')),
    created_at       TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_different_accounts
        CHECK (from_account_id <> to_account_id)
);

CREATE INDEX idx_account_customer ON account (customer_id);
CREATE INDEX idx_transfer_from ON transfer (from_account_id);
CREATE INDEX idx_transfer_to ON transfer (to_account_id);

COMMENT ON TABLE customer IS 'UniPay student profile';
COMMENT ON TABLE account IS 'One campus wallet per student';
COMMENT ON TABLE transfer IS 'Money movement between two wallets';