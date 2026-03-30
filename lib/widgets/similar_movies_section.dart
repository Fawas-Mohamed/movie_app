import 'package:flutter/material.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/widgets/app_loader.dart';
import 'package:movieapp/widgets/movie-cart.dart';

class SimilarMoviesSection extends StatelessWidget {
  final int movieId;

  const SimilarMoviesSection({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MovieModel>>(
      future: ApiService.fetchSimilarMovies(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 260, child: Center(child: AppLoader()));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final movies = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieCart(movie: movies[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
