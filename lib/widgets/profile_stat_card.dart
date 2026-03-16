import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
      ),

      child: Column(
        children: [

          Icon(icon, color: const Color.fromARGB(255, 242, 255, 57)),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}