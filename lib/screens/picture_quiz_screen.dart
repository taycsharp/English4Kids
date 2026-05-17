import 'dart:math';

import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../models/vocabulary_word.dart';
import '../widgets/reward_dialog.dart';

class PictureQuizScreen extends StatefulWidget {
  const PictureQuizScreen({super.key});

  @override
  State<PictureQuizScreen> createState() => _PictureQuizScreenState();
}

class _PictureQuizScreenState extends State<PictureQuizScreen> {
  final random = Random();
  late VocabularyWord target;
  late List<VocabularyWord> choices;
  String message = 'What is this?';

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    target = allWords[random.nextInt(allWords.length)];
    final pool = allWords.where((w) => w.id != target.id).toList()..shuffle(random);
    choices = ([target] + pool.take(3).toList())..shuffle(random);
    message = 'What is this?';
  }

  Future<void> _answer(VocabularyWord word) async {
    final ok = word.id == target.id;
    if (ok) {
      await AppScope.of(context).progressService.addStars(2, topic: target.topic);
      if (!mounted) return;
      await RewardDialog.show(context, 'Great job! ⭐');
      if (mounted) setState(_newQuestion);
    } else {
      setState(() => message = 'Try again! You can do it.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text(message, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(34)),
            child: Text(target.emoji, textAlign: TextAlign.center, style: const TextStyle(fontSize: 120)),
          ),
          const SizedBox(height: 18),
          ...choices.map((word) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(width: double.infinity, height: 62, child: FilledButton.tonal(onPressed: () => _answer(word), child: Text(word.word, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)))),
          )),
        ]),
      ),
    );
  }
}
