class DishSuggestion {
  const DishSuggestion({
    required this.id,
    required this.title,
    required this.matchScore,
    required this.missingIngredients,
    required this.estimatedTimeMinutes,
  });

  final String id;
  final String title;
  final double matchScore;
  final List<String> missingIngredients;
  final int estimatedTimeMinutes;
}
