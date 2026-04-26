PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS ingredients (
  id TEXT PRIMARY KEY,
  canonical_name TEXT NOT NULL UNIQUE,
  category TEXT,
  aliases_json TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS pairings (
  id TEXT PRIMARY KEY,
  ingredient_a_id TEXT NOT NULL,
  ingredient_b_id TEXT NOT NULL,
  score REAL NOT NULL CHECK (score >= 0 AND score <= 1),
  confidence REAL NOT NULL DEFAULT 0.8 CHECK (confidence >= 0 AND confidence <= 1),
  notes TEXT,
  source TEXT NOT NULL,
  cuisine TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ingredient_a_id) REFERENCES ingredients(id),
  FOREIGN KEY (ingredient_b_id) REFERENCES ingredients(id),
  CHECK (ingredient_a_id <> ingredient_b_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_pairings_pair
ON pairings (ingredient_a_id, ingredient_b_id);

CREATE INDEX IF NOT EXISTS idx_pairings_a
ON pairings (ingredient_a_id);

CREATE INDEX IF NOT EXISTS idx_pairings_b
ON pairings (ingredient_b_id);

CREATE INDEX IF NOT EXISTS idx_pairings_score
ON pairings (score DESC);
