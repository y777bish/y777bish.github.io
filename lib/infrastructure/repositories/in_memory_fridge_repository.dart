import '../../domain/entities/fridge_item.dart';
import '../../domain/ports/fridge_repository_port.dart';

class InMemoryFridgeRepository implements FridgeRepositoryPort {
  final List<FridgeItem> _items = [];

  @override
  Future<void> addItem(FridgeItem item) async {
    _items.add(item);
  }

  @override
  Future<List<FridgeItem>> getAllItems() async {
    return List.unmodifiable(_items);
  }
}
