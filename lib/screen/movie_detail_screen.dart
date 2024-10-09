import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmb_app/provider/favorite_provider.dart';
import 'package:dmb_app/widget/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/provider/movie_detail_provider.dart';
import 'package:dmb_app/provider/watchlist_provider.dart';

import '../common/utils.dart';
import '../data/models/Movie.dart';

class MovieDetailScreen extends StatefulWidget {
  static const ROUTE_NAME = '/detail';
  final int id;

  const MovieDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<MovieDetailProvider>(context, listen: false)
        ..fetchDetailMovie(widget.id);

      Provider.of<WatchlistProvider>(context, listen: false)
        ..checkWatchlist(widget.id);

      Provider.of<FavoriteProvider>(context, listen: false)
        ..checkFavorite(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProf = Provider.of<WatchlistProvider>(context, listen: false);
    return Scaffold(body: SafeArea(child: Consumer<MovieDetailProvider>(
      builder: (context, state, _) {
        if (state.detailState == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.detailState == ResultState.success) {
          final movie = state.detailMovie;
          return SafeArea(
            child: MovieDetailContent(
              movie: movie!,
              similiars: state.similarMovies,
              isAddedWatchlist: profileProf.isAddedToWatchlist!,
            ),
          );
        } else {
          return Text(state.errorMessage);
        }
      },
    )));
  }
}

class MovieDetailContent extends StatefulWidget {
  final Movie movie;
  final List<Movie> similiars;
  final bool isAddedWatchlist;

  const MovieDetailContent({
    Key? key,
    required this.movie,
    required this.similiars,
    required this.isAddedWatchlist,
  }) : super(key: key);

  @override
  State<MovieDetailContent> createState() => _MovieDetailContentState();
}

class _MovieDetailContentState extends State<MovieDetailContent> {
  @override
  Widget build(BuildContext context) {
    final watchlistProv = Provider.of<WatchlistProvider>(context);
    final favoriteProv = Provider.of<FavoriteProvider>(context);

    return Stack(
      children: [
        widget.movie.posterPath != null && widget.movie.posterPath!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}',
                width: mediaQueryWidth(context),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              )
            : Container(
                height: 300,
                width: mediaQueryWidth(context),
                color: Colors.grey,
                child: const Center(
                  child: Text('No Image Available'),
                ),
              ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: cBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: 10 / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.movie.voteAverage}')
                              ],
                            ),
                            Text(
                              widget.movie.title!,
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: mediaQueryWidth(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (watchlistProv.isAddedToWatchlist!) {
                                        watchlistProv.removeMovieFromWatchlist(
                                            widget.movie);
                                      } else {
                                        watchlistProv
                                            .addMovieToWatchList(widget.movie);
                                      }
                                      setState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        watchlistProv.isAddedToWatchlist!
                                            ? const Icon(Icons.check)
                                            : const Icon(Icons.add),
                                        const Text('Watchlist'),
                                      ],
                                    ),
                                  ),
                                  Consumer<FavoriteProvider>(
                                    builder: (context, favoriteProv, _) {
                                      return IconButton(
                                        onPressed: () {
                                          if (favoriteProv.isAddedToFavorite!) {
                                            favoriteProv
                                                .removeMovieFromFavorite(
                                                    widget.movie);
                                          } else {
                                            favoriteProv.addMovieToFavorite(
                                                widget.movie);
                                          }
                                          setState(() {});
                                        },
                                        icon: FaIcon(
                                          favoriteProv.isAddedToFavorite!
                                              ? FontAwesomeIcons.solidHeart
                                              : FontAwesomeIcons.heart,
                                          color: Colors.red[400]!,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Overview',
                            ),
                            const SizedBox(height: 10),
                            Text(widget.movie.overview!),

                             Consumer<MovieDetailProvider>(builder: (context, data, _) {
                      if (data.similarState == ResultState.loading) {
                        return const Center(
                          child: const CircularProgressIndicator(),
                        );
                      } else if (data.similarState == ResultState.error) {
                        return Text(data.errorMessage);
                      } else if (data.similarState == ResultState.success) {
                        return Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.similarMovies.length,
                            itemBuilder: (context, index) {
                              final item = data.similarMovies[index];

                              return MovieCardList(movie: item);
                            },
                          ),
                        );
                      } else{
                        return Container();
                      }
                    })
                
                          ],
                        ),
                      ),
                    ),
                   
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: cBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
