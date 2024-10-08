import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/movie_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() =>
        Provider.of<MovieListProvider>(context, listen: false)
          ..fetchNowPlayingMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                // add consumer
              ],
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
