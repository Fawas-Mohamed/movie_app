import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:movieapp/core/constants.dart';
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
  @override
Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

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
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 20),

                Center(
                  child: Text(
                    "PopcornPals",
                    style: TextStyle(
                      color: Color.fromARGB(255, 242, 255, 57),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Center(
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
  child: Row(
    children: [
      Expanded(
        child: Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0,4)
      )
    ],
    border: Border.all(color: Colors.white.withOpacity(0.2)),
  ),
  child: TextField(
    style: const TextStyle(color: Colors.white),
    decoration: const InputDecoration(
      hintText: "Search movies...",
      hintStyle: TextStyle(color: Colors.white70),
      prefixIcon: Icon(Icons.search, color: Colors.white),
      border: InputBorder.none,
    ),
  ),
)
      ),
    ],
  ),
),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Popular Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),

                MovieList(type: 'popular'),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Top Rated',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),

                MovieList(type: 'top_rated'),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),

                MovieList(type: 'upcoming'),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Now Playing',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
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
  );}}
