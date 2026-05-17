import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/progress_service.dart';
import 'services/sound_effect_service.dart';
import 'services/speech_service.dart';
import 'services/tts_service.dart';

class HappyEnglishKidsApp extends StatefulWidget {
  const HappyEnglishKidsApp({super.key});

  @override
  State<HappyEnglishKidsApp> createState() => _HappyEnglishKidsAppState();
}

class _HappyEnglishKidsAppState extends State<HappyEnglishKidsApp> {
  final progressService = ProgressService();
  final ttsService = TtsService();
  final speechService = SpeechService();
  final soundEffectService = SoundEffectService();

  @override
  void dispose() {
    ttsService.dispose();
    soundEffectService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      progressService: progressService,
      ttsService: ttsService,
      speechService: speechService,
      soundEffectService: soundEffectService,
      child: MaterialApp(
        title: 'Happy English Kids',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF8A65),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF7E8),
          fontFamily: 'Arial',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            bodyLarge: TextStyle(fontSize: 18),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.progressService,
    required this.ttsService,
    required this.speechService,
    required this.soundEffectService,
    required super.child,
  });

  final ProgressService progressService;
  final TtsService ttsService;
  final SpeechService speechService;
  final SoundEffectService soundEffectService;

  static AppScope of(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<AppScope>();
    final scope = element?.widget as AppScope?;
    assert(scope != null, 'AppScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
