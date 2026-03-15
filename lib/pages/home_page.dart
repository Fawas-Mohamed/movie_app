import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/pages/favorite_page.dart';
import 'package:movieapp/pages/profile_page.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/widgets/movie-cart.dart';
import 'package:movieapp/widgets/movie-list.dart';

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

  Future loadBannerMovies() async {
    final movies = await ApiService.fetchMovies("popular");

    setState(() {
      bannerMovies = movies.take(5).toList();
    });
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      query = query.trim();

      if (query.isEmpty) {
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
      return const Center(child: CircularProgressIndicator());
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
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
  width: 220,
  backgroundColor: Colors.black,
  child: ListView(
    padding: EdgeInsets.zero,
    children: [

      UserAccountsDrawerHeader(
        currentAccountPictureSize: Size(50, 50),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        accountName: const Text(
          "Welcome",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
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
            backgroundColor: Color.fromARGB(255, 242, 255, 57),
            child: Text(
              user?.email?.substring(0, 1).toUpperCase() ?? "U",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),

      ListTile(
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      ListTile(
        leading: const Icon(Icons.favorite, color: Colors.white),
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritePage(),
            ),
          );
        },
      ),

      ListTile(
        leading: const Icon(Icons.settings, color: Colors.white),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {},
      ),

      const Divider(color: Colors.grey),

      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.red),
        ),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
        },
      ),
    ],
  ),
),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN0K-TbHTkelyQyrcrb-yk-J2G7KmOp66uow&s",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
    return Container(color: Colors.black);
              },
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(
                              Icons.read_more,
                              color: Color.fromARGB(255, 242, 255, 57),
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),

                        const Text(
                          "PopcornPals",
                          style: TextStyle(
                            color: Color.fromARGB(255, 242, 255, 57),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromARGB(255, 242, 255, 57),
                          child: Text(
                            user?.email?.substring(0, 1).toUpperCase() ?? "U",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Discover Your Movies",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 255, 57),
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: onSearchChanged,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: "Search movies...",
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
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
                            child: Column(
                              children: [
                                if (isLoading)
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  ),
                                if (!isLoading && searchResults.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "No Movies Found",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                if (!isLoading)
                                  Column(
                                    children: List.generate(
                                      searchResults.length,
                                      (index) => Row(
                                        children: [
                                          MovieCart(
                                            movie: searchResults[index],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Popular Movies',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MovieList(type: 'popular'),

                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Top Rated',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MovieList(type: 'top_rated'),

                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MovieList(type: 'upcoming'),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Nowplaying',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MovieList(type: 'now_playing'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
