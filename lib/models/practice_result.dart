class PracticeResult {
  const PracticeResult({
    required this.wordId,
    required this.correct,
    required this.heardText,
    required this.createdAt,
  });

  final String wordId;
  final bool correct;
  final String heardText;
  final DateTime createdAt;
}
