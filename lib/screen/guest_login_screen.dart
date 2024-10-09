import 'dart:async';

import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/guest_login_provider.dart';

/// Class represents the guest login screen of the app.
/// It allows users to create a guest session for accessing the app
/// without a permanent account.
class GuestLoginScreen extends StatefulWidget {
  static const ROUTE_NAME = '/guestlogin';

  const GuestLoginScreen({super.key});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Consumer<GuestSessionProvider>(
        builder: (context, guestSessionProvider, _) {
          // User successfully authenticated, navigate to HomeScreen
          if (guestSessionProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
            });
            return const Text("");
          } else if (guestSessionProvider.errorMessage != null) {
            // Error during authentication, display error message with retry button
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${guestSessionProvider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    guestSessionProvider.createGuestSession();
                  },
                  child: const Text('Retry'),
                ),
              ],
            );
          } else {
            // No guest session yet, display widget to create one
            return Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const AnimatedImage()),
                Container(
                  width: mediaQueryWidth(context),
                  height: mediaQueryHeight(context),
                  color: const Color.fromARGB(126, 0, 0, 0),
                ),
                Positioned(
                  bottom: 100,
                  child: SizedBox(
                    width: mediaQueryWidth(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Discover, Explore, Enjoy",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ),
                        spaceH10,
                        const Text(
                          "Get ready to dive into the greatest stories wrapped in captivating films.",
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: mediaQueryWidth(context) / 2,
                          child: ElevatedButton(
                            onPressed: () async {
                              await guestSessionProvider.createGuestSession();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: cGreen,
                                foregroundColor: Colors.white),
                            child: const Text("Watch Now"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      )),
    );
  }
}

/// Creates a widget that displays an animated background image.
class AnimatedImage extends StatefulWidget {
  const AnimatedImage({super.key});

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  /// List of image URLs to be displayed in the animation.
  final List<String> _imageUrls = [
    '$BASE_IMAGE_URL/if8QiqCI7WAGImKcJCfzp6VTyKA.jpg',
    '$BASE_IMAGE_URL/vOX1Zng472PC2KnS0B9nRfM8aaZ.jpg',
    '$BASE_IMAGE_URL/fttoFfKikQMwIoV3UVvlCvBhbUw.jpg',
    '$BASE_IMAGE_URL/rEaJSXAlNfdhRpDHiNcJsoUa9qE.jpg',
    '$BASE_IMAGE_URL/68jNkFi61MQjrJEqj2up5wZ4w5R.jpg',
  ];

  int _currentIndex = 0;
  double _opacity = 1.0;
  Timer? _timer; // Ubah ke nullable untuk mencegah NullPointerException

  @override
  void initState() {
    super.initState();
    // Timer to change image automaticly every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _fadeOutImage();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop timer when widget dispose
    super.dispose();
  }

  void _fadeOutImage() {
    if (!mounted) return;

    setState(() {
      _opacity = 0.0; // Start fade-out animation
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imageUrls.length;
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 500), // Durasi animasi
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_imageUrls[_currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
