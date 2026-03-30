import 'package:flutter/material.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/widgets/movie-cart.dart';

class MovieList extends StatefulWidget {
  final String type;
  const MovieList({super.key, required this.type});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FutureBuilder(
        future: ApiService.fetchMovies(widget.type), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
                color: Color.fromARGB(255, 242, 255, 57),
              ),);
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Movies"));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              return MovieCart(movie: movie);
            },
          );
        },
      ),
    );
  }
}