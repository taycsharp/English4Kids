import 'package:flutter/material.dart';

import '../models/topic.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({super.key, required this.topic, required this.progress, required this.onTap});

  final Topic topic;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(blurRadius: 14, color: Color(0x18000000), offset: Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.emoji, style: const TextStyle(fontSize: 46)),
            const Spacer(),
            Text(topic.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text('${topic.wordCount} words', style: const TextStyle(fontSize: 15, color: Colors.black54)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: const Color(0xFFFFE0B2),
              ),
            ),
            const SizedBox(height: 4),
            Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
