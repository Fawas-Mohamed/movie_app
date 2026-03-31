import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.secondary, size: 18),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: AppColors.secondary)),
          ],
        ),
      ),
    );
  }
}
