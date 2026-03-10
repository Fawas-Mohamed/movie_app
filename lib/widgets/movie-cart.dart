import 'package:flutter/material.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/pages/movie_details.dart';
import 'package:movieapp/services/favorite_service.dart';

class MovieCart extends StatelessWidget {
  final MovieModel movie;

  const MovieCart({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyWidget(movie: movie)),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              
              Hero(
                tag: movie.id,
                child: Image.network(
                  '${AppConstants.baseImageUrl}${movie.posterPath}',
                  height: 300,
                  width: 180,
                  fit: BoxFit.cover,
                )
              ),
              

              Container(
                height: 230,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                
              ),
        
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
              ),
              Positioned(top: 10,
              right: 10,
              child: IconButton(icon:Icon(Icons.favorite_border,color: Colors.white,) ,onPressed: (){FavoriteService.addFavorite(movie);}),)
            ],
            
          ),
        ),
      ),
    );
  }
}
