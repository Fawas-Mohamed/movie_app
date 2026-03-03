import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieapp/models/moviemodel.dart';
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
  Timer? _debounce;

  List<MovieModel> searchResults = [];
  bool isSearching = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN0K-TbHTkelyQyrcrb-yk-J2G7KmOp66uow&s",
              fit: BoxFit.cover,
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
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "PopcornPals",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 255, 57),
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: searchResults.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          MovieCart(
                                            movie: searchResults[index],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey('categories'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    'Popular Movies',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                MovieList(type: 'upcoming'),

                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    'Now Playing',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                MovieList(type: 'now_playing'),
                              ],
                            ),
                          ),
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
