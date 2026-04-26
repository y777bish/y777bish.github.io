import '../../domain/entities/fridge_item.dart';
import '../../domain/ports/barcode_lookup_port.dart';
import '../../domain/value_objects/quantity.dart';

class MockBarcodeLookupAdapter implements BarcodeLookupPort {
  @override
  Future<FridgeItem> lookupAndNormalize({
    required String barcode,
    required Quantity quantity,
  }) async {
    // Replace with OpenFoodFacts or your own backend adapter.
    return FridgeItem(
      id: 'fridge-${DateTime.now().microsecondsSinceEpoch}',
      ingredientId: 'ingredient-tomato',
      productName: 'Tomato',
      quantity: quantity,
      barcode: barcode,
      addedAt: DateTime.now(),
    );
  }
}
