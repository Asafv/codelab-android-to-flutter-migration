import 'package:flutter/material.dart';
import 'package:flutter_migration_workshop/widgets/movie_list_item.dart';

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
      body: StreamBuilder<List<Movie>>(
        initialData: _bloc.movies,
        stream: _bloc.moviesStream,
        builder: (context, snapshot) {
          if (snapshot.data.isNotEmpty) {
            /// GridView is a scrollable, 2D array of movies.widgets.
            /// In Android we would use a RecyclerView in the xml layout with GridLayoutManager
            return GridView.count(
              controller: _controller,
              crossAxisCount: 2,
              childAspectRatio: .65,

              /// List constructor with the data length and items iteration
              /// each iteration will return the ListItem (a custom widget we created).
              /// In Android you will have to use and ViewHolder with the RecyclerViewAdapter
              /// and define the item in xml.
              children: List.generate(
                snapshot.data.length,
                (index) => MovieListItem(
                  itemWidth: 200,
                  movie: snapshot.data[index],
                  onClick: (movie) => debugPrint('onMovieClicked: $movie'),
                ),
              ),
            );
          }
          return _loadingView();
        },
      ),
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
