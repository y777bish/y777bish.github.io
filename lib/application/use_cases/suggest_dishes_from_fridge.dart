import '../../domain/entities/dish_suggestion.dart';
import '../../domain/ports/fridge_repository_port.dart';
import '../../domain/ports/pairing_repository_port.dart';
import '../../domain/services/dish_composer.dart';
import '../../domain/services/pairing_engine.dart';
import '../dto/suggestion_query.dart';

class SuggestDishesFromFridge {
  const SuggestDishesFromFridge({
    required FridgeRepositoryPort fridgeRepositoryPort,
    required PairingRepositoryPort pairingRepositoryPort,
    required PairingEngine pairingEngine,
    required DishComposer dishComposer,
  })  : _fridgeRepositoryPort = fridgeRepositoryPort,
        _pairingRepositoryPort = pairingRepositoryPort,
        _pairingEngine = pairingEngine,
        _dishComposer = dishComposer;

  final FridgeRepositoryPort _fridgeRepositoryPort;
  final PairingRepositoryPort _pairingRepositoryPort;
  final PairingEngine _pairingEngine;
  final DishComposer _dishComposer;

  Future<List<DishSuggestion>> execute(SuggestionQuery query) async {
    final fridgeItems = await _fridgeRepositoryPort.getAllItems();
    final ingredientIds = fridgeItems.map((item) => item.ingredientId).toSet();

    final rules = await _pairingRepositoryPort.findByIngredientIds(ingredientIds);
    final score = _pairingEngine.calculateScore(
      ingredientIds: ingredientIds,
      rules: rules,
    );

    return _dishComposer.composeSuggestions(
      pairingScore: score,
      ingredientIds: ingredientIds,
      limit: query.limit,
    );
  }
}
