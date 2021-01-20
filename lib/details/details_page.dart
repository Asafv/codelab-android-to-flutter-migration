import 'package:flutter/material.dart';
import 'package:flutter_migration_workshop/data/api/tmdb_api.dart';
import 'package:flutter_migration_workshop/models/movie.dart';
import 'package:flutter_migration_workshop/movies/movie_bloc.dart';
import 'package:flutter_migration_workshop/widgets/cached_image.dart';

import '../bloc_provider.dart';

const double _imageHeight = 260;

class DetailsPage extends StatelessWidget {
  final Movie movie;

  DetailsPage({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.getTitle())),
      body: SingleChildScrollView(
        /// Stack is pretty match the same as FrameLayout in Android
        child: Stack(
          children: <Widget>[
            Positioned(
              /// FutureBuilder is used for a single async call
              /// like fetch the movie details in our case
              child: FutureBuilder<Movie>(
                initialData: null,
                // getting the bloc from the BlocProvider
                future: BlocProvider.of<MovieBloc>(context)
                    .getMovieDetails(movie.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // the updated movie model
                    return _detailColumn(snapshot.data);
                  }

                  return _detailColumn(movie);
                },
              ),
            ),

            /// keeping the image in the same hierarchy for Hero animation
            Positioned(top: 10, left: 2, child: _itemImageTile()),
          ],
        ),
      ),
    );
  }

  Widget _itemImageTile() => ClipRRect(
        borderRadius: BorderRadius.circular(5),

        /// Hero Animation transition is done with the Hero widget..
        /// all we need is a unique id (movie.tag)
        child: Hero(
          tag: movie.getTag(),
          child: Container(
            child: CachedImage(
              movie.getPosterUrl(ImageSizes.SMALL),
              height: _imageHeight * 0.72,
              boxFit: BoxFit.fitHeight,
            ),
          ),
        ),
      );

  Widget _detailColumn(Movie movie) => Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                _backdropPoster(movie),
                Container(
                  margin: EdgeInsets.only(top: _imageHeight - 50),
                  child: _itemDetails(movie),
                )
              ],
            ),
            _buildDivider(movie),
            _overview(movie),
            _buildDivider(movie),
            Container(
              child: Padding(
                padding: textPadding(),
                child: Text(
                  "Videos",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      );

  Opacity _backdropPoster(Movie movie) => Opacity(
        opacity: 0.4,
        child: CachedImage(
          movie.getBackdropPoster(),
          width: double.infinity,
        ),
      );

  Widget _itemDetails(Movie movie) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: textPadding(),
            child: Text(
              "${movie.getRating()}",
              textAlign: TextAlign.center,
              style: _headerTextStyle(
                fontSize: 30,
                fontColor: movie.getVoteColor(),
              ),
            ),
          ),
          _headerText("Status: ${movie.getStatus()}"),
          _headerText("Release: ${movie.getReleaseDate()}"),
          _headerText("Duration: ${movie.getRuntime()}"),
          _headerText("Budget: \$${movie.budget}"),
          _headerText("Revenue: \$${movie.revenue}"),
        ],
      );

  Padding _headerText(String text) => Padding(
        padding: textPadding(),
        child: Text(
          "$text",
          style: _headerTextStyle(),
        ),
      );

  Widget _buildDivider(Movie movie) => Divider(
        color: movie.getVoteColor(),
        height: 25,
        indent: 10,
        endIndent: 10,
        thickness: 2,
      );

  EdgeInsets textPadding() => const EdgeInsets.all(6.0);

  TextStyle _headerTextStyle({double fontSize = 20, Color fontColor}) =>
      TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: fontColor);

  Widget _overview(Movie movie) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: textPadding(),
            child: Text(
              "Overview",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: textPadding(),
            child: Text(
              movie.getOverview(),
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
          )
        ],
      );
}
