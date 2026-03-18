import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/widgets/movie-cart.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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

                /// FAVORITES LIST
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('favorites')
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Favorite Movies Yet",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }

                      final movies = snapshot.data!.docs;

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 10,
                            ),

                        itemCount: movies.length,

                        itemBuilder: (context, index) {
                          final movieData =
                              movies[index].data() as Map<String, dynamic>;

                          final movie = MovieModel.fromJson(movieData);

                          return MovieCart(movie: movie);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
