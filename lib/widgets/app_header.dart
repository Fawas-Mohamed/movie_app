import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final bool centerTitler;

  const AppHeader({
    super.key,
    required this.title,
    this.leftWidget,
    this.rightWidget,
    this.centerTitler=true,

    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftWidget ?? const SizedBox(width: 40),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          rightWidget ?? const SizedBox(width: 40),
        ],
      ),
    );
  }
}