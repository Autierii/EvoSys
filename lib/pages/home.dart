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

  late PageController _trendingController;
  late PageController _nowPlayingController;

  int _trendingIndex = 0;
  int _nowPlayingIndex = 0;

  List<Movie> _movies = [];
  List<Movie> _trending = [];
  List<Movie> _nowPlaying = [];

@override
  void initState() {
    super.initState();

    // Se quiser evitar problemas, calcule fora do context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isWide = screenWidth > 600;
      final fraction = isWide ? 0.35 : 0.55;

      setState(() {
        _trendingController = PageController(viewportFraction: fraction);
        _nowPlayingController = PageController(viewportFraction: fraction);
      });

      _loadTrending();
      _loadNowPlaying();
    });
  }

  void _resetSearch() {
    _controller.clear();
    setState(() => _movies = []);
  }

  void _loadTrending() async {
    final trending = await _apiService.fetchTrendingMovies();
    setState(() => _trending = trending);
  }

  void _loadNowPlaying() async {
    final nowPlaying = await _apiService.fetchNowPlayingMovies();
    setState(() => _nowPlaying = nowPlaying);
  }

  void _search() async {
    FocusScope.of(context).unfocus();
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final movies = await _apiService.searchMovies(query);
    setState(() => _movies = movies);
  }

  void _goToPage(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
void dispose() {
  _controller.dispose();
  _trendingController.dispose();
  _nowPlayingController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _movies.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final contentWidth = isWide ? 600.0 : double.infinity;
    final viewportFraction = isWide ? 0.35 : 0.55;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Azul claro (blue.shade50)
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1), // Azul escuro (blue.shade900)
        leading: isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _resetSearch,
              )
            : null,
        centerTitle: true,
        title: const Text(
          'EVO System',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: isSearching
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
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCarousel(
                      controller: _trendingController,
                      itemCount: _trending.length,
                      movies: _trending,
                      currentIndex: _trendingIndex,
                      onChanged: (i) => setState(() => _trendingIndex = i),
                      onPrev: () {
                        if (_trendingIndex > 0) {
                          setState(() => _trendingIndex--);
                          _goToPage(_trendingController, _trendingIndex);
                        }
                      },
                      onNext: () {
                        if (_trendingIndex < _trending.length - 1) {
                          setState(() => _trendingIndex++);
                          _goToPage(_trendingController, _trendingIndex);
                        }
                      },
                      viewportFraction: viewportFraction,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Lançamentos Recentes',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCarousel(
                      controller: _nowPlayingController,
                      itemCount: _nowPlaying.length,
                      movies: _nowPlaying,
                      currentIndex: _nowPlayingIndex,
                      onChanged: (i) => setState(() => _nowPlayingIndex = i),
                      onPrev: () {
                        if (_nowPlayingIndex > 0) {
                          setState(() => _nowPlayingIndex--);
                          _goToPage(_nowPlayingController, _nowPlayingIndex);
                        }
                      },
                      onNext: () {
                        if (_nowPlayingIndex < _nowPlaying.length - 1) {
                          setState(() => _nowPlayingIndex++);
                          _goToPage(_nowPlayingController, _nowPlayingIndex);
                        }
                      },
                      viewportFraction: viewportFraction,
                    ),
                  ],
                ),
        ),
      ),
    );

  }

  Widget _buildCarousel({
  required PageController controller,
  required int itemCount,
  required List<Movie> movies,
  required int currentIndex,
  required void Function(int) onChanged,
  required VoidCallback onPrev,
  required VoidCallback onNext,
  required double viewportFraction,
}) {

  return SizedBox(
    height: 280,
    child: Stack(
      children: [
        PageView.builder(
          controller: controller,
          itemCount: itemCount,
          onPageChanged: onChanged,
          itemBuilder: (context, index) {
            final scale = index == currentIndex ? 1.0 : 0.85;
            final movie = movies[index];

            return TweenAnimationBuilder(
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(begin: scale, end: scale),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailsPage(movie: movie)),
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
              ),
            );
          },
        ),
        Positioned(
          left: 0,
          top: 90,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: onPrev,
          ),
        ),
        Positioned(
          right: 0,
          top: 90,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onNext,
          ),
        ),
      ],
    ),
  );
}

        Widget _buildSearchField() {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFBBDEFB), 
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _controller,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
            decoration: const InputDecoration(
              labelText: 'Digite o nome do filme',
              labelStyle: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black54,
              ),
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
            backgroundColor: const Color(0xFF1976D2), // Azul médio (blue.shade700)
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
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
