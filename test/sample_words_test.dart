import 'package:flutter_test/flutter_test.dart';
import 'package:happy_english_kids/data/sample_words.dart';

void main() {
  group('sample vocabulary content', () {
    test('keeps the expected topics with at least 20 words each', () {
      expect(
        sampleTopics.map((topic) => topic.name),
        orderedEquals(const [
          'Animals',
          'Colors',
          'Vehicles',
          'Food',
          'Nature',
          'Family',
          'Numbers',
          'Body Parts',
          'Classroom',
          'Toys',
          'Clothes',
          'Actions',
        ]),
      );

      for (final topic in sampleTopics) {
        expect(topic.words.length, greaterThanOrEqualTo(20), reason: topic.name);
      }
    });

    test('provides complete child-friendly word data', () {
      final ids = <String>{};

      for (final word in allWords) {
        expect(word.id, isNotEmpty);
        expect(ids.add(word.id), isTrue, reason: 'Duplicate id: ${word.id}');
        expect(word.word, isNotEmpty);
        expect(word.meaningVi, isNotEmpty);
        expect(word.emoji, isNotEmpty);
        expect(word.topic, isNotEmpty);
        expect(word.simpleSentence, isNotEmpty);
        expect(word.difficulty, inInclusiveRange(1, 3));
      }
    });
  });
}
