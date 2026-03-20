import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Watchlistpage extends StatefulWidget {
  const Watchlistpage({super.key});

  @override
  State<Watchlistpage> createState() => _WatchlistpageState();
}

class _WatchlistpageState extends State<Watchlistpage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN0K-TbHTkelyQyrcrb-yk-J2G7KmOp66uow&s",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.black);
              },
            ),
          ),

          /// BLUR EFFECT
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50),
                      const Text(
                        "Favorite Movies",
                        style: TextStyle(
                          color: Color.fromARGB(255, 242, 255, 57),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color.fromARGB(
                          255,
                          242,
                          255,
                          57,
                        ),
                        child: Text(
                          user?.email?.substring(0, 1).toUpperCase() ?? "U",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      " You Can Add Your Favorite Movies Here ❤️",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 255, 57),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),
        ]
      )
      
    );
  }
}