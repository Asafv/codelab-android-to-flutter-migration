import 'package:flutter_migration_workshop/models/movie.dart';
import 'package:flutter_migration_workshop/models/movie_type.dart';

import 'api/responses/movies_response.dart';
import 'api/tmdb_api.dart';

class TmdbRepository {
  TmdbApi _api = TmdbApi();

  Future<MoviesResponse> getMovies(MoviesType type, {int page = 1}) =>
      _api.getMovies(type, page);

  Future<Movie> getMovieById(int id) => _api.getMovieById(id);
}
