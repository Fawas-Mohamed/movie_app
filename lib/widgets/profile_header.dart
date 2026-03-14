import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "user";
    final username = email.split('@')[0];
    final firstLetter = email.isNotEmpty ? email.substring(0, 1).toUpperCase() : "U";
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromARGB(255, 242, 255, 57),
          child: Text(
            firstLetter,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
            ),
        ),
        const SizedBox(height: 10),
        Text(
          username,
          style:const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email,
          style: const TextStyle(
            color:Colors.black,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}