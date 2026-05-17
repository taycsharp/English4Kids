import 'dart:math';

import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../models/progress_data.dart';
import '../models/vocabulary_word.dart';
import '../widgets/reward_dialog.dart';

class ListeningGameScreen extends StatefulWidget {
  const ListeningGameScreen({super.key});

  @override
  State<ListeningGameScreen> createState() => _ListeningGameScreenState();
}

class _ListeningGameScreenState extends State<ListeningGameScreen> {
  final random = Random();
  late VocabularyWord target;
  late List<VocabularyWord> choices;
  String message = 'Listen and choose!';

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    target = allWords[random.nextInt(allWords.length)];
    final pool = allWords.where((w) => w.id != target.id).toList()..shuffle(random);
    choices = ([target] + pool.take(3).toList())..shuffle(random);
    message = 'Listen and choose!';
  }

  Future<void> _answer(VocabularyWord word) async {
    final ok = word.id == target.id;
    final scope = AppScope.of(context);
    if (ok) {
      final previous = await scope.progressService.loadProgress();
      final updated = await scope.progressService.addStars(2, topic: target.topic);
      await scope.soundEffectService.playCorrect();
      if (!mounted) return;
      final levelUp = ProgressData.levelChanged(previous.totalStars, updated.totalStars);
      await RewardDialog.show(context, levelUp ? 'You are amazing!\n${updated.levelName}!' : 'You are amazing!', levelUp: levelUp);
      await scope.soundEffectService.playTap();
      if (mounted) setState(_newQuestion);
    } else {
      await scope.soundEffectService.playTryAgain();
      if (!mounted) return;
      setState(() => message = 'Good try! Listen one more time.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Listening Game')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text(message, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: () => scope.ttsService.speak(target.word), icon: const Icon(Icons.volume_up_rounded), label: const Text('Play Sound')),
          const SizedBox(height: 22),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: choices.map((word) => InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => _answer(word),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x16000000), offset: Offset(0, 6))]),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(word.emoji, style: const TextStyle(fontSize: 62)),
                    Text(word.word, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  ]),
                ),
              )).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
