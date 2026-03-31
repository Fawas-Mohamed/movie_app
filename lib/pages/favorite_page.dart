import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/widgets/app_background.dart';
import 'package:movieapp/widgets/app_header.dart';
import 'package:movieapp/widgets/app_loader.dart';
import 'package:movieapp/widgets/movie-cart.dart';
import 'package:movieapp/widgets/user_avatar.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: "Favorite Movies",
                rightWidget: UserAvatar(email: user?.email),
                ),
              Column(
                children: [
                  const Text(
                    " You Can Add Your Favorite Movies Here ❤️",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('favorites')
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child:AppLoader());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Favorite Movies Yet",
                          style: TextStyle(color: AppColors.secondary, fontSize: 16),
                        ),
                      );
                    }

                    final movies = snapshot.data!.docs;

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.6,
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
      ),
    );
  }
}
