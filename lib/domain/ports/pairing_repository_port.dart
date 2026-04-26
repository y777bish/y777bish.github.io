import '../entities/pairing_rule.dart';

abstract class PairingRepositoryPort {
  Future<List<PairingRule>> findByIngredientIds(Set<String> ingredientIds);
}
