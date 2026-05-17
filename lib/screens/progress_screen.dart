import 'package:flutter/material.dart';

import '../app.dart';
import '../data/sample_words.dart';
import '../models/progress_data.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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

  String get favoriteTopic {
    if (progress.topicStars.isEmpty) return 'Not yet';
    final entries = progress.topicStars.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.first.key;
  }

  @override
  Widget build(BuildContext context) {
    final weakWords = allWords.where((w) => progress.weakWordIds.contains(w.id)).take(8).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFA726)]), borderRadius: BorderRadius.circular(34)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('⭐ ${progress.totalStars} Stars', style: const TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w900)),
              Text(progress.levelName, style: const TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w800)),
            ]),
          ),
          const SizedBox(height: 18),
          _tile('Words learned', '${progress.learnedWordIds.length} / ${allWords.length}', Icons.menu_book_rounded),
          _tile('Pronunciation attempts', '${progress.pronunciationAttempts}', Icons.mic_rounded),
          _tile('Correct answers', '${progress.correctAnswers}', Icons.check_circle_rounded),
          _tile('Favorite topic', favoriteTopic, Icons.favorite_rounded),
          _tile('Daily streak', '${progress.streakDays} days placeholder', Icons.local_fire_department_rounded),
          const SizedBox(height: 18),
          const Text('Weak words', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          if (weakWords.isEmpty)
            const Text('No weak words yet. Great start!', style: TextStyle(fontSize: 18))
          else
            Wrap(spacing: 10, runSpacing: 10, children: weakWords.map((w) => Chip(label: Text('${w.emoji} ${w.word}'))).toList()),
        ],
      ),
    );
  }

  Widget _tile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
      child: Row(children: [
        Icon(icon, size: 34, color: const Color(0xFFFF8A65)),
        const SizedBox(width: 14),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}
