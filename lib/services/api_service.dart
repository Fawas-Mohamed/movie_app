import 'dart:convert';
import 'package:movieapp/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/models/moviemodel.dart';
import 'package:movieapp/models/videomodel.dart';

class ApiService {
  static Future<List<MovieModel>> fetchMovies({String type = 'popular'}) async {
    try {
      final url = Uri.https("api.themoviedb.org", "/3/movie/$type", {
        "api_key": AppConstants.apiKey,
      });
      final apiResponse = await http.get(url);

      if (apiResponse.statusCode == 200) {
        final List result = jsonDecode(apiResponse.body)['results'];
        return result.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<MovieModel>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    try {
      final url = Uri.https("api.themoviedb.org", "/3/search/movie", {
        "api_key": AppConstants.apiKey,
        "query": query,
      });
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['results'];
        return result.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        print("TMDB API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  static Future<List<VideoModel>> fetchTrailer(String movieId) async {
  if (movieId.isEmpty) return [];

  try {
    final url = Uri.https(
      "api.themoviedb.org",
      "/3/movie/$movieId/videos",
      {
        "api_key": AppConstants.apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List results = decoded['results'];

      return results
          .map<VideoModel>((json) => VideoModel.fromJson(json))
          .toList();   // 🔥 VERY IMPORTANT
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
}
