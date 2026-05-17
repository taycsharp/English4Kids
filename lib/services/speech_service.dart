import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  Future<bool> init() async {
    _ready = await _speech.initialize();
    return _ready;
  }

  Future<String> listenOnce({Duration timeout = const Duration(seconds: 5)}) async {
    if (!_ready) {
      final ok = await init();
      if (!ok) return '';
    }
    String heard = '';
    await _speech.listen(
      localeId: 'en_US',
      listenFor: timeout,
      pauseFor: const Duration(seconds: 2),
      onResult: (result) => heard = result.recognizedWords,
    );
    await Future.delayed(timeout);
    await _speech.stop();
    return heard;
  }

  String normalize(String text) => text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  bool matchesWord(String heard, String targetWord) {
    final h = normalize(heard);
    final t = normalize(targetWord);
    return h == t || h.split(' ').contains(t) || h.contains(t);
  }

  bool sentenceContainsKeywords(String heard, List<String> keywords) {
    final h = normalize(heard);
    return keywords.every((keyword) => h.contains(normalize(keyword)));
  }
}
