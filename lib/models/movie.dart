import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_migration_workshop/data/api/tmdb_api.dart';
import 'package:uuid/uuid.dart';

class Movie {
  bool adult;
  String backdropPath;
  Object belongsToCollection;
  int budget;
  String homepage;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  int revenue;
  int runtime;
  String status;
  String tagline;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  String error;
  String tag = Uuid().v4();

  Movie({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      budget: json['budget'] ?? 0,
      homepage: json['homepage'],
      id: json['id'],
      imdbId: json['imdb_id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'].toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      revenue: json['revenue'] ?? 0,
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? 'N/A',
      tagline: json['tagline'],
      title: json['title'],
      video: json['video'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
    );
  }

  Movie.withError(String errorValue) : error = errorValue;

  String getPosterUrl(ImageSizes size) {
    return TmdbApi().getImageUrl(this.posterPath, size: size);
  }

  @override
  String toString() {
    return "Movie: $title, $posterPath";
  }

  String getTag() {
    return this.tag;
  }

  String getTitle() {
    return this.title;
  }

  String getBackdropPoster() {
    return TmdbApi().getImageUrl(this.backdropPath, size: ImageSizes.NORMAL);
  }

  String getRating() {
    return "${this.voteAverage}/10 (${this.voteCount})";
  }

  Color getVoteColor() {
    return this.voteAverage >= 6 ? Colors.lightGreen[900] : Colors.red;
  }

  String getOverview() {
    return this.overview;
  }

  String getReleaseDate() {
    return this.releaseDate;
  }

  String getRuntime() {
    return "${this.runtime} minutes";
  }

  String getStatus() {
    return this.status;
  }
}
