import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../common/constant.dart';
import '../data/models/Movie.dart';
import '../screen/movie_detail_screen.dart';

/// A widget that displays a card for a movie.
///
/// The [MovieCardList] widget is a clickable card that shows the movie's
/// poster image. When tapped, it navigates to the movie detail screen.
class MovieCardList extends StatelessWidget {
  /// The [movie] parameter is required and cannot be null.
  const MovieCardList({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            MovieDetailScreen.ROUTE_NAME,
            arguments: movie.id,
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
