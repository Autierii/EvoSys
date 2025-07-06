import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../apikey/apikey.dart';

class ApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?query=$query&api_key=$apikey&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      final movies = results.map((json) => Movie.fromJson(json)).toList().cast<Movie>();
      movies.sort((a, b) => b.releaseDate.compareTo(a.releaseDate)); // ordena por data
      return movies;
    } else {
      throw Exception('Falha ao buscar filmes');
    }
  }

  Future<List<Movie>> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/movie/week?api_key=$apikey&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((json) => Movie.fromJson(json)).toList().cast<Movie>();
    } else {
      throw Exception('Erro ao carregar filmes em destaque');
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/now_playing?api_key=$apikey&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((json) => Movie.fromJson(json)).toList().cast<Movie>();
    } else {
      throw Exception('Falha ao buscar lançamentos recentes');
    }
  }
}
