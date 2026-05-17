import 'package:flutter/material.dart';

import '../app.dart';
import '../models/child_profile.dart';
import '../models/progress_data.dart';
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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF5D8), Color(0xFFFFFBF2), Color(0xFFEAF6FF)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final contentWidth = width >= 900 ? 820.0 : double.infinity;
              final horizontalPadding = width < 390 ? 16.0 : 22.0;
              final isTablet = width >= 700;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HomeHeader(
                          name: profile.name,
                          levelName: progress.levelName,
                          stars: progress.totalStars,
                          onSettingsTap: () => _open(const SettingsScreen()),
                        ),
                        const SizedBox(height: 18),
                        _HeroLessonCard(onTap: () => _open(const TopicScreen())),
                        const SizedBox(height: 20),
                        _SectionTitle(
                          emoji: '🚀',
                          title: 'Choose your adventure',
                          subtitle: isTablet ? 'Big colorful cards make it easy to pick a lesson.' : 'Tap a card to begin.',
                        ),
                        const SizedBox(height: 12),
                        _ResponsiveActionGrid(
                          children: [
                            _HomeActionCard(
                              title: 'Start Learning',
                              subtitle: 'Pick a topic and learn new words',
                              icon: Icons.school_rounded,
                              color: const Color(0xFF2F80ED),
                              backgroundColor: const Color(0xFFEAF3FF),
                              onTap: () => _open(const TopicScreen()),
                            ),
                            _HomeActionCard(
                              title: 'Practice Pronunciation',
                              subtitle: 'Speak clearly and build confidence',
                              icon: Icons.mic_rounded,
                              color: const Color(0xFF9C4DCC),
                              backgroundColor: const Color(0xFFF7EAFE),
                              onTap: () => _open(const PronunciationScreen()),
                            ),
                            _HomeActionCard(
                              title: 'Progress',
                              subtitle: 'Celebrate stars and learned words',
                              icon: Icons.emoji_events_rounded,
                              color: const Color(0xFFF4A62A),
                              backgroundColor: const Color(0xFFFFF4CE),
                              onTap: () => _open(const ProgressScreen()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _VocabularyGamesPanel(
                          onListeningTap: () => _open(const ListeningGameScreen()),
                          onPictureQuizTap: () => _open(const PictureQuizScreen()),
                          onSentenceTap: () => _open(const SentencePracticeScreen()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.name,
    required this.levelName,
    required this.stars,
    required this.onSettingsTap,
  });

  final String name;
  final String levelName;
  final int stars;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Happy English Kids',
                style: textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFF2F2D69),
                  height: 1.02,
                  letterSpacing: -.7,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hello, $name! $levelName',
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6C6385),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        StarCounter(stars: stars),
        const SizedBox(width: 6),
        IconButton.filledTonal(
          onPressed: onSettingsTap,
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_rounded),
          iconSize: 28,
        ),
      ],
    );
  }
}

class _HeroLessonCard extends StatelessWidget {
  const _HeroLessonCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(34),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFB74D), Color(0xFFFF7A59), Color(0xFFFF5F8F)],
            ),
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [
              BoxShadow(blurRadius: 26, color: Color(0x30FF7043), offset: Offset(0, 14)),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .22),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Today’s mission',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Let’s learn English!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Listen, speak, play, and collect shiny stars.',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.tonalIcon(
                          onPressed: onTap,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start Learning'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 52),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 14),
                    const _MascotBadge(),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MascotBadge extends StatelessWidget {
  const _MascotBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .25),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text('🦊', style: TextStyle(fontSize: 58)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.emoji, required this.title, required this.subtitle});

  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$emoji $title',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF2F2D69),
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF746D86),
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _ResponsiveActionGrid extends StatelessWidget {
  const _ResponsiveActionGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 3 : constraints.maxWidth >= 560 ? 2 : 1;
        final spacing = constraints.maxWidth < 390 ? 12.0 : 14.0;
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 132),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  color: Color(0x14000000),
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, color: color, size: 34),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF28245D),
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF756F84),
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: color, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VocabularyGamesPanel extends StatelessWidget {
  const _VocabularyGamesPanel({
    required this.onListeningTap,
    required this.onPictureQuizTap,
    required this.onSentenceTap,
  });

  final VoidCallback onListeningTap;
  final VoidCallback onPictureQuizTap;
  final VoidCallback onSentenceTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF8E9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(blurRadius: 22, color: Color(0x12000000), offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            emoji: '🎮',
            title: 'Vocabulary Games',
            subtitle: 'Play quick games to remember words.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 640 ? 3 : 1;
              final spacing = constraints.maxWidth < 390 ? 10.0 : 12.0;
              final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _GameChip(
                      label: 'Listening Game',
                      icon: Icons.hearing_rounded,
                      color: const Color(0xFF43A047),
                      onTap: onListeningTap,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _GameChip(
                      label: 'Picture Quiz',
                      icon: Icons.quiz_rounded,
                      color: const Color(0xFFFF7043),
                      onTap: onPictureQuizTap,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _GameChip(
                      label: 'Sentence Practice',
                      icon: Icons.record_voice_over_rounded,
                      color: const Color(0xFF26A69A),
                      onTap: onSentenceTap,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GameChip extends StatelessWidget {
  const _GameChip({required this.label, required this.icon, required this.color, required this.onTap});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        alignment: Alignment.centerLeft,
        minimumSize: const Size(0, 58),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
    );
  }
}
