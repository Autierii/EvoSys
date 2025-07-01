class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Sem título',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? 'Sem descrição',
      releaseDate: json['release_date'] ?? '',
    );
  }

  int get releaseYear {
    if (releaseDate.isEmpty) return 0;
    return int.tryParse(releaseDate.split('-').first) ?? 0;
  }
}
