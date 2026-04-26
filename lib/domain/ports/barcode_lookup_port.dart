import '../entities/fridge_item.dart';
import '../value_objects/quantity.dart';

abstract class BarcodeLookupPort {
  Future<FridgeItem> lookupAndNormalize({
    required String barcode,
    required Quantity quantity,
  });
}
