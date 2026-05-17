import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService() {
    _configureTts();
  }

  final FlutterTts _tts = FlutterTts();

  Future<void> _configureTts() async {
    _tts.setStartHandler(() {
      debugPrint('[TtsService] TTS start');
    });
    _tts.setCompletionHandler(() {
      debugPrint('[TtsService] TTS complete');
    });
    _tts.setErrorHandler((message) {
      debugPrint('[TtsService] TTS error: $message');
    });

    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.08);
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );
    } catch (error) {
      debugPrint('[TtsService] TTS setup error: $error');
    }
  }

  Future<void> setSlow(bool slow) async => _tts.setSpeechRate(slow ? 0.38 : 0.48);

  Future<void> speak(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    try {
      await _tts.stop();
      await _tts.speak(cleanText);
    } catch (error) {
      debugPrint('[TtsService] TTS error while speaking: $error');
    }
  }

  Future<void> speakFeedback(String text) async {
    final cleanText = _cleanFeedbackText(text);
    if (cleanText.isEmpty) {
      debugPrint('[TtsService] Feedback TTS skipped: empty text after cleanup');
      return;
    }

    try {
      debugPrint('[TtsService] Feedback TTS requested: $cleanText');
      await _tts.stop();
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.05);
      await _tts.speak(cleanText);
    } catch (error) {
      debugPrint('[TtsService] TTS error while speaking feedback: $error');
    }
  }

  Future<void> speakWordAndSentence(String word, String sentence) async {
    await speak('$word. $sentence');
  }

  Future<void> stop() => _tts.stop();

  void dispose() {
    _tts.stop();
  }

  String _cleanFeedbackText(String text) {
    return text
        .replaceAll(RegExp(r'[⭐★☆✨🌟💫🎉🏆👏]'), '')
        .replaceAll(RegExp(r"""[^\w\s.,!?;:'"-]"""), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
