# TradeResults — итоги торгов ETS и Каспий

Учебный fullstack-MVP производственной практики: парсинг публичных итогов торгов товарных бирж **ETS** и **Каспий (CCX)**, сохранение в локальную БД и веб-портал для просмотра с фильтрами.

Ориентир по идее UX: [qaztrade-insight.kz](https://qaztrade-insight.kz/) (код не копировался).

## Стек (и почему так)

| Слой | Выбор | Обоснование |
|---|---|---|
| API / UI backend | **Python + FastAPI** | Быстрый REST + раздача HTML |
| HTML UI | Jinja2 + vanilla JS | Без лишнего фронтенд-сборщика |
| БД | **SQLite** + SQLAlchemy | Один файл, запуск «из коробки» |
| Парсеры | requests + BeautifulSoup + openpyxl | ETS отдаёт XLSX; Каспий — серверный HTML |
| Планировщик | APScheduler | Ежедневный cron из `config.yaml` |
| Playwright | не используется | JS для извлечения данных не нужен |

Подробный разбор источников: [`docs/sources.md`](docs/sources.md).  
Схема БД: [`docs/database.md`](docs/database.md).

## Требования

- Python 3.11+ (рекомендуется 3.12)
- Доступ в интернет к `ets.kz` и `ccx.kz` (Каспий может быть недоступен с части зарубежных IP)

## Установка

```bash
cd Technicaltask
python -m venv .venv

# Windows PowerShell
.\.venv\Scripts\Activate.ps1

# Linux/macOS
# source .venv/bin/activate

pip install -r requirements.txt
copy .env.example .env   # опционально
python cli.py init-db
```

## Запуск парсеров

Инкрементально (недавний период из `config.yaml`):

```bash
python cli.py parse --source all --mode incremental
```

Только одна биржа:

```bash
python cli.py parse --source ets --mode incremental
python cli.py parse --source caspian --mode incremental
```

Полная / историческая загрузка:

```bash
python cli.py parse --source all --mode full
```

Диапазон дат:

```bash
python cli.py parse --source all --mode full --date-from 2026-10-01 --date-to 2026-10-23
```

Повторный запуск **не создаёт дубли** (`dedup_key` + проверка перед insert).  
Журнал запусков пишется в таблицу `parse_runs` и в `logs/app.log`.

## Запуск портала

```bash
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

Откройте http://127.0.0.1:8000/

- `/` — таблица сделок, фильтры (AJAX без reload), сортировка, пагинация  
- `/status` — свежесть данных, счётчики, журнал парсеров, кнопка ручного запуска  

Портал **не обращается** к сайтам бирж при действиях пользователя (кроме явного `POST /api/parse` на странице статуса).

## Расписание

В `config.yaml`:

```yaml
scheduler:
  enabled: true
  cron: "30 6 * * *"      # ежедневно 06:30
  timezone: "Asia/Almaty"
```

Переопределение: `SCHEDULER_ENABLED`, `SCHEDULER_CRON` в `.env`.  
Планировщик стартует вместе с uvicorn.

## Переменные окружения

См. `.env.example`. Основные:

| Переменная | Назначение |
|---|---|
| `DATABASE_URL` | По умолчанию `sqlite:///data/trades.db` |
| `REQUEST_DELAY_SEC` | Пауза между HTTP-запросами парсера |
| `SCHEDULER_ENABLED` | Вкл/выкл автозапуск |
| `HOST` / `PORT` | Для справки; uvicorn задаётся в CLI |

## Структура репозитория

```
app/           # FastAPI, парсеры, БД, UI
cli.py         # init-db / parse
config.yaml    # расписание и параметры источников
sql/schema.sql # схема + сиды бирж
docs/          # sources.md, database.md
data/          # SQLite (создаётся при запуске)
logs/          # логи
```

## Дамп / схема

- Схема: `sql/schema.sql`
- Рабочая БД после парсинга: `data/trades.db`
- Пример дампа: `sql/sample_dump.sql` (создаётся скриптом экспорта после первой загрузки)

Экспорт дампа:

```bash
python -c "import sqlite3, pathlib; p=pathlib.Path('data/trades.db'); print('no db') if not p.exists() else open('sql/sample_dump.sql','w',encoding='utf-8').write('\n'.join(sqlite3.connect(p).iterdump()))"
```

## Быстрая проверка «чистый запуск»

1. `pip install -r requirements.txt`
2. `python cli.py init-db`
3. `python cli.py parse --source all --mode incremental --date-from 2026-10-13 --date-to 2026-10-23`
4. `uvicorn app.main:app --port 8000`
5. Открыть `/` и `/status`, убедиться что сделки видны и повторный `parse` не увеличивает число дублей.
