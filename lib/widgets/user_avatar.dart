import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';

class UserAvatar extends StatelessWidget {
  final String? email;
  final double radius;

  const UserAvatar({
    super.key,
    this.email,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final String initial = (email != null && email!.isNotEmpty)
        ? email![0].toUpperCase()
        : "U";

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.background,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.9, 
        ),
      ),
    );
  }
}