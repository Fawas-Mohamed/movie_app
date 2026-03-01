import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/pages/movie_details.dart';

class MovieCart extends StatelessWidget {
  final MovieModel movie;
  const MovieCart({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => MyWidget(movie: movie))),
      child: Container(
        width: 150,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              '${AppConstants.baseImageUrl}/${movie.posterPath}',
              height: 200,
            ),
            SizedBox(height: size.height * 0.06),
            Text(
              movie.title,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
