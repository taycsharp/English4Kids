import 'package:flutter/material.dart';

import '../app.dart';
import '../models/child_profile.dart';
import '../models/progress_data.dart';
import '../widgets/kid_button.dart';
import '../widgets/star_counter.dart';
import 'listening_game_screen.dart';
import 'picture_quiz_screen.dart';
import 'progress_screen.dart';
import 'pronunciation_screen.dart';
import 'sentence_practice_screen.dart';
import 'settings_screen.dart';
import 'topic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProgressData progress = ProgressData.initial;
  ChildProfile profile = ChildProfile.initial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    final scope = AppScope.of(context);
    final p = await scope.progressService.loadProgress();
    final c = await scope.progressService.loadProfile();
    if (!mounted) return;
    setState(() {
      progress = p;
      profile = c;
    });
    await scope.ttsService.setSlow(c.speechSpeed == 'Slow');
  }

  Future<void> _open(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Happy English Kids', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                      Text('Hello, ${profile.name}! ${progress.levelName}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                    ]),
                  ),
                  StarCounter(stars: progress.totalStars),
                  IconButton(onPressed: () => _open(const SettingsScreen()), icon: const Icon(Icons.settings_rounded, size: 30)),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFB74D), Color(0xFFFF8A65)]),
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: const [BoxShadow(blurRadius: 20, color: Color(0x2AFF8A65), offset: Offset(0, 10))],
                ),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🌟 Let’s learn English!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Listen, speak, play, and collect stars.', style: TextStyle(fontSize: 19, color: Colors.white)),
                ]),
              ),
              const SizedBox(height: 22),
              KidButton(label: 'Start Learning', icon: Icons.school_rounded, color: const Color(0xFF42A5F5), onTap: () => _open(const TopicScreen())),
              const SizedBox(height: 14),
              KidButton(label: 'Practice Pronunciation', icon: Icons.mic_rounded, color: const Color(0xFFAB47BC), onTap: () => _open(const PronunciationScreen())),
              const SizedBox(height: 14),
              KidButton(label: 'Listening Game', icon: Icons.hearing_rounded, color: const Color(0xFF66BB6A), onTap: () => _open(const ListeningGameScreen())),
              const SizedBox(height: 14),
              KidButton(label: 'Picture Quiz', icon: Icons.quiz_rounded, color: const Color(0xFFFF7043), onTap: () => _open(const PictureQuizScreen())),
              const SizedBox(height: 14),
              KidButton(label: 'Sentence Practice', icon: Icons.record_voice_over_rounded, color: const Color(0xFF26A69A), onTap: () => _open(const SentencePracticeScreen())),
              const SizedBox(height: 14),
              KidButton(label: 'Progress', icon: Icons.emoji_events_rounded, color: const Color(0xFFFFCA28), onTap: () => _open(const ProgressScreen())),
            ],
          ),
        ),
      ),
    );
  }
}
