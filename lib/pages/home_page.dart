import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/pages/favorite_page.dart';
import 'package:movieapp/pages/profile_page.dart';
import 'package:movieapp/pages/setting_page.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/widgets/app_background.dart';
import 'package:movieapp/widgets/app_loader.dart';
import 'package:movieapp/widgets/movie-cart.dart';
import 'package:movieapp/widgets/movie-list.dart';
import 'package:movieapp/widgets/recently_viewed_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Timer? _debounce;

  List<MovieModel> searchResults = [];
  List<MovieModel> bannerMovies = [];

  bool isSearching = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadBannerMovies();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> loadBannerMovies() async {
    final movies = await ApiService.fetchMovies("popular");

    if (!mounted) return;

    setState(() {
      bannerMovies = movies.take(5).toList();
    });
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      query = query.trim();

      if (query.isEmpty) {
        if (!mounted) return;
        setState(() {
          isSearching = false;
          searchResults = [];
        });
        return;
      }

      setState(() {
        isSearching = true;
        isLoading = true;
      });

      final results = await ApiService.searchMovies(query);

      if (!mounted) return;
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget bannerSlider() {
    if (bannerMovies.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(
          child:AppLoader(),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: bannerMovies.map((movie) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movie.backdropPath}",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.background,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppColors.background.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildSearchResults() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: AppLoader()
        ),
      );
    }

    if (searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text("No Movies Found", style: TextStyle(color: AppColors.secondary)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: searchResults
            .map((movie) => MovieCart(movie: movie))
            .toList(),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 220,
        backgroundColor: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPictureSize: const Size(50, 50),
              decoration: const BoxDecoration(color: AppColors.background),
              accountName: const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                user?.email ?? "user@email.com",
                style: const TextStyle(color: Colors.grey),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user?.email?.substring(0, 1).toUpperCase() ?? "U",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.secondary),
              title: const Text("Home", style: TextStyle(color: AppColors.secondary)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.secondary),
              title: const Text(
                "Favorites",
                style: TextStyle(color: AppColors.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.secondary),
              title: const Text(
                "Settings",
                style: TextStyle(color: AppColors.secondary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            Icons.read_more,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      const Text(
                        "PopcornPals",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          user?.email?.substring(0, 1).toUpperCase() ?? "U",
                          style: const TextStyle(color: AppColors.background),
                        ),
                      ),
                    ],
                  ),
                ),

                const Center(
                  child: Text(
                    "Discover Your Movies",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppColors.secondary),
                      onChanged: onSearchChanged,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: "Search movies...",
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.secondary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.secondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    isSearching = false;
                                    searchResults = [];
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                if (!isSearching) bannerSlider(),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: isSearching
                      ? SizedBox(
                          key: const ValueKey('search'),
                          child: buildSearchResults(),
                        )
                      : const SizedBox(),
                ),

                if (!isSearching) const RecentlyViewedSection(),

                if (!isSearching) ...[
                  buildSectionTitle('Popular Movies'),
                  const MovieList(type: 'popular'),

                  buildSectionTitle('Top Rated'),
                  const MovieList(type: 'top_rated'),

                  buildSectionTitle('Upcoming'),
                  const MovieList(type: 'upcoming'),

                  buildSectionTitle('Now Playing'),
                  const MovieList(type: 'now_playing'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
