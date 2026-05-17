import 'package:flutter/material.dart';

import '../app.dart';
import '../models/progress_data.dart';
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
              Expanded(child: OutlinedButton.icon(onPressed: index == 0 ? null : () { scope.soundEffectService.playTap(); setState(() => index--); }, icon: const Icon(Icons.arrow_back_rounded), label: const Text('Previous'))),
              const SizedBox(width: 12),
              Expanded(child: FilledButton.icon(onPressed: () => scope.ttsService.speakWordAndSentence(word.word, word.simpleSentence), icon: const Icon(Icons.volume_up_rounded), label: const Text('Listen'))),
            ]),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () async {
                final previous = await scope.progressService.loadProgress();
                await scope.progressService.markLearned(word.id);
                final updated = await scope.progressService.addStars(1, topic: widget.topic.name);
                await scope.soundEffectService.playCorrect();
                if (!context.mounted) return;
                final levelUp = ProgressData.levelChanged(previous.totalStars, updated.totalStars);
                await RewardDialog.show(context, levelUp ? 'You got a star!\n${updated.levelName}!' : 'You got a star!', levelUp: levelUp);
              },
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('I know this word'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: index == widget.topic.words.length - 1 ? null : () { scope.soundEffectService.playTap(); setState(() => index++); },
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
