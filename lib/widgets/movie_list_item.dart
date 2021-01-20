import 'package:flutter/material.dart';
import 'package:flutter_migration_workshop/data/api/tmdb_api.dart';
import 'package:flutter_migration_workshop/models/movie.dart';
import 'package:flutter_migration_workshop/widgets/cached_image.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final Function onClick;
  final double itemWidth;

  MovieListItem({
    Key key,
    @required this.movie,
    @required this.onClick,
    @required this.itemWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      key: key,
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        enableFeedback: true,
        splashColor: Colors.green,
        onTap: () => this.onClick(movie),
        child: Card(
          elevation: 3,
          child: Container(
            color: Colors.transparent,
            width: itemWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Hero(
                      tag: movie.getTag(),
                      child: CachedImage(
                        movie.getPosterUrl(ImageSizes.SMALL),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movie.title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
