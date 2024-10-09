// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dmb_app/screen/profile_screen.dart';
import 'package:dmb_app/widget/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/movie_list_provider.dart';

import '../common/constant.dart';
import '../data/models/Movie.dart';
import '../widget/movie_card_list.dart';

/// A screen that displays a list of movies.
///
/// The [HomeScreen] class fetches and displays two categories of movies:
/// "Now Playing" and "Popular". It provides a user interface for
/// interacting with these movie lists.
class HomeScreen extends StatefulWidget {
  static const ROUTE_NAME = '/homescreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetches now playing movies and popular movies
    /// when the screen is initialized.
    Future.microtask(
        () => Provider.of<MovieListProvider>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  // User login with guest session authentication.
                  "Hello, Guest!",
                  style: TextStyle(
                    color: cGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle:
                    const Text("All your favorite movies, at your fingertips."),
                trailing: CircleAvatar(
                    radius: 30,
                    backgroundColor: cGreen05,
                    child: IconButton(
                        onPressed: () => Navigator.pushNamed(
                            context, ProfileScreen.ROUTE_NAME),
                        icon: const FaIcon(FontAwesomeIcons.userAstronaut))),
              ),
              spaceH30,

              /// Display [List] of now playing movies from Tmdb API
              const SubHeading(title: "Now Playing Movies"),
              spaceH10,
              Consumer<MovieListProvider>(builder: (context, data, _) {
                final state = data.nowPlayingState;
                if (state == ResultState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == ResultState.success) {
                  return MovieList(data.nowPlayingMovies!);
                } else {
                  return const Text('Failed');
                }
              }),
              spaceH30,

              /// Display [List] of popular movies from Tmdb API
              const SubHeading(title: "Popular Movies"),
              spaceH10,
              Consumer<MovieListProvider>(builder: (context, data, _) {
                final state = data.popularState;
                if (state == ResultState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == ResultState.success) {
                  return MovieList(data.popularMovies!);
                } else {
                  print(data.popularError);
                  return const Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    ));
  }
}

/// A widget that displays a horizontal list of movies.
///
/// This widget takes a list of [Movie] objects and displays them
/// using a horizontal scrolling `ListView`.
class MovieList extends StatelessWidget {
  /// Takes a [List<Movie>] as a parameter.
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCardList(movie: movie);
        },
        itemCount: movies.length,
      ),
    );
  }
}
