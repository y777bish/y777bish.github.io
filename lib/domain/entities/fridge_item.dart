import '../value_objects/quantity.dart';

class FridgeItem {
  const FridgeItem({
    required this.id,
    required this.ingredientId,
    required this.productName,
    required this.quantity,
    this.barcode,
    required this.addedAt,
  });

  final String id;
  final String ingredientId;
  final String productName;
  final Quantity quantity;
  final String? barcode;
  final DateTime addedAt;
}
