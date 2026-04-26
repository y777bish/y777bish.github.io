# WhatTheFridge

Starter structure for Flutter app using Domain-Driven Design and Hexagonal Architecture.

## Current state

- OpenAPI contract in `openapi.yaml`
- Architecture notes in `docs/architecture.md`
- Core domain/application/infrastructure skeleton in `lib/`

## Project structure

- `lib/domain`: entities, value objects, ports, domain services
- `lib/application`: use cases and DTOs
- `lib/infrastructure`: repository and adapter implementations
- `lib/presentation`: place for Flutter UI and state management

## Next steps

1. Initialize Flutter app if not initialized yet:
   - `flutter create .`
2. Add dependencies:
   - `flutter pub add drift sqlite3_flutter_libs riverpod dio mobile_scanner csv`
   - `flutter pub add --dev drift_dev build_runner`
3. Register seed asset in `pubspec.yaml`:
   - `assets/seeds/pairings_normalized.csv`
4. Replace in-memory repositories with Drift-based adapters.
5. Generate OpenAPI client and wire it as infrastructure adapter.
6. Build first screens:
   - Scan barcode
   - Fridge item list
   - Dish suggestions

## Pairings seeding

- Seeder implementation: `lib/infrastructure/datasources/drift_pairings_seeder.dart`
- Seed data: `assets/seeds/pairings_normalized.csv`
- SQL schema: `sql/001_pairings_schema.sql`
