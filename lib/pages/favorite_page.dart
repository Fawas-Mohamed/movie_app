import 'package:flutter/material.dart';
import 'package:movieapp/widgets/movie_collection.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const MovieCollectionPage(title: "Favorite Movies", collection: "favorites");
}