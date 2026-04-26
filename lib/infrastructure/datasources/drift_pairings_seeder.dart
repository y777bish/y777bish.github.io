import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

class DriftPairingsSeeder {
  DriftPairingsSeeder({
    required DatabaseConnectionUser database,
    required AssetBundle assetBundle,
    this.assetPath = 'assets/seeds/pairings_normalized.csv',
  })  : _database = database,
        _assetBundle = assetBundle;

  final DatabaseConnectionUser _database;
  final AssetBundle _assetBundle;
  final String assetPath;

  Future<void> seedIfEmpty() async {
    final existing = await _database.customSelect(
      'SELECT COUNT(1) AS count FROM pairings',
    ).getSingle();

    final count = existing.read<int>('count');
    if (count > 0) {
      return;
    }

    await seed(forceReplace: false);
  }

  Future<void> seed({bool forceReplace = true}) async {
    final csvContent = await _assetBundle.loadString(assetPath);
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(csvContent);

    if (rows.length < 2) {
      return;
    }

    await _database.transaction(() async {
      for (final row in rows.skip(1)) {
        final aName = _cell(row, 1);
        final bName = _cell(row, 3);

        var aId = _slugify(_cell(row, 0));
        var bId = _slugify(_cell(row, 2));

        if (aId.isEmpty) {
          aId = _slugify(aName);
        }
        if (bId.isEmpty) {
          bId = _slugify(bName);
        }
        if (aId.isEmpty || bId.isEmpty || aId == bId) {
          continue;
        }

        final canonicalPair = _canonicalizePair(
          aId: aId,
          aName: aName,
          bId: bId,
          bName: bName,
        );

        final score = _parseScore(
          scoreRaw: _cell(row, 5),
          strengthRaw: _cell(row, 4),
        );
        final notes = _nullable(_cell(row, 6));
        final source = _cell(row, 7).isEmpty ? 'unknown' : _cell(row, 7);
        final cuisine = _nullable(_cell(row, 8));
        final pairingId =
            'pairing:${canonicalPair.aId}:${canonicalPair.bId}';

        await _database.customStatement(
          '''
          INSERT OR IGNORE INTO ingredients (id, canonical_name)
          VALUES (?, ?)
          ''',
          [canonicalPair.aId, canonicalPair.aName],
        );

        await _database.customStatement(
          '''
          INSERT OR IGNORE INTO ingredients (id, canonical_name)
          VALUES (?, ?)
          ''',
          [canonicalPair.bId, canonicalPair.bName],
        );

        final insertMode = forceReplace ? 'INSERT OR REPLACE' : 'INSERT OR IGNORE';
        await _database.customStatement(
          '''
          $insertMode INTO pairings (
            id,
            ingredient_a_id,
            ingredient_b_id,
            score,
            confidence,
            notes,
            source,
            cuisine
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
          ''',
          [
            pairingId,
            canonicalPair.aId,
            canonicalPair.bId,
            score,
            0.85,
            notes,
            source,
            cuisine,
          ],
        );
      }
    });
  }

  String _cell(List<dynamic> row, int index) {
    if (index >= row.length) {
      return '';
    }
    return row[index].toString().trim();
  }

  String? _nullable(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  double _parseScore({
    required String scoreRaw,
    required String strengthRaw,
  }) {
    final parsed = double.tryParse(scoreRaw);
    if (parsed != null) {
      return parsed.clamp(0, 1);
    }

    switch (strengthRaw.toLowerCase()) {
      case 'high':
        return 0.90;
      case 'medium':
        return 0.70;
      case 'low':
        return 0.50;
      default:
        return 0.60;
    }
  }

  String _slugify(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) {
      return '';
    }

    final replaced = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return replaced.replaceAll(RegExp(r'^_+|_+$'), '');
  }

  _CanonicalPair _canonicalizePair({
    required String aId,
    required String aName,
    required String bId,
    required String bName,
  }) {
    if (aId.compareTo(bId) <= 0) {
      return _CanonicalPair(
        aId: aId,
        aName: aName,
        bId: bId,
        bName: bName,
      );
    }

    return _CanonicalPair(
      aId: bId,
      aName: bName,
      bId: aId,
      bName: aName,
    );
  }
}

class _CanonicalPair {
  const _CanonicalPair({
    required this.aId,
    required this.aName,
    required this.bId,
    required this.bName,
  });

  final String aId;
  final String aName;
  final String bId;
  final String bName;
}
