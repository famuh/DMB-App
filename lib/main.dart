import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/provider/favorite_provider.dart';
import 'package:dmb_app/provider/imate_to_local_provider.dart';
import 'package:dmb_app/provider/movie_detail_provider.dart';
import 'package:dmb_app/provider/movie_list_provider.dart';
import 'package:dmb_app/provider/watchlist_provider.dart';
import 'package:dmb_app/screen/home_screen.dart';
import 'package:dmb_app/screen/movie_detail_screen.dart';
import 'package:dmb_app/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/constant.dart';
import 'provider/guest_login_provider.dart';
import 'screen/guest_login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuestSessionProvider()),
        ChangeNotifierProvider(create: (_) => MovieListProvider()),
        ChangeNotifierProvider(create: (_) => MovieDetailProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ImageToLocalProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: cBlack,
          scaffoldBackgroundColor: cBlack
        ),
        home:  AuthCheck(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeScreen.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case GuestLoginScreen.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const GuestLoginScreen());
            case MovieDetailScreen.ROUTE_NAME:
                final int id = settings.arguments as int;

              return MaterialPageRoute(
                builder: (_) => MovieDetailScreen(id: id),
                settings: settings,
              );
              case ProfileScreen.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const ProfileScreen());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while checking authentication state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Handle any errors
          return const Scaffold(
            body: Center(child: Text('An error occurred!')),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          // If authenticated, show HomeScreen
          return const HomeScreen();
        } else {
          // If not authenticated, show GuestLoginScreen
          return const GuestLoginScreen();
        }
      },
    );
  }

  Future<bool> _checkAuth(BuildContext context) async {
    final guestSessionProvider = Provider.of<GuestSessionProvider>(context, listen: false);
    return guestSessionProvider.isAuthenticated;
  }
}
