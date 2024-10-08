import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/favorite_provider.dart';
import 'package:dmb_app/provider/watchlist_provider.dart';
import 'package:dmb_app/widget/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const ROUTE_NAME = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              indicatorColor: Colors.amber,
              padding: const EdgeInsets.all(16),
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: const EdgeInsets.symmetric(vertical: 8),
              tabs: [
                _menuButton(
                    title: "Watchlist",
                    icon: FontAwesomeIcons.clock,
                    onTap: () {},
                    color: cGreen),
                _menuButton(
                    title: "Favorite",
                    icon: FontAwesomeIcons.heart,
                    onTap: () {},
                    color: Colors.red[400]!),
              ]),
        ),
        body: const Flexible(
          child:
              const TabBarView(children: [WatchlistMovie(), FavoriteMovie()]),
        ),
      ),
    );
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

class WatchlistMovie extends StatelessWidget {
  const WatchlistMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Consumer<WatchlistProvider>(
        builder: (context, state, _) {
          if (state.watchlistMovies == null || state.watchlistMovies!.isEmpty) {
            return const Center(
              child: Text("Belum ada item di watchlist"),
            );
          } else {
            return ListView.builder(
              itemCount: state.watchlistMovies!.length,
              itemBuilder: (context, index) {
                var movieData = state.watchlistMovies![index];
                return MovieCard(movieData);
              },
            );
          }
        },
      ),
    );
  }
}


class FavoriteMovie extends StatelessWidget {
  const FavoriteMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Consumer<FavoriteProvider>(
        builder: (context, state, _) {
          if (state.favoriteMovies == null || state.favoriteMovies!.isEmpty) {
            return const Center(
              child: Text("Belum ada item di favorite"),
            );
          } else {
            return ListView.builder(
              itemCount: state.favoriteMovies!.length,
              itemBuilder: (context, index) {
                var movieData = state.favoriteMovies![index];
                return MovieCard(movieData);
              },
            );
          }
        },
      ),
    );
  }
}
