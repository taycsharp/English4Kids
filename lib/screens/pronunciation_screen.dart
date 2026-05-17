import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../widgets/reward_dialog.dart';
import '../widgets/word_card.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  int index = 0;
  String heard = '';
  String feedback = 'Tap Listen. Then tap Speak!';
  bool listening = false;

  Future<void> _speak() async {
    final scope = AppScope.of(context);
    final word = allWords[index];
    setState(() {
      listening = true;
      feedback = 'I am listening...';
    });
    final text = await scope.speechService.listenOnce();
    final ok = scope.speechService.matchesWord(text, word.word);
    await scope.progressService.addPronunciationAttempt(word.id, ok);
    if (!mounted) return;
    setState(() {
      listening = false;
      heard = text;
      feedback = ok ? 'Great job! ⭐' : 'Good try! Say it again.';
    });
    if (ok) {
      await RewardDialog.show(context, 'Good speaking! ⭐');
      if (mounted && index < allWords.length - 1) setState(() => index++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = allWords[index];
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Say the Word')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Expanded(child: Center(child: WordCard(word: word))),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Text(feedback, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
              if (heard.isNotEmpty) Text('I heard: $heard', style: const TextStyle(fontSize: 18, color: Colors.black54)),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: FilledButton.icon(onPressed: () => scope.ttsService.speak(word.word), icon: const Icon(Icons.volume_up_rounded), label: const Text('Listen'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton.tonalIcon(onPressed: listening ? null : _speak, icon: const Icon(Icons.mic_rounded), label: const Text('Speak'))),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => setState(() => index = (index + 1) % allWords.length), child: const Text('Next'))),
        ]),
      ),
    );
  }
}
