# Pairings data model for SQLite

## Why SQLite here

- Mobile-first app (iOS + Android) needs local embedded storage.
- SQLite is built for this use case and avoids running a DB server on device.
- You can still add a backend with PostgreSQL later for sync, but local app logic should use SQLite.

## Data format from your book

Your `pairings.csv` is good input. For stable ingestion, normalize into:

- `ingredient_a_id` / `ingredient_b_id` as slugs (e.g. `blue_cheese`)
- `ingredient_a_name` / `ingredient_b_name` as display names
- `strength` mapped to numeric `score`

Current mapping:

- `high -> 0.90`
- `medium -> 0.70`
- `low -> 0.50` (reserved for future rows)

## Canonical pair ordering

Always store pairs in canonical order:

1. compare IDs alphabetically
2. smaller ID is `ingredient_a_id`
3. larger ID is `ingredient_b_id`

This prevents duplicate rows like `(tomato, basil)` and `(basil, tomato)`.

## Import sequence

1. Run schema from `sql/001_pairings_schema.sql`.
2. Load unique ingredients from `data/pairings_normalized.csv`.
3. Insert pairings, generating a deterministic pairing ID:
   - `pairing:{ingredient_a_id}:{ingredient_b_id}`
4. Use `INSERT OR IGNORE` to make import idempotent.

## Suggested SQL import template

```sql
-- Example for one row
INSERT OR IGNORE INTO ingredients (id, canonical_name)
VALUES ('tomato', 'Tomato');

INSERT OR IGNORE INTO ingredients (id, canonical_name)
VALUES ('basil', 'Basil');

INSERT OR REPLACE INTO pairings (
  id,
  ingredient_a_id,
  ingredient_b_id,
  score,
  confidence,
  notes,
  source,
  cuisine
) VALUES (
  'pairing:basil:tomato',
  'basil',
  'tomato',
  0.90,
  0.85,
  'Bright herbal notes lift the acidity of the tomato.',
  'The Flavour Thesaurus',
  'Mediterranean'
);
```

## Next implementation step in Flutter

- Keep this CSV in `assets/seeds/`.
- On first app launch:
  - parse CSV
  - normalize order and IDs
  - bulk insert inside one Drift transaction
- Query pairings by fridge ingredient IDs and rank suggestions in domain service.
