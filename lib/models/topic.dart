import 'vocabulary_word.dart';

class Topic {
  const Topic({
    required this.id,
    required this.name,
    required this.emoji,
    required this.words,
  });

  final String id;
  final String name;
  final String emoji;
  final List<VocabularyWord> words;

  int get wordCount => words.length;
}
