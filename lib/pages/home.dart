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
  final TextEditingController _controller = TextEditingController();

  List<Movie> _movies = [];
  List<Movie> _trending = [];

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  void _resetSearch() {
    _controller.clear();
    setState(() => _movies = []);
  }

  void _loadTrending() async {
    final trending = await _apiService.fetchTrendingMovies();
    setState(() {
      _trending = trending;
    });
  }

  void _search() async {
    FocusScope.of(context).unfocus(); // remove teclado
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final movies = await _apiService.searchMovies(query);
    setState(() {
      _movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _movies.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _resetSearch,
              )
            : null,
        title: const Text('Pesquisar Filmes'),
      ),
      body: isSearching
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 12),
                  _buildSearchButton(),
                  const SizedBox(height: 12),
                  Expanded(child: _buildSearchResults()),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSearchField(),
                const SizedBox(height: 12),
                _buildSearchButton(),
                const SizedBox(height: 24),
                const Text(
                  'Em alta esta semana',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 260,
                  child: PageView.builder(
                    itemCount: _trending.length,
                    controller: PageController(viewportFraction: 0.55),
                    itemBuilder: (context, index) {
                      final movie = _trending[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(movie: movie),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black87,
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

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          labelText: 'Digite o nome do filme',
          border: InputBorder.none,
        ),
        onSubmitted: (_) => _search(),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: _search,
        child: const Text('Buscar'),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: movie.posterPath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w154${movie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Icon(Icons.movie, size: 40),
            title: Text(
              movie.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Lançamento: ${movie.releaseDate.year}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailsPage(movie: movie)),
              );
            },
          ),
        );
      },
    );
  }
}