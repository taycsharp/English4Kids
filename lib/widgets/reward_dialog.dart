import 'package:flutter/material.dart';

import '../app.dart';

class RewardDialog extends StatefulWidget {
  const RewardDialog({super.key, required this.message, this.levelUp = false});

  final String message;
  final bool levelUp;

  static Future<void> show(BuildContext context, String message, {bool levelUp = false}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RewardDialog(message: message, levelUp: levelUp),
    );
  }

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final soundEffects = AppScope.of(context).soundEffectService;
      await soundEffects.playStar();
      if (widget.levelUp) {
        await soundEffects.playLevelUp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.levelUp ? '🌟🎉' : '🎉', style: const TextStyle(fontSize: 70)),
            const SizedBox(height: 6),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Yay!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
