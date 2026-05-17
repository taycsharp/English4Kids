import 'package:audioplayers/audioplayers.dart';

/// Plays short, optional feedback sound effects for game-like interactions.
///
/// Vocabulary and sentence audio should continue to use flutter_tts. The files
/// referenced here are intentionally small UI sound effects and may be added to
/// assets/sounds/ later. Missing assets or playback errors are ignored so the
/// app stays stable while placeholder references are wired up.
class SoundEffectService {
  SoundEffectService() {
    _setReleaseModeSafely();
  }

  final AudioPlayer _player = AudioPlayer(playerId: 'sound_effects');

  Future<void> _setReleaseModeSafely() async {
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
    } catch (_) {
      // Ignore setup failures for optional sound effects.
    }
  }

  Future<void> playTap() => _play('tap.mp3');

  Future<void> playCorrect() => _play('correct.mp3');

  Future<void> playTryAgain() => _play('try_again.mp3');

  Future<void> playStar() => _play('star.mp3');

  Future<void> playLevelUp() => _play('level_up.mp3');

  Future<void> _play(String fileName) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$fileName'));
    } catch (_) {
      // Sound effects are nice-to-have. Missing assets or platform audio
      // failures should never interrupt a child using the app.
    }
  }

  Future<void> dispose() => _player.dispose();
}
