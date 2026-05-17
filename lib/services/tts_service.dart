import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService() {
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.42);
    _tts.setPitch(1.08);
  }

  final FlutterTts _tts = FlutterTts();

  Future<void> setSlow(bool slow) async => _tts.setSpeechRate(slow ? 0.38 : 0.48);

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> speakWordAndSentence(String word, String sentence) async {
    await speak('$word. $sentence');
  }

  Future<void> stop() => _tts.stop();

  void dispose() {
    _tts.stop();
  }
}
