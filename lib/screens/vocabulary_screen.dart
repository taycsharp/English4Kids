import 'package:flutter/material.dart';

import '../app.dart';
import '../models/topic.dart';
import '../widgets/reward_dialog.dart';
import '../widgets/word_card.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key, required this.topic});

  final Topic topic;

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final word = widget.topic.words[index];
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: Center(child: WordCard(word: word))),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: index == 0 ? null : () => setState(() => index--), icon: const Icon(Icons.arrow_back_rounded), label: const Text('Previous'))),
              const SizedBox(width: 12),
              Expanded(child: FilledButton.icon(onPressed: () => scope.ttsService.speakWordAndSentence(word.word, word.simpleSentence), icon: const Icon(Icons.volume_up_rounded), label: const Text('Listen'))),
            ]),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () async {
                await scope.progressService.markLearned(word.id);
                await scope.progressService.addStars(1, topic: widget.topic.name);
                if (!context.mounted) return;
                await RewardDialog.show(context, 'Great job! ⭐');
              },
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('I know this word'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: index == widget.topic.words.length - 1 ? null : () => setState(() => index++),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
