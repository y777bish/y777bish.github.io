import 'unit.dart';

class Quantity {
  const Quantity({
    required this.value,
    required this.unit,
  }) : assert(value >= 0, 'Quantity value cannot be negative.');

  final double value;
  final Unit unit;
}
