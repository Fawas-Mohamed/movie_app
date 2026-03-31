import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
