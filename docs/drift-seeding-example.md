# Drift seeding example

Use the seeder once after opening your local database.

```dart
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:your_app/infrastructure/datasources/drift_pairings_seeder.dart';

Future<void> bootstrapSeeds(AppDatabase database) async {
  WidgetsFlutterBinding.ensureInitialized();

  final seeder = DriftPairingsSeeder(
    database: database,
    assetBundle: rootBundle,
  );

  await seeder.seedIfEmpty();
}
```

If you need to re-import data (for updated CSV), run:

```dart
await seeder.seed(forceReplace: true);
```
