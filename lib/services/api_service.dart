import 'dart:convert';

import 'package:movieapp/core/constants.dart';
import 'package:http/http.dart'as http;
import 'package:movieapp/models/moviemodel.dart';

class ApiService {
  static Future<List<MovieModel>> fetchMovies({String type = 'popular'}) async {
    try {
      final url = Uri.https(
        "api.themoviedb.org",
        "/3/movie/$type",
        {
          "api_key": AppConstants.apiKey,
        },
      );
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
}
