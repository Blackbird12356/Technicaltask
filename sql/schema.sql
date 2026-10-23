-- Схема БД портала итогов торгов ETS + Каспий (SQLite)

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS exchanges (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    code        TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT NOT NULL,
    product_code  TEXT,
    tnved_code    TEXT,
    name_norm     TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS participants (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    bin        TEXT,
    name_norm  TEXT NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_participants_bin
    ON participants(bin) WHERE bin IS NOT NULL AND bin != '';

CREATE TABLE IF NOT EXISTS brokers (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    name_norm  TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS trades (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    dedup_key         TEXT NOT NULL UNIQUE,
    exchange_id       INTEGER NOT NULL REFERENCES exchanges(id),
    trade_date        DATE NOT NULL,
    trade_time        TEXT,
    product_id        INTEGER REFERENCES products(id),
    seller_id         INTEGER REFERENCES participants(id),
    buyer_id          INTEGER REFERENCES participants(id),
    seller_broker_id  INTEGER REFERENCES brokers(id),
    buyer_broker_id   INTEGER REFERENCES brokers(id),
    volume            REAL,
    unit              TEXT,
    price             REAL,
    price_vat         TEXT,
    amount            REAL,
    delivery_place    TEXT,
    delivery_term     TEXT,
    deals_count       INTEGER,
    source_url        TEXT,
    raw_hash          TEXT,
    created_at        TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS ix_trades_date ON trades(trade_date);
CREATE INDEX IF NOT EXISTS ix_trades_exchange ON trades(exchange_id);
CREATE INDEX IF NOT EXISTS ix_trades_product ON trades(product_id);
CREATE INDEX IF NOT EXISTS ix_trades_seller ON trades(seller_id);
CREATE INDEX IF NOT EXISTS ix_trades_buyer ON trades(buyer_id);
CREATE INDEX IF NOT EXISTS ix_trades_seller_broker ON trades(seller_broker_id);
CREATE INDEX IF NOT EXISTS ix_trades_buyer_broker ON trades(buyer_broker_id);
CREATE INDEX IF NOT EXISTS ix_trades_amount ON trades(amount);
CREATE INDEX IF NOT EXISTS ix_trades_delivery ON trades(delivery_place);

CREATE TABLE IF NOT EXISTS parse_runs (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    source         TEXT NOT NULL,
    started_at     TEXT NOT NULL,
    finished_at    TEXT,
    mode           TEXT NOT NULL,
    status         TEXT NOT NULL,
    records_added  INTEGER NOT NULL DEFAULT 0,
    records_seen   INTEGER NOT NULL DEFAULT 0,
    error_text     TEXT
);

CREATE INDEX IF NOT EXISTS ix_parse_runs_started ON parse_runs(started_at);

INSERT OR IGNORE INTO exchanges (id, code, name) VALUES
    (1, 'ETS', 'ETS'),
    (2, 'CASPIAN', 'Каспий');
