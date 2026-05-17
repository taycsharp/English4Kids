class ChildProfile {
  const ChildProfile({
    required this.name,
    required this.age,
    required this.level,
    required this.languageSupport,
    required this.speechSpeed,
  });

  final String name;
  final int age;
  final String level;
  final String languageSupport;
  final String speechSpeed;

  ChildProfile copyWith({
    String? name,
    int? age,
    String? level,
    String? languageSupport,
    String? speechSpeed,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      level: level ?? this.level,
      languageSupport: languageSupport ?? this.languageSupport,
      speechSpeed: speechSpeed ?? this.speechSpeed,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'level': level,
        'languageSupport': languageSupport,
        'speechSpeed': speechSpeed,
      };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        name: json['name'] as String? ?? 'Minh',
        age: json['age'] as int? ?? 6,
        level: json['level'] as String? ?? 'Beginner',
        languageSupport: json['languageSupport'] as String? ?? 'English + Vietnamese',
        speechSpeed: json['speechSpeed'] as String? ?? 'Slow',
      );

  static const initial = ChildProfile(
    name: 'Minh',
    age: 6,
    level: 'Beginner',
    languageSupport: 'English + Vietnamese',
    speechSpeed: 'Slow',
  );
}
