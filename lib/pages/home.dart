import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import 'details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

    class _HomeScreenState extends State<HomeScreen> {
      final ApiService _apiService = ApiService();
          List<Movie> _movies = [];
        final TextEditingController _controller = TextEditingController();

  @override
    void initState() {
        super.initState();
     _loadPopularMovies();
      }

      void _loadPopularMovies() async {
        final movies = await _apiService.fetchPopularMovies();
        setState(() {
          _movies = movies;
      }
      );

  }

  void _searchMovies(String query) async {
        if (query.isEmpty) {
          _loadPopularMovies();
        } else {
            final movies = await _apiService.searchMovies(query);
        setState(() {
          _movies = movies;
        });
    }
  }

  @override
     Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Filmes'),
            leading: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)
                ),
            ),
        ),
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: _searchMovies,
              decoration: const InputDecoration(
               hintText: 'Buscar filmes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
              Expanded(
              child: GridView.builder(
                   itemCount: _movies.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsPage(movie: movie),
                      ),
                      );
                       },
                   child: Card(
                           child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                            Expanded(
                                child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.cover,
                             ),
                          ),
                          Padding(
                          padding: const EdgeInsets.all(4.0),
                           child: Text(
                             movie.title,
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                          ),
                        ),
                          ],
                        ),
                  ),
                   );
                 },
                ),
              ),
          ],
      ),
    );
  }
}
