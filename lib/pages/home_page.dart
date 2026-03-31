import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/pages/favorite_page.dart';
import 'package:movieapp/pages/profile_page.dart';
import 'package:movieapp/pages/setting_page.dart';
import 'package:movieapp/pages/watchlist-page.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/widgets/app_background.dart';
import 'package:movieapp/widgets/app_header.dart';
import 'package:movieapp/widgets/app_loader.dart';
import 'package:movieapp/widgets/movie-cart.dart';
import 'package:movieapp/widgets/movie-list.dart';
import 'package:movieapp/widgets/recently_viewed_section.dart';
import 'package:movieapp/widgets/user_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final FocusNode _searchFocus = FocusNode();

  Timer? _debounce;
  int _searchId = 0;

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
    _searchId++;
    final currentId = _searchId;

    _debounce?.cancel();
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

      if (!mounted || currentId != _searchId) return;

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
    _searchFocus.dispose();
    super.dispose();
  }

  Widget bannerSlider() {
    if (bannerMovies.isEmpty) {
      return const SizedBox(height: 160, child: Center(child: AppLoader()));
    }

    return RepaintBoundary(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
        items: bannerMovies.map((movie) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w500${movie.backdropPath}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const AppLoader(),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.background.withOpacity(0.8),
                        Colors.transparent,
                      ],
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSearchResults() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: AppLoader()),
      );
    }

    if (searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "No Movies Found",
            style: TextStyle(color: AppColors.secondary),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchResults.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return MovieCart(movie: searchResults[index]);
      },
    );
  }

  Widget sectionTitle(String title) {
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
        backgroundColor: AppColors.background,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.background),
              accountName: const Text(
                "Welcome",
                style: TextStyle(color: AppColors.secondary),
              ),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                child: UserAvatar(email: user?.email, radius: 25),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.secondary),
              title: const Text(
                "Favorites",
                style: TextStyle(color: AppColors.secondary),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.secondary),
              title: const Text(
                "Watchlist",
                style: TextStyle(color: AppColors.secondary),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WatchlistPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.secondary),
              title: const Text(
                "Settings",
                style: TextStyle(color: AppColors.secondary),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
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

      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: AppBackground(
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppHeader(
                    title: "PopcornPals",
                    leftWidget: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: AppColors.primary),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    rightWidget: UserAvatar(email: user?.email),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Discover Your Movies",
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        focusNode: _searchFocus,
                        autofocus: false, 
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
                                    FocusManager.instance.primaryFocus?.unfocus();
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
                ),

                if (!isSearching) SliverToBoxAdapter(child: bannerSlider()),

                if (isSearching)
                  SliverToBoxAdapter(child: buildSearchResults()),
                if (!isSearching)
                  SliverToBoxAdapter(child: RecentlyViewedSection()),

                if (!isSearching) ...[
                  SliverToBoxAdapter(child: sectionTitle("Popular Movies")),
                  const SliverToBoxAdapter(child: MovieList(type: "popular")),

                  SliverToBoxAdapter(child: sectionTitle("Top Rated")),
                  const SliverToBoxAdapter(child: MovieList(type: "top_rated")),

                  SliverToBoxAdapter(child: sectionTitle("Upcoming")),
                  const SliverToBoxAdapter(child: MovieList(type: "upcoming")),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
