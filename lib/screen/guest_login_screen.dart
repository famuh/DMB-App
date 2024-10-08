import 'dart:async';

import 'package:dmb_app/common/constant.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:dmb_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../provider/guest_login_provider.dart';

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
          // Jika proses autentikasi sedang berlangsung
          if (guestSessionProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
            });
            return const Text("Explore, Enjoy !");
          } else if (guestSessionProvider.errorMessage != null) {
            // Jika ada error saat autentikasi
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
            // Tombol untuk membuat Guest Session baru
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const AnimatedImage()
           
                ),
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
                          style: TextStyle(
                            
                          ),),
                          const SizedBox(height: 10,),
                        SizedBox(
                          width: mediaQueryWidth(context)/2,
                          child: ElevatedButton(
                              onPressed: () async {
                                await guestSessionProvider.createGuestSession();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cGreen,
                                foregroundColor: Colors.white
                              ),
                              child: const Text("Watch Now"),),
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

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({super.key});

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
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
    // Timer untuk otomatis mengganti gambar setiap 5 detik
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _fadeOutImage();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Menghentikan timer saat widget di-dispose
    super.dispose();
  }

  void _fadeOutImage() {
    if (!mounted) return; // Tambahkan pengecekan mounted

    setState(() {
      _opacity = 0.0; // Memulai animasi fade-out
    });

    // Setelah animasi fade-out selesai, ganti gambar dan fade-in
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return; // Tambahkan pengecekan mounted sebelum setState
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imageUrls.length;
        _opacity = 1.0; // Animasi fade-in dimulai setelah gambar diganti
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