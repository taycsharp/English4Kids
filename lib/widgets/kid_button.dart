import 'package:flutter/material.dart';

class KidButton extends StatelessWidget {
  const KidButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 76,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 30),
        label: Text(label, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: color.withValues(alpha: .35),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }
}
