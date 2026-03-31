import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieapp/models/moviemodel.dart';

class RecentlyViewedService {
  static final user = FirebaseAuth.instance.currentUser;
  static CollectionReference get recentRef {
    if (user == null) {
      throw Exception("User not logged in");
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('recent_views');
  }

  static Future<void> saveRecentlyViewed(MovieModel movie) async {
    await recentRef.doc(movie.id.toString()).set({
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
      "viewed_at": FieldValue.serverTimestamp(),
    });
  }
}
