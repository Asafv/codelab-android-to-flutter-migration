import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_migration_workshop/models/movie.dart';
import 'package:flutter_migration_workshop/models/movie_type.dart';

import 'responses/movies_response.dart';

enum ImageSizes { SMALL, NORMAL, LARGE }

class TmdbApi {
  static final String _token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5OWU0OWUzODg3ZWE0ZWU1NDY1ZTFjNjhhOGNhNmJmMCIsInN1YiI6IjU4NjIyYzgzYzNhMzY4MWE3ZDAzOWQ2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nL8_22Gn19SOJJocosQea2Y2UobbKF9jb5HRHwAiN-0";

  /// EndPoints
  static final String _baseUrl = "https://api.themoviedb.org/3";
  static final String _movieEndpoint = "$_baseUrl/movie";

  /// Images
  static final String _imageUrl = "https://image.tmdb.org/t/p";

  Dio _dio;

  TmdbApi() {
    /// Create Dio Object using baseOptions set receiveTimeout,connectTimeout
    BaseOptions options =
        BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    options.baseUrl = _baseUrl;
    options.headers = {"authorization": "Bearer $_token"};
    _dio = Dio(options);

    /// Interceptors
    _dio.interceptors.add(LogInterceptor());

    final cacheInterceptor = DioCacheManager(
      CacheConfig(
        baseUrl: _baseUrl,
        defaultMaxAge: Duration(days: 14),
      ),
    ).interceptor;

    _dio.interceptors.add(cacheInterceptor);
  }

  Future<MoviesResponse> getMovies(MoviesType type, int page) async =>
      await _getMovies(_getQueryType(type), page);

  String getImageUrl(String path, {ImageSizes size = ImageSizes.SMALL}) {
    switch (size) {
      case ImageSizes.SMALL:
        return "$_imageUrl/w154$path";

      case ImageSizes.NORMAL:
        return "$_imageUrl/w500$path";

      case ImageSizes.LARGE:
        return "$_imageUrl/original$path";

      default:
        return "$_imageUrl/w500$path";
    }
  }

  Future<Movie> getMovieById(int id) async {
    try {
      Response response = await _dio.get("$_movieEndpoint/$id");
      return Movie.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return Movie.withError("$error");
    }
  }

  Future<MoviesResponse> _getMovies(String type, int page) async {
    try {
      Response response = await _dio.get("$_movieEndpoint/$type?page=$page");
      return MoviesResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print(
          "Exception occurred: [type: $type, page: $page]\n-- ERROR: $error stackTrace: $stacktrace");
      return MoviesResponse.withError("$error");
    }
  }

  String _getQueryType(MoviesType type) {
    switch (type) {
      case MoviesType.NOW_PLAYING:
        return "now_playing";
      case MoviesType.TOP_RATED:
        return "top_rated";
      case MoviesType.POPULAR:
        return "popular";
      case MoviesType.UPCOMING:
        return "upcoming";
    }
    return "now_playing";
  }
}
