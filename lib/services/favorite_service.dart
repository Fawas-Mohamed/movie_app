import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/moviemodel.dart';

class FavoriteService {
  static final user = FirebaseAuth.instance.currentUser;

  static CollectionReference get favRef {
  if (user == null) {
    throw Exception("User not logged in");
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('favorites');
}
  static Future<void> addFavorite(MovieModel movie) async {
    await favRef.doc(movie.id.toString()).set({
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

  static Future<void> removeFavorite(String movieId) async {
    await favRef.doc(movieId).delete();
  }

  static Stream<bool> isFavorite(String movieId) {
    return favRef.doc(movieId).snapshots().map((doc) => doc.exists);
  }
  static  Stream<int> favoriteCount(){
    return favRef.snapshots().map((snapshot)=>snapshot.docs.length);
  }
}
