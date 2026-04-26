class PairingRule {
  const PairingRule({
    required this.ingredientAId,
    required this.ingredientBId,
    required this.score,
    this.reason,
  }) : assert(score >= 0 && score <= 1, 'Pairing score must be in range 0..1');

  final String ingredientAId;
  final String ingredientBId;
  final double score;
  final String? reason;
}
