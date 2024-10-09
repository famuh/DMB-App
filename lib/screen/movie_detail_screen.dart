// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmb_app/provider/imate_to_local_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/provider/favorite_provider.dart';
import 'package:dmb_app/provider/movie_detail_provider.dart';
import 'package:dmb_app/provider/watchlist_provider.dart';
import 'package:dmb_app/widget/movie_card_list.dart';

import '../common/utils.dart';
import '../data/models/Movie.dart';

/// A stateful screen that displays detailed information about a movie.
///
/// This screen uses several providers to manage data related to the movie details,
/// user's watchlist, and favorites. It supports asynchronous fetching of movie data
/// and provides UI to interact with that data (like adding a movie to the watchlist or favorites).
class MovieDetailScreen extends StatefulWidget {
  /// The route name for navigating to the movie detail screen.
  static const ROUTE_NAME = '/detail';

  /// The unique identifier for the movie to fetch details.
  final int id;

  const MovieDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetches movie details, watchlist status, and favorite status asynchronously
    /// when the screen is initialized.
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
    final watchlistProvider =
        Provider.of<WatchlistProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Consumer<MovieDetailProvider>(
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
                  isAddedWatchlist: watchlistProvider.isAddedToWatchlist!,
                ),
              );
            } else {
              return Text(state.errorMessage);
            }
          },
        ),
      ),
    );
  }
}

/// A widget that displays the detailed content of a movie.
///
/// This widget displays the movie's overview, rating, release date,
/// and provides buttons for adding the movie to the watchlist or favorites.
/// It also shows a list of similar movies.
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
    return Stack(
      children: [
        // Display the movie poster image, or show a placeholder if not available.
        widget.movie.posterPath != null && widget.movie.posterPath!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: '$BASE_IMAGE_URL${widget.movie.posterPath}',
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
        // A draggable sheet for movie details.
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: cBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display movie rating and title.
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.movie.voteAverage! / 2,
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
                            Text(
                              "Release Date: ${widget.movie.releaseDate}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white54,
                                  fontStyle: FontStyle.italic),
                            ),
                            // Watchlist and Favorite buttons.
                            SizedBox(
                              width: mediaQueryWidth(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Button to add/remove movie from watchlist.
                                  Consumer<WatchlistProvider>(
                                    builder: (context, watchlistProv, _) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          if (watchlistProv
                                              .isAddedToWatchlist!) {
                                            watchlistProv
                                                .removeMovieFromWatchlist(
                                                    widget.movie);
                                            showCustomSnackBar(context,
                                                watchlistProv.watchlistMessage);
                                          } else {
                                            watchlistProv.addMovieToWatchList(
                                                widget.movie);
                                            showCustomSnackBar(context,
                                                watchlistProv.watchlistMessage);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            watchlistProv.isAddedToWatchlist!
                                                ? const Icon(Icons.check)
                                                : const Icon(Icons.add),
                                            const Text('Watchlist'),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  // Button to add/remove movie from favorites.
                                  Consumer<FavoriteProvider>(
                                    builder: (context, favoriteProv, _) {
                                      return IconButton(
                                        onPressed: () {
                                          if (favoriteProv.isAddedToFavorite!) {
                                            favoriteProv
                                                .removeMovieFromFavorite(
                                                    widget.movie);
                                            showCustomSnackBar(context,
                                                favoriteProv.favoriteMessage);
                                          } else {
                                            favoriteProv.addMovieToFavorite(
                                                widget.movie);
                                            showCustomSnackBar(context,
                                                favoriteProv.favoriteMessage);
                                          }
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
                            // Display movie overview.
                            const _SubHeading(title: "Overview"),
                            const SizedBox(height: 10),
                            Text(widget.movie.overview!),
                            const SizedBox(height: 16),
                            // Display similar movies.
                            const _SubHeading(title: "Similar Movies"),
                            Consumer<MovieDetailProvider>(
                              builder: (context, data, _) {
                                if (data.similarState == ResultState.loading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (data.similarState ==
                                    ResultState.error) {
                                  return Text(data.errorMessage);
                                } else if (data.similarState ==
                                    ResultState.success) {
                                  return SizedBox(
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
                                } else {
                                  return Container();
                                }
                              },
                            ),
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

        // Navigation buttons (back and download).
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            _NavButton(
              onPressed: () async {
                final imageProv =
                    Provider.of<ImageToLocalProvider>(context, listen: false);
                await imageProv.saveImage(
                    "$BASE_IMAGE_URL${widget.movie.posterPath}",
                    "${widget.movie.title}-image");

                if (imageProv.state == ResultState.success) {
                  showCustomSnackBar(context, imageProv.message!);
                } else if (imageProv.state == ResultState.error) {
                  showCustomSnackBar(context, imageProv.message!);
                }
              },
              icon: const FaIcon(FontAwesomeIcons.download),
            ),
          ],
        ),
      ],
    );
  }
}

/// A reusable widget for navigation buttons.
class _NavButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const _NavButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipOval(
        child: Material(
          color: Colors.black26, // Button background color.
          child: InkWell(
            splashColor: Colors.white30, // Splash color when pressed.
            onTap: onPressed,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}

/// A reusable subheading widget for sections in the movie detail view.
class _SubHeading extends StatelessWidget {
  final String title;

  const _SubHeading({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
