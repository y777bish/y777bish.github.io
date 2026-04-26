import '../entities/fridge_item.dart';

abstract class FridgeRepositoryPort {
  Future<void> addItem(FridgeItem item);
  Future<List<FridgeItem>> getAllItems();
}
