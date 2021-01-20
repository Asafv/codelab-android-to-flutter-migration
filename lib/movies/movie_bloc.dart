import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_migration_workshop/data/api/responses/movies_response.dart';
import 'package:flutter_migration_workshop/models/movie_type.dart';

import '../bloc.dart';
import '../data/tmdb_repository.dart';
import '../models/movie.dart';

class MovieBloc extends Bloc {
  final TmdbRepository _repo = TmdbRepository();

  final _moviesController = StreamController<List<Movie>>();
  Stream<List<Movie>> get moviesStream => _moviesController.stream;

  final _appBarTitleController = StreamController<String>();
  Stream<String> get moviesTypeTitleStream => _appBarTitleController.stream;

  /// create the wanted movies type list
  final List<MovieType> moviesType = [
    MovieType("Now Playing", MoviesType.NOW_PLAYING),
    MovieType("Top Rated", MoviesType.TOP_RATED),
    MovieType("Popular", MoviesType.POPULAR),
    MovieType("Upcoming", MoviesType.UPCOMING)
  ];

  /// Cached data inside the bloc
  MoviesType _currentType;
  List<Movie> movies = List();
  int page = 1;

  MovieBloc() {
    getMoviesByType(moviesType[0]);
  }

  @override
  void dispose() {
    debugPrint('MovieBloc dispose');
    _moviesController.close();
    _appBarTitleController.close();
  }

  Future<Movie> getMovieDetails(int id) async => await _repo.getMovieById(id);

  void fetchMovies({bool isBottomReached = false, MoviesType type}) async {
    if (isBottomReached) {
      page++;
    }

    debugPrint(
        "fetchMovies, isBottomReached: $isBottomReached type: $type, page: $page");

    // if type was changed, clear the list
    if (_currentType != type) {
      _currentType = type;
      movies.clear();
      _moviesController.sink.add(movies);
    }

    MoviesResponse res = await _repo.getMovies(_currentType, page: page);

    /// Error handling
    if (res.error != null) {
      debugPrint("response error: ${res.error}");
      // TODO: display a toast or an error widget
      return;
    }

    /// add to the cached movies list and then update the UI
    movies.addAll(res.results);
    _moviesController.sink.add(movies);

    debugPrint("movies.length: ${movies.length}");
  }

  void getMoviesByType(MovieType type) {
    debugPrint('getMoviesByType: ${type.name} - ${type.type}');

    _appBarTitleController.add("${type.name} Movies");
    fetchMovies(type: type.type);
  }
}
