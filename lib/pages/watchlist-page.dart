import 'package:flutter/material.dart';
import 'package:movieapp/widgets/movie_collection.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const MovieCollectionPage(
          title: "My Watchlist",
          collection: "watchlist",
          showRemoveButton: true);
}