import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../models/progress_data.dart';
import '../widgets/reward_dialog.dart';

class SentencePracticeScreen extends StatefulWidget {
  const SentencePracticeScreen({super.key});

  @override
  State<SentencePracticeScreen> createState() => _SentencePracticeScreenState();
}

class _SentencePracticeScreenState extends State<SentencePracticeScreen> {
  int index = 0;
  String heard = '';
  String message = 'Listen. Then say it!';
  bool listening = false;

  List<String> _keywords(String sentence) {
    return sentence.toLowerCase().replaceAll('.', '').split(' ').where((w) => w.length > 2 && !['the', 'this', 'can', 'see'].contains(w)).toList();
  }

  Future<void> _practice() async {
    debugPrint('[SentencePracticeScreen] Speak button tapped');
    final scope = AppScope.of(context);
    final word = allWords[index];
    setState(() {
      listening = true;
      message = 'I am listening...';
    });
    final previous = await scope.progressService.loadProgress();
    final text = await scope.speechService.listenOnce(timeout: const Duration(seconds: 6));
    await scope.speechService.stopListening();

    final ok = scope.speechService.sentenceContainsKeywords(text, _keywords(word.simpleSentence));
    final feedbackText = ok ? 'Super speaking! ⭐' : 'Good try! Say it slowly.';
    debugPrint('[SentencePracticeScreen] feedback text created: $feedbackText');
    final updated = await scope.progressService.addPronunciationAttempt(word.id, ok);

    if (!mounted) return;
    setState(() {
      listening = false;
      heard = text;
      message = feedbackText;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[SentencePracticeScreen] before calling speakFeedback: $feedbackText');
    await scope.ttsService.speakFeedback(feedbackText);
    debugPrint('[SentencePracticeScreen] after calling speakFeedback');

    if (ok) {
      await scope.soundEffectService.playCorrect();
      if (!mounted) return;
      final levelUp = ProgressData.levelChanged(previous.totalStars, updated.totalStars);
      await RewardDialog.show(context, levelUp ? 'Super speaking!\n${updated.levelName}!' : 'Super speaking!', levelUp: levelUp);
      if (mounted) setState(() => index = (index + 1) % allWords.length);
    } else {
      await scope.soundEffectService.playTryAgain();
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = allWords[index];
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sentence Practice')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text('Say the sentence', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(34), boxShadow: const [BoxShadow(blurRadius: 18, color: Color(0x18000000), offset: Offset(0, 8))]),
            child: Column(children: [
              Text(word.emoji, style: const TextStyle(fontSize: 90)),
              Text(word.simpleSentence, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            ]),
          ),
          const SizedBox(height: 18),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
          if (heard.isNotEmpty) Text('I heard: $heard', style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const Spacer(),
          Row(children: [
            Expanded(child: FilledButton.icon(onPressed: () => scope.ttsService.speak(word.simpleSentence), icon: const Icon(Icons.volume_up_rounded), label: const Text('Listen'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton.tonalIcon(onPressed: listening ? null : _practice, icon: const Icon(Icons.mic_rounded), label: const Text('Speak'))),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () { scope.soundEffectService.playTap(); setState(() => index = (index + 1) % allWords.length); }, child: const Text('Next'))),
        ]),
      ),
    );
  }
}
