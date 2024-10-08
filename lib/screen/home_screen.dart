// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/movie_list_provider.dart';

import '../common/constant.dart';
import '../data/models/Movie.dart';

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
              const ListTile(
                title: Text(
                  "Hello, Guest!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("Semua film kesukaanmu, dalam genggaman."),
              ),
              spaceH30,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _menuButton(
                      title: "Watchlist",
                      icon: FontAwesomeIcons.clock,
                      onTap: () {},
                      color: cGreen),
                      spaceW10,
                  _menuButton(
                      title: "Favorite",
                      icon: FontAwesomeIcons.heart,
                      onTap: () {},
                      color: Colors.red[400]!),
                ],
              ),
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

class _menuButton extends StatelessWidget {
  String title;
  IconData icon;
  VoidCallback onTap;
  Color color;

  _menuButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            // color: cGreen,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 2)),
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: color),
            ),
            spaceW10,
            FaIcon(
              icon,
              color: color,
            )
          ],
        ),
      ),
    );
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
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                // Navigator.pushNamed(
                //   context,
                //   MovieDetailPage.ROUTE_NAME,
                //   arguments: movie.id,
                // );
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
        },
        itemCount: movies.length,
      ),
    );
  }
}
