import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';

class UserAvatar extends StatelessWidget {
  final String? email;
  const UserAvatar({
    super.key,
    this.email
    });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.primary,
      child: Text(
        email?.substring(0,1).toUpperCase() ?? "U",
        style: const TextStyle(color: AppColors.background,fontWeight: FontWeight.bold),
      ),
    );
  }
}