class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    this.category,
  });

  final String id;
  final String name;
  final String? category;
}
