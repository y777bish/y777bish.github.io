import '../../domain/ports/barcode_lookup_port.dart';
import '../../domain/ports/fridge_repository_port.dart';
import '../../domain/value_objects/quantity.dart';

class ScanBarcodeAndAddToFridge {
  const ScanBarcodeAndAddToFridge({
    required BarcodeLookupPort barcodeLookupPort,
    required FridgeRepositoryPort fridgeRepositoryPort,
  })  : _barcodeLookupPort = barcodeLookupPort,
        _fridgeRepositoryPort = fridgeRepositoryPort;

  final BarcodeLookupPort _barcodeLookupPort;
  final FridgeRepositoryPort _fridgeRepositoryPort;

  Future<void> execute({
    required String barcode,
    required Quantity quantity,
  }) async {
    final item = await _barcodeLookupPort.lookupAndNormalize(
      barcode: barcode,
      quantity: quantity,
    );
    await _fridgeRepositoryPort.addItem(item);
  }
}
