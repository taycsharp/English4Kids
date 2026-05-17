import 'package:flutter/material.dart';

import '../models/vocabulary_word.dart';

class WordCard extends StatelessWidget {
  const WordCard({super.key, required this.word, this.showMeaning = true});

  final VocabularyWord word;
  final bool showMeaning;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [BoxShadow(blurRadius: 20, color: Color(0x1F000000), offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text(word.emoji, style: const TextStyle(fontSize: 110)),
          Text(word.word, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
          if (showMeaning) Text(word.meaningVi, style: const TextStyle(fontSize: 20, color: Colors.black54)),
          const SizedBox(height: 12),
          Text(word.simpleSentence, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
