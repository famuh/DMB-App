// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/movie_detail_provider.dart';
import 'package:dmb_app/provider/watchlist_provider.dart';
import 'package:dmb_app/widget/movie_card_list.dart';

import '../data/models/Movie.dart';

class MovieDetailScreen extends StatefulWidget {
  static const ROUTE_NAME = '/detail';
  final int id;

  const MovieDetailScreen(
      {Key? key, required this.id})
      : super(key: key);

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
              similiars: state.similiarMovies,

              // masih dummy
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

class MovieDetailContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
        final profileProf = Provider.of<WatchlistProvider>(context, listen: false);

    return Stack(
      children: [
        movie.posterPath != null && movie.posterPath!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                width: mediaQueryWidth(context),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              )
            : Container(
                height: 300, // Adjust the height based on your layout
                width: mediaQueryWidth(context),
                color:
                    Colors.grey, // Placeholder color if no image is available
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
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            Text(
                              movie.title!,
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
                                      if (profileProf.isAddedToWatchlist == true) {
                                        
                                      } else {
                                        profileProf.addMovieToWatchList(movie);
                                      }
                                      // else {
                                      //   await Provider.of<MovieDetailNotifier>(
                                      //           context,
                                      //           listen: false)
                                      //       .removeFromWatchlist(movie);
                                      // }

                                      // final message =
                                      //     Provider.of<MovieDetailNotifier>(context,
                                      //             listen: false)
                                      //         .watchlistMessage;

                                      // if (message ==
                                      //         MovieDetailNotifier
                                      //             .watchlistAddSuccessMessage ||
                                      //     message ==
                                      //         MovieDetailNotifier
                                      //             .watchlistRemoveSuccessMessage) {
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //       SnackBar(content: Text(message)));
                                      // } else {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (context) {
                                      //         return AlertDialog(
                                      //           content: Text(message),
                                      //         );
                                      //       });
                                      // }
                                    },
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                       

                                        
                                          profileProf.isAddedToWatchlist == true
                                            ? const Icon(Icons.check)
                                            : const Icon(Icons.add),
                                        const Text('Watchlist'),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: FaIcon(
                                        FontAwesomeIcons.heart,
                                        color: Colors.red[400]!,
                                      )),
                                ],
                              ),
                            ),

                            // Text(
                            //   _showGenres(movie.genreIds!),
                            // ),
                            // Text(
                            //   _showDuration(movie.),
                            // ),

                            const SizedBox(height: 16),
                            const Text(
                              'Overview',
                              // style: kHeading6,
                            ),
                            spaceH10,

                            Text(
                              movie.overview!,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Similar Movies',
                              // style: kHeading6,
                            ),
                            spaceH10,

                            // disini kendalanya
                            // Consumer<MovieDetailProvider>(
                            //   builder: (context, data, _) {
                            //     if (data.similiarState == ResultState.loading) {
                            //       return const Center(
                            //         child: const CircularProgressIndicator(),
                            //       );
                            //     } else if (data.similiarState ==
                            //         ResultState.error) {
                            //       return Text(data.errorMessage);
                            //     } else if (data.similiarState ==
                            //         ResultState.success) {
                            //       return SizedBox(
                            //         height: 160,
                            //         child: ListView.builder(
                            //           itemCount: similiars.length,
                            //           scrollDirection: Axis.horizontal,
                            //           itemBuilder:
                            //               (BuildContext context, int index) {
                            //             final movieItem = similiars[index];
                            //             return MovieCardList(movie: movieItem);
                            //           },
                            //         ),
                            //       );
                            //     } else {
                            //       return Container();
                            //     }
                            //   },
                            // ),
                      
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
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

  //  String _showGenres(List<int> genres) {
  //   String result = '';
  //   for (var genre in genres) {
  //     result += genre.name + ', ';
  //   }

  //   if (result.isEmpty) {
  //     return result;
  //   }

  //   return result.substring(0, result.length - 2);
  // }

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
