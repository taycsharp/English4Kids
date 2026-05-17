import 'package:flutter/material.dart';

class RewardDialog extends StatelessWidget {
  const RewardDialog({super.key, required this.message});

  final String message;

  static Future<void> show(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RewardDialog(message: message),
    );
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
            const Text('🎉', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 6),
            Text(
              message,
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
