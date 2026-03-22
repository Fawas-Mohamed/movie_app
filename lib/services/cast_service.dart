import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/core/constants.dart';
import 'package:movieapp/models/castmodel.dart';
class CastService {
  static Future<List<CastModel>> fetchCast(int movieId) async {
  try {
    final url = Uri.https(
      "api.themoviedb.org",
      "/3/movie/$movieId/credits",
      {
        "api_key": AppConstants.apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List cast = decoded['cast'] ?? [];

      return cast
          .take(10)
          .map<CastModel>((json) => CastModel.fromJson(json))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
}
