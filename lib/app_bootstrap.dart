import 'application/use_cases/scan_barcode_and_add_to_fridge.dart';
import 'application/use_cases/suggest_dishes_from_fridge.dart';
import 'domain/entities/pairing_rule.dart';
import 'domain/services/dish_composer.dart';
import 'domain/services/pairing_engine.dart';
import 'infrastructure/adapters/mock_barcode_lookup_adapter.dart';
import 'infrastructure/repositories/in_memory_fridge_repository.dart';
import 'infrastructure/repositories/in_memory_pairing_repository.dart';

class AppBootstrap {
  AppBootstrap._();

  static (
    ScanBarcodeAndAddToFridge scanBarcodeAndAddToFridge,
    SuggestDishesFromFridge suggestDishesFromFridge
  ) build() {
    final fridgeRepository = InMemoryFridgeRepository();
    final pairingRepository = InMemoryPairingRepository(const [
      PairingRule(
        ingredientAId: 'ingredient-tomato',
        ingredientBId: 'ingredient-basil',
        score: 0.95,
        reason: 'Classic pairing.',
      ),
      PairingRule(
        ingredientAId: 'ingredient-tomato',
        ingredientBId: 'ingredient-mozzarella',
        score: 0.96,
        reason: 'Fresh and balanced.',
      ),
    ]);
    final barcodeLookup = MockBarcodeLookupAdapter();
    const pairingEngine = PairingEngine();
    const dishComposer = DishComposer();

    final scanUseCase = ScanBarcodeAndAddToFridge(
      barcodeLookupPort: barcodeLookup,
      fridgeRepositoryPort: fridgeRepository,
    );

    final suggestUseCase = SuggestDishesFromFridge(
      fridgeRepositoryPort: fridgeRepository,
      pairingRepositoryPort: pairingRepository,
      pairingEngine: pairingEngine,
      dishComposer: dishComposer,
    );

    return (scanUseCase, suggestUseCase);
  }
}
