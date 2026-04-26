class SuggestionQuery {
  const SuggestionQuery({
    this.limit = 10,
    this.maxPreparationTimeMinutes,
    this.servings,
    this.dietaryTag,
    this.cuisineHint,
  });

  final int limit;
  final int? maxPreparationTimeMinutes;
  final int? servings;
  final String? dietaryTag;
  final String? cuisineHint;
}
