import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/widgets/app_background.dart';
import 'package:movieapp/widgets/app_header.dart';
import 'package:movieapp/widgets/app_loader.dart';
import 'package:movieapp/widgets/movie-cart.dart';
import 'package:movieapp/widgets/user_avatar.dart';

class MovieCollectionPage extends StatelessWidget {
  final String title;
  final String collection;
  final bool showRemoveButton;

  const MovieCollectionPage({
    super.key,
    required this.title,
    required this.collection,
    this.showRemoveButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text("User not logged in"));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                leftWidget: showRemoveButton
                    ? const Icon(Icons.bookmark, color: AppColors.primary)
                    : null,
                title: title,
                rightWidget: UserAvatar(email: user.email),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection(collection)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: AppLoader());
                    }

                    final movies = snapshot.data?.docs ?? [];
                    if (movies.isEmpty) {
                      return Center(
                        child: Text(
                          collection == 'watchlist'
                              ? "No Movies in Watchlist Yet"
                              : "No Favorite Movies Yet",
                          style: const TextStyle(
                              color: AppColors.secondary, fontSize: 16),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      physics: const BouncingScrollPhysics(),
                      itemCount: movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final movieData =
                            movies[index].data() as Map<String, dynamic>? ?? {};
                        final movie = MovieModel.fromJson(movieData);
                        return MovieCart(
                          movie: movie,
                          showRemoveWatchlistButton: showRemoveButton,
                          onRemoveWatchlist: showRemoveButton
                              ? () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection(collection)
                                      .doc(movie.id.toString())
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Removed from Watchlist"),
                                        duration: Duration(seconds: 1)),
                                  );
                                }
                              : null,
                        );
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