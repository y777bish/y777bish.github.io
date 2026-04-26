import '../../domain/entities/pairing_rule.dart';
import '../../domain/ports/pairing_repository_port.dart';

class InMemoryPairingRepository implements PairingRepositoryPort {
  InMemoryPairingRepository(this._rules);

  final List<PairingRule> _rules;

  @override
  Future<List<PairingRule>> findByIngredientIds(Set<String> ingredientIds) async {
    return _rules
        .where(
          (rule) =>
              ingredientIds.contains(rule.ingredientAId) ||
              ingredientIds.contains(rule.ingredientBId),
        )
        .toList(growable: false);
  }
}
