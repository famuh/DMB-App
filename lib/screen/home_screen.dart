// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmb_app/screen/movie_detail_screen.dart';
import 'package:dmb_app/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/movie_list_provider.dart';

import '../common/constant.dart';
import '../data/models/Movie.dart';
import '../widget/movie_card_list.dart';

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
                  "Hello, Guest!",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text("Semua film kesukaanmu, dalam genggaman."),
                trailing: IconButton(onPressed: () => Navigator.pushNamed(context, ProfileScreen.ROUTE_NAME), icon: const FaIcon(FontAwesomeIcons.userAstronaut)),
              ),
              spaceH30,
              spaceH30,
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Now Playing"), Text("see all")],
              ),
              Consumer<MovieListProvider>(builder: (context, data, _) {
                final state = data.nowPlayingState;
                if (state == ResultState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == ResultState.success) {
                  return MovieList(data.nowPlayingMovies!);
                } else {
                  print(data.errorMessage);
                  return const Text('Failed');
                }
              }),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Popular"), Text("see all")],
              ),
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

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
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
