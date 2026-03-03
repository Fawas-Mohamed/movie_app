import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/services/api_service.dart';
import 'package:movieapp/widgets/movie-list.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWidget extends StatefulWidget {
  final MovieModel movie;
  const MyWidget({super.key, required this.movie});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      '${AppConstants.baseImageUrl}/${widget.movie.posterPath}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.center,
                          end: AlignmentGeometry.bottomCenter,
                          colors: [Colors.black.withOpacity(0.2), Colors.black],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop<Object?>();
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 255, 57),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color.fromARGB(255, 12, 12, 12),
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.25),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final key = await ApiService.fetchTrailer(
                          widget.movie.id,
                        );

                        if (key != null) {
                          final url = "https://www.youtube.com/watch?v=$key";
                          await launchUrl(Uri.parse(url));
                        } else {
                          print("No trailer found");
                        }
                      },
                      child: Icon(
                        Icons.play_arrow,
                        size: 40,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 242, 255, 57),
                      ),
                    ),
                  ),

                  Positioned(
                    top: size.height * 0.43,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        widget.movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: StarRating(
                rating: widget.movie.voteAverage,
                starCount: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.movie.overview,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              'UpComming',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            MovieList(type: 'upcoming'),
          ],
        ),
      ),
    );
  }
}
