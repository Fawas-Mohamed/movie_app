import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movieapp/models/moviemodel.dart';

class WatchlistService {
  static final user = FirebaseAuth.instance.currentUser;

  static CollectionReference get WatchlistRef {
    if (user == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('watchlist');
  }

  static Future<void> saveWatchlist(MovieModel movie) async {
    await WatchlistRef.doc(movie.id.toString()).set({
      "adult": movie.adult,
      "backdrop_path": movie.backdropPath,
      "genre_ids": movie.genreIds,
      "id": movie.id,
      "original_language": movie.originalLanguage,
      "original_title": movie.originalTitle,
      "overview": movie.overview,
      "popularity": movie.popularity,
      "poster_path": movie.posterPath,
      "release_date": movie.releaseDate.toIso8601String(),
      "title": movie.title,
      "video": movie.video,
      "vote_average": movie.voteAverage,
      "vote_count": movie.voteCount,
    });
  }

  static Future<void> deleteWatchlist(String movieId) async {
    await WatchlistRef.doc(movieId).delete();
  }

  static Stream<int> watchlistCount() {
    return WatchlistRef.snapshots().map((snapshot) => snapshot.docs.length);
  }

  static Stream<bool> isInWatchlist(String movieId) {
    return WatchlistRef.doc(movieId).snapshots().map((doc) => doc.exists);
  }
}
