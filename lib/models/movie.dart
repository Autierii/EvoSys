class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final DateTime releaseDate;

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
      releaseDate: DateTime.tryParse(json['release_date'] ?? '') ?? DateTime(1900),
    );
  }
}
