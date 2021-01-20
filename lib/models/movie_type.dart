enum MoviesType { NOW_PLAYING, TOP_RATED, POPULAR, UPCOMING }

class MovieType {
  final String name;
  final MoviesType type;

  MovieType(this.name, this.type);
}
