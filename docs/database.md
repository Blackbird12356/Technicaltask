# Схема базы данных

СУБД: **SQLite** (файл `data/trades.db`) — простой запуск без отдельного сервера.  
ORM: SQLAlchemy. Схема также в `sql/schema.sql`.

## ER (логический)

```mermaid
erDiagram
    exchanges ||--o{ trades : has
    products ||--o{ trades : "traded as"
    participants ||--o{ trades : "seller"
    participants ||--o{ trades : "buyer"
    brokers ||--o{ trades : "seller_broker"
    brokers ||--o{ trades : "buyer_broker"
    parse_runs ||--o{ trades : "optional source run"

    exchanges {
        int id PK
        string code UK
        string name
    }
    products {
        int id PK
        string name
        string product_code
        string tnved_code
        string name_norm
    }
    participants {
        int id PK
        string name
        string bin UK_null
        string name_norm
    }
    brokers {
        int id PK
        string name
        string name_norm UK
    }
    trades {
        int id PK
        string dedup_key UK
        int exchange_id FK
        date trade_date
        time trade_time
        int product_id FK
        int seller_id FK
        int buyer_id FK
        int seller_broker_id FK
        int buyer_broker_id FK
        decimal volume
        string unit
        decimal price
        string price_vat
        decimal amount
        string delivery_place
        string delivery_term
        string source_url
        string raw_hash
        datetime created_at
    }
    parse_runs {
        int id PK
        string source
        datetime started_at
        datetime finished_at
        string mode
        string status
        int records_added
        int records_seen
        text error_text
    }
```

## Таблицы

### `exchanges`
Справочник бирж. Сиды: `ETS`, `CASPIAN` (отображение «Каспий»).

### `products`
Товар: наименование, код биржи (если есть), ТНВЭД.  
`name_norm` — нижний регистр + сжатые пробелы для поиска.

### `participants`
Продавцы/покупатели. Уникальность по `bin`, если БИН известен; иначе по `name_norm`.

### `brokers`
Брокеры по нормализованному имени.

### `trades`
Факт сделки (или агрегированной строки итогов, как на источнике).

| Поле | Тип | Описание |
|---|---|---|
| `dedup_key` | TEXT UNIQUE | SHA-256 ключевых полей — идемпотентность |
| `trade_date` | DATE | Дата торгов |
| `trade_time` | TIME NULL | На обоих источниках отсутствует |
| `volume` / `unit` | REAL / TEXT | Объём; часто расчётный |
| `price` | REAL | Цена за единицу (средневзвешенная) |
| `price_vat` | TEXT NULL | `with_vat` / `without_vat` / NULL |
| `amount` | REAL | Сумма сделки, тенге |
| `delivery_place` | TEXT | Базис + место |
| `delivery_term` | TEXT | Срок поставки (обычно NULL) |
| `source_url` | TEXT | URL файла/страницы |
| `deals_count` | INT | Кол-во сделок в строке источника |

**Индексы:** `trade_date`, `exchange_id`, `product_id`, `seller_id`, `buyer_id`, `seller_broker_id`, `buyer_broker_id`, `amount`, `delivery_place`.

### `parse_runs`
Журнал запусков парсеров: источник (`ets` / `caspian` / `all`), режим (`incremental` / `full`), статус (`success` / `partial` / `fail`), счётчики, текст ошибки.

## Дедупликация

`dedup_key = sha256(exchange|date|product_code|product_name|tnved|seller_bin|seller_name|buyer_bin|buyer_name|seller_broker|buyer_broker|volume|price|amount|delivery_place|deals_count)`

Повторный insert с тем же ключом игнорируется (UPSERT / `INSERT OR IGNORE`).
