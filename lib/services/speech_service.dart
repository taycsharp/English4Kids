import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  Future<bool> init() async {
    _ready = await _speech.initialize(
      onError: (error) => debugPrint('[SpeechService] speech recognition error: $error'),
      onStatus: (status) => debugPrint('[SpeechService] speech recognition status: $status'),
    );
    return _ready;
  }

  Future<String> listenOnce({Duration timeout = const Duration(seconds: 5)}) async {
    if (!_ready) {
      final ok = await init();
      if (!ok) {
        debugPrint('[SpeechService] speech recognition unavailable');
        return '';
      }
    }

    String heard = '';
    debugPrint('[SpeechService] speech recognition starts');
    await _speech.listen(
      localeId: 'en_US',
      listenFor: timeout,
      pauseFor: const Duration(seconds: 2),
      onResult: (result) {
        heard = result.recognizedWords;
        debugPrint('[SpeechService] recognized words: $heard');
      },
    );
    await Future.delayed(timeout);
    await stopListening();
    return heard;
  }

  Future<void> stopListening() async {
    debugPrint('[SpeechService] speech recognition stops');
    await _speech.stop();
    await _speech.cancel();
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
