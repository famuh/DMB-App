import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/screen/movie_detail_screen.dart';

import 'package:flutter/material.dart';

import '../data/models/Movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            MovieDetailScreen.ROUTE_NAME,
            arguments: movie.id,
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      movie.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: Stack(
                children: [
                   ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_IMAGE_URL/${movie.posterPath}',
                    width: 80,
                    placeholder: (context, url) => const Center(
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  borderRadius: const BorderRadius.all(const Radius.circular(8)),
                ),
              const Row(
                children: [
                  const Icon(Icons.abc),
                  const Icon(Icons.abc, color: Colors.white,),
                ],
              )
                ],
               
              ),
            ),
          ],
        ),
      ),
    );
  }
}


