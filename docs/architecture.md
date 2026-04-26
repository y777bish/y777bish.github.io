# WhatTheFridge Architecture (DDD + Hexagonal)

## Layers

- `domain`: core business rules, entities, value objects, ports, domain services
- `application`: use cases orchestrating domain and ports
- `infrastructure`: adapters for SQLite/Drift, API, barcode scanner, repositories
- `presentation`: Flutter UI (screens, state, widgets)

## Core flow

1. User scans barcode in presentation layer.
2. Application use case calls `BarcodeLookupPort`.
3. Application stores normalized item through `FridgeRepositoryPort`.
4. User asks for dish suggestions.
5. Suggestion use case loads fridge items + pairing rules and computes ranked dishes.

## Suggested package stack

- Data: `drift` (SQLite), `sqlite3_flutter_libs`
- HTTP: `dio` + OpenAPI generated client
- State management: `riverpod`
- Barcode scanning: `mobile_scanner`

## Notes

- Keep domain pure (no Flutter imports, no DB imports).
- Keep SQL queries and API DTO mapping in infrastructure only.
- Add a cache/seed step to load pairing rules on first app launch.
