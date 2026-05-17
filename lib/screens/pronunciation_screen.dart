import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../models/progress_data.dart';
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
    debugPrint('[PronunciationScreen] Speak button tapped');
    final scope = AppScope.of(context);
    final word = allWords[index];
    setState(() {
      listening = true;
      feedback = 'I am listening...';
    });
    final previous = await scope.progressService.loadProgress();
    final text = await scope.speechService.listenOnce();
    await scope.speechService.stopListening();

    final ok = scope.speechService.matchesWord(text, word.word);
    final feedbackText = ok ? 'Super speaking! ⭐' : 'Good try! Say it slowly.';
    debugPrint('[PronunciationScreen] feedback text created: $feedbackText');
    final updated = await scope.progressService.addPronunciationAttempt(word.id, ok);

    if (!mounted) return;
    setState(() {
      listening = false;
      heard = text;
      feedback = feedbackText;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[PronunciationScreen] before calling speakFeedback: $feedbackText');
    await scope.ttsService.speakFeedback(feedbackText);
    debugPrint('[PronunciationScreen] after calling speakFeedback');

    if (ok) {
      await scope.soundEffectService.playCorrect();
      if (!mounted) return;
      final levelUp = ProgressData.levelChanged(previous.totalStars, updated.totalStars);
      await RewardDialog.show(context, levelUp ? 'Super speaking!\n${updated.levelName}!' : 'Super speaking!', levelUp: levelUp);
      if (mounted && index < allWords.length - 1) setState(() => index++);
    } else {
      await scope.soundEffectService.playTryAgain();
    }
  }

  Future<void> _replayFeedback() async {
    final scope = AppScope.of(context);
    debugPrint('[PronunciationScreen] before calling speakFeedback: $feedback');
    await scope.ttsService.speakFeedback(feedback);
    debugPrint('[PronunciationScreen] after calling speakFeedback');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(feedback, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900))),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Replay feedback',
                    onPressed: listening ? null : _replayFeedback,
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
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
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () { scope.soundEffectService.playTap(); setState(() => index = (index + 1) % allWords.length); }, child: const Text('Next'))),
        ]),
      ),
    );
  }
}
