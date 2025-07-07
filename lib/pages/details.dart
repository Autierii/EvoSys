import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailsPage extends StatelessWidget {
  final Movie movie;

  const DetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final contentWidth = isWide ? 600.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Azul claro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1), // Azul escuro
        centerTitle: true,
        title: const Text(
          'Detalhes do Filme',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Lançamento: ${movie.releaseDate.year}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  movie.overview,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
