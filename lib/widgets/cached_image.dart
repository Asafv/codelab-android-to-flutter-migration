import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final double height;
  final double width;

  CachedImage(
    this.imageUrl, {
    this.height = 220,
    this.width = 200,
    this.boxFit = BoxFit.fitWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInCurve: Curves.linear,
      imageUrl: this.imageUrl,
      fit: this.boxFit,
      height: this.height,
      width: this.width,
      placeholder: (context, url) => Container(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: this.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              Text(
                "Image\nNot Found",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent),
              )
            ],
          ),
        ),
      ),
    );
  }
}
