import 'package:flutter/material.dart';

import '../models/movie.dart';
import 'movie_bloc.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  /// Create the MovieBloc inside the State
  MovieBloc _bloc = MovieBloc();

  ScrollController _controller = ScrollController();

  /// _scrollListener function will be used as a listener to know when we
  /// have reached the bottom of the list
  // TODO (2): add this scrollListener to the ScrollController attached to Grid list
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      debugPrint("reach the bottom");
      _bloc.fetchMovies(isBottomReached: true);
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      debugPrint("reach the top");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO (7): create a dynamic title
        title: _streamTitle(),

        /// AppBar widget simply has an action [] of movies.widgets which will be displayed after the title.
        /// In Android we would have to use the menu.xml and then inflate it in our view component and also handle the clicks.
        /// If we want the icon to be before the title we can use the `leading` property
        // leading: SOME_WIDGET,
        actions: [
          // TODO (6): create the PopupMenuButton widget with moviesType & attach the onSelected method to the bloc in order to query new data
        ],
      ),

      /// build the grid view with the streamBuilder.
      // TODO (1): create the Grid list with movies. where fetching movies show loading widget.
      body: _loadingView(),
    );
  }

  Widget _loadingView() => Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading..."),
            ),
            Container(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );

  Widget _streamTitle() => Text("Now Playing Movies");

  // TODO (3): navigate to DetailsPage using Navigator with MaterialPageRoute & BlocProvider
  void _openDetailsPage(Movie movie) {
    /// Build Navigation to DetailsPage
  }
}
