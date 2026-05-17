import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/child_profile.dart';
import '../models/progress_data.dart';

class ProgressService {
  static const _progressKey = 'happy_english_progress';
  static const _profileKey = 'happy_english_profile';

  Future<ProgressData> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_progressKey);
    if (raw == null) return ProgressData.initial;
    return ProgressData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<ChildProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return ChildProfile.initial;
    return ChildProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProgress(ProgressData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(data.toJson()));
  }

  Future<void> saveProfile(ChildProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<ProgressData> addStars(int count, {String? topic}) async {
    final current = await loadProgress();
    final topicStars = Map<String, int>.from(current.topicStars);
    if (topic != null) topicStars[topic] = (topicStars[topic] ?? 0) + count;
    final updated = current.copyWith(
      totalStars: current.totalStars + count,
      correctAnswers: current.correctAnswers + 1,
      topicStars: topicStars,
    );
    await saveProgress(updated);
    return updated;
  }

  Future<ProgressData> markLearned(String wordId) async {
    final current = await loadProgress();
    final learned = Set<String>.from(current.learnedWordIds)..add(wordId);
    final updated = current.copyWith(learnedWordIds: learned);
    await saveProgress(updated);
    return updated;
  }

  Future<ProgressData> addPronunciationAttempt(String wordId, bool correct) async {
    final current = await loadProgress();
    final weak = Set<String>.from(current.weakWordIds);
    if (correct) {
      weak.remove(wordId);
    } else {
      weak.add(wordId);
    }
    final updated = current.copyWith(
      pronunciationAttempts: current.pronunciationAttempts + 1,
      correctAnswers: correct ? current.correctAnswers + 1 : current.correctAnswers,
      totalStars: correct ? current.totalStars + 2 : current.totalStars,
      weakWordIds: weak,
    );
    await saveProgress(updated);
    return updated;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}
