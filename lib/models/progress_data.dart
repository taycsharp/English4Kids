class ProgressData {
  const ProgressData({
    required this.totalStars,
    required this.learnedWordIds,
    required this.pronunciationAttempts,
    required this.correctAnswers,
    required this.weakWordIds,
    required this.topicStars,
    required this.streakDays,
  });

  final int totalStars;
  final Set<String> learnedWordIds;
  final int pronunciationAttempts;
  final int correctAnswers;
  final Set<String> weakWordIds;
  final Map<String, int> topicStars;
  final int streakDays;

  String get levelName {
    if (totalStars >= 120) return 'Super Speaker';
    if (totalStars >= 70) return 'English Explorer';
    if (totalStars >= 30) return 'Smart Learner';
    return 'Little Star';
  }

  ProgressData copyWith({
    int? totalStars,
    Set<String>? learnedWordIds,
    int? pronunciationAttempts,
    int? correctAnswers,
    Set<String>? weakWordIds,
    Map<String, int>? topicStars,
    int? streakDays,
  }) {
    return ProgressData(
      totalStars: totalStars ?? this.totalStars,
      learnedWordIds: learnedWordIds ?? this.learnedWordIds,
      pronunciationAttempts: pronunciationAttempts ?? this.pronunciationAttempts,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      weakWordIds: weakWordIds ?? this.weakWordIds,
      topicStars: topicStars ?? this.topicStars,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalStars': totalStars,
        'learnedWordIds': learnedWordIds.toList(),
        'pronunciationAttempts': pronunciationAttempts,
        'correctAnswers': correctAnswers,
        'weakWordIds': weakWordIds.toList(),
        'topicStars': topicStars,
        'streakDays': streakDays,
      };

  factory ProgressData.fromJson(Map<String, dynamic> json) => ProgressData(
        totalStars: json['totalStars'] as int? ?? 0,
        learnedWordIds: Set<String>.from(json['learnedWordIds'] as List? ?? const []),
        pronunciationAttempts: json['pronunciationAttempts'] as int? ?? 0,
        correctAnswers: json['correctAnswers'] as int? ?? 0,
        weakWordIds: Set<String>.from(json['weakWordIds'] as List? ?? const []),
        topicStars: Map<String, int>.from(json['topicStars'] as Map? ?? const {}),
        streakDays: json['streakDays'] as int? ?? 0,
      );

  static const initial = ProgressData(
    totalStars: 0,
    learnedWordIds: {},
    pronunciationAttempts: 0,
    correctAnswers: 0,
    weakWordIds: {},
    topicStars: {},
    streakDays: 0,
  );
}
