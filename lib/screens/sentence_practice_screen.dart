import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
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
    final scope = AppScope.of(context);
    final word = allWords[index];
    setState(() {
      listening = true;
      message = 'I am listening...';
    });
    final text = await scope.speechService.listenOnce(timeout: const Duration(seconds: 6));
    final ok = scope.speechService.sentenceContainsKeywords(text, _keywords(word.simpleSentence));
    await scope.progressService.addPronunciationAttempt(word.id, ok);
    if (!mounted) return;
    setState(() {
      listening = false;
      heard = text;
      message = ok ? 'Great sentence! ⭐' : 'Good try! Say it again.';
    });
    if (ok) {
      await RewardDialog.show(context, 'Super speaker! ⭐');
      if (mounted) setState(() => index = (index + 1) % allWords.length);
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
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => setState(() => index = (index + 1) % allWords.length), child: const Text('Next'))),
        ]),
      ),
    );
  }
}
