import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../models/progress_data.dart';
import '../widgets/topic_card.dart';
import 'vocabulary_screen.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  ProgressData progress = ProgressData.initial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgress();
    });
  }

  Future<void> _loadProgress() async {
    final value = await AppScope.of(context).progressService.loadProgress();
    if (mounted) setState(() => progress = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Topic')),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: .84),
        itemCount: sampleTopics.length,
        itemBuilder: (context, index) {
          final topic = sampleTopics[index];
          final learned = topic.words.where((word) => progress.learnedWordIds.contains(word.id)).length;
          return TopicCard(
            topic: topic,
            progress: learned / topic.words.length,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VocabularyScreen(topic: topic))),
          );
        },
      ),
    );
  }
}
