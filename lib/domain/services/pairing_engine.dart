import '../entities/pairing_rule.dart';

class PairingEngine {
  const PairingEngine();

  double calculateScore({
    required Set<String> ingredientIds,
    required List<PairingRule> rules,
  }) {
    if (ingredientIds.length < 2 || rules.isEmpty) {
      return 0;
    }

    var total = 0.0;
    var matched = 0;

    for (final rule in rules) {
      final hasA = ingredientIds.contains(rule.ingredientAId);
      final hasB = ingredientIds.contains(rule.ingredientBId);
      if (hasA && hasB) {
        total += rule.score;
        matched++;
      }
    }

    if (matched == 0) {
      return 0;
    }

    return total / matched;
  }
}
