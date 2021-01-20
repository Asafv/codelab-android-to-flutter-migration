import 'package:flutter_migration_workshop/models/movie.dart';

class MoviesResponse {
  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;
  String error;

  MoviesResponse({
    this.dates,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    return MoviesResponse(
      dates: json['dates'] != null ? Dates.fromJson(json['dates']) : null,
      page: json['page'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => Movie.fromJson(i)).toList()
          : null,
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  MoviesResponse.withError(String errorValue) : error = errorValue;
}

class Dates {
  String maximum;
  String minimum;

  Dates({this.maximum, this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      maximum: json['maximum'],
      minimum: json['minimum'],
    );
  }
}
