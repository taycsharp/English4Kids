import 'package:flutter/material.dart';

class StarCounter extends StatelessWidget {
  const StarCounter({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1B8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x22000000), offset: Offset(0, 4))],
      ),
      child: Text('⭐ $stars', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    );
  }
}
