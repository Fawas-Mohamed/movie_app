import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/pages/movie_details.dart';
import 'package:movieapp/services/favorite_service.dart';

class MovieCart extends StatelessWidget {
  final MovieModel movie;
  final bool showRemoveWatchlistButton;
  final VoidCallback? onRemoveWatchlist;

  const MovieCart({
    super.key,
    required this.movie,
    this.showRemoveWatchlistButton = false,
    this.onRemoveWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${AppConstants.baseImageUrl}${movie.posterPath}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movie: movie),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Hero(
                tag: movie.id,
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: 160,
                      color: Colors.grey.shade900,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  children: [
                    StreamBuilder<bool>(
                      stream: FavoriteService.isFavorite(movie.id.toString()),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;

                        return GestureDetector(
                          onTap: () async {
                            if (isFav) {
                              await FavoriteService.removeFavorite(
                                movie.id.toString(),
                              );
                            } else {
                              await FavoriteService.addFavorite(movie);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.45),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : AppColors.secondary,
                              size: 22,
                            ),
                          ),
                        );
                      },
                    ),

                    if (showRemoveWatchlistButton)
                      GestureDetector(
                        onTap: onRemoveWatchlist,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_remove,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⭐ ${movie.voteAverage.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
