import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/castmodel.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/services/favorite_service.dart';
import 'package:movieapp/services/watchlist_service.dart';
import 'package:movieapp/widgets/app_loader.dart';
import 'package:movieapp/widgets/similar_movies_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movieapp/services/cast_service.dart';
import 'package:movieapp/services/recent_view.dart';

class MovieDetailsPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    RecentlyViewedService.saveRecentlyViewed(widget.movie);
  }

  bool isTrailerLoading = false;

  Future<void> playTrailer() async {
    setState(() {
      isTrailerLoading = true;
    });

    try {
      final key = await ApiService.fetchTrailer(widget.movie.id);

      if (key != null && key.isNotEmpty) {
        final uri = Uri.parse("https://www.youtube.com/watch?v=$key");
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Trailer not available")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    } finally {
      if (mounted) {
        setState(() {
          isTrailerLoading = false;
        });
      }
    }
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
            stream: FavoriteService.isFavorite(widget.movie.id.toString()),
            builder: (context, snapshot) {
              final isFav = snapshot.data ?? false;

              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFav ? Colors.red : Colors.white12,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (isFav) {
                    await FavoriteService.removeFavorite(
                      widget.movie.id.toString(),
                    );
                  } else {
                    await FavoriteService.addFavorite(widget.movie);
                  }
                },
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                label: Text(isFav ? "Favorited" : "Favorite"),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StreamBuilder<bool>(
            stream: WatchlistService.isInWatchlist(widget.movie.id.toString()),
            builder: (context, snapshot) {
              final isSaved = snapshot.data ?? false;

              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSaved ? AppColors.primary : Colors.white12,
                  foregroundColor: isSaved
                      ? AppColors.background
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (isSaved) {
                    await WatchlistService.deleteWatchlist(
                      widget.movie.id.toString(),
                    );
                  } else {
                    await WatchlistService.saveWatchlist(widget.movie);
                  }
                },
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                label: Text(isSaved ? "Saved" : "Watchlist"),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCastSection() {
    return FutureBuilder<List<CastModel>>(
      future: CastService.fetchCast(widget.movie.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 130,
            child: Center(child: AppLoader()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            "Cast not available",
            style: TextStyle(color: Colors.white70),
          );
        }

        final castList = snapshot.data!;

        return SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: castList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cast = castList[index];
              final imageUrl = cast.profilePath.isNotEmpty
                  ? "${AppConstants.baseImageUrl}/${cast.profilePath}"
                  : "";

              return SizedBox(
                width: 95,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white12,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cast.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cast.character,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final heroImage = widget.movie.backdropPath.isNotEmpty
        ? "${AppConstants.baseImageUrl}/${widget.movie.posterPath}"
        : "${AppConstants.baseImageUrl}/${widget.movie.backdropPath}";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            expandedHeight: 320,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.background,
                    size: 18,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(heroImage, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withOpacity(0.25),
                          AppColors.background.withOpacity(0.65),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 28,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isTrailerLoading ? null : playTrailer,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: isTrailerLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(18),
                                    child:AppLoader()
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: AppColors.background,
                                    size: 40,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.movie.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StarRating(
                    rating: (widget.movie.voteAverage / 2.0),
                    starCount: 5,
                    size: 22,
                  ),
                  Text(
                    "${widget.movie.voteAverage.toStringAsFixed(1)}/10  •  ${widget.movie.originalLanguage.toUpperCase()}  •  ${widget.movie.releaseDate.year}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  buildActionButtons(),
                  const SizedBox(height: 24),

                  const Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.overview.isNotEmpty
                        ? widget.movie.overview
                        : "No overview available.",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    "Cast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildCastSection(),
                  const SizedBox(height: 20),

                  const Text(
                    "Similar Movies",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SimilarMoviesSection(movieId: widget.movie.id),

                  const SizedBox(height: 20),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
