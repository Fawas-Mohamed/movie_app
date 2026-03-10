import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class  FavoriteService {
  static final user = FirebaseAuth.instance.currentUser;

  static Future<void> addFavorite(movie) async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(user!.uid)
    .collection('favorites')
    .doc(movie.id.toString())
    .set({
      'id': movie.id,
      'title': movie.title,
      'posterPath': movie.posterPath,
      'backdropPath': movie.backdropPath,
    });
  }
  static Future<void> removeFavorite(String movieId) async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(user!.uid)
    .collection('favorites')
    .doc(movieId)
    .delete();
  }
}