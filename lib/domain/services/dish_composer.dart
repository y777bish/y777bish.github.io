import '../entities/dish_suggestion.dart';

class DishComposer {
  const DishComposer();

  List<DishSuggestion> composeSuggestions({
    required double pairingScore,
    required Set<String> ingredientIds,
    required int limit,
  }) {
    if (ingredientIds.isEmpty || limit <= 0) {
      return const [];
    }

    // Initial deterministic seed suggestions for MVP.
    final suggestions = <DishSuggestion>[
      DishSuggestion(
        id: 'dish-001',
        title: 'Quick Fridge Bowl',
        matchScore: pairingScore.clamp(0, 1),
        missingIngredients: const [],
        estimatedTimeMinutes: 15,
      ),
      DishSuggestion(
        id: 'dish-002',
        title: 'Pan Mix with Herbs',
        matchScore: (pairingScore * 0.92).clamp(0, 1),
        missingIngredients: const ['olive oil'],
        estimatedTimeMinutes: 20,
      ),
      DishSuggestion(
        id: 'dish-003',
        title: 'Simple Oven Bake',
        matchScore: (pairingScore * 0.85).clamp(0, 1),
        missingIngredients: const ['salt', 'pepper'],
        estimatedTimeMinutes: 30,
      ),
    ];

    suggestions.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return suggestions.take(limit).toList(growable: false);
  }
}
