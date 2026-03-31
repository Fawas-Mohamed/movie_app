import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const SectionTitle({
    super.key,
    required this.title,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: style ??
            const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}