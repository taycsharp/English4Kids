class VocabularyWord {
  const VocabularyWord({
    required this.id,
    required this.word,
    required this.meaningVi,
    required this.emoji,
    required this.topic,
    required this.simpleSentence,
    required this.difficulty,
    this.learned = false,
    this.pronunciationScore = 0,
  });

  final String id;
  final String word;
  final String meaningVi;
  final String emoji;
  final String topic;
  final String simpleSentence;
  final int difficulty;
  final bool learned;
  final int pronunciationScore;

  VocabularyWord copyWith({bool? learned, int? pronunciationScore}) {
    return VocabularyWord(
      id: id,
      word: word,
      meaningVi: meaningVi,
      emoji: emoji,
      topic: topic,
      simpleSentence: simpleSentence,
      difficulty: difficulty,
      learned: learned ?? this.learned,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
    );
  }
}
