import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

double mediaQueryWidth(context) => MediaQuery.of(context).size.width;
double mediaQueryHeight(context) => MediaQuery.of(context).size.height;

Widget spaceH10 = const SizedBox(height: 10);
Widget spaceH30 = const SizedBox(height: 30);
Widget spaceH50 = const SizedBox(height: 50);

Widget spaceW10 = const SizedBox(width: 10);
Widget spaceW30 = const SizedBox(width: 30);
Widget spaceW50 = const SizedBox(width: 50);


/// Show shackbar with message
void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const  Duration(seconds: 1),),
  );
}

/// Fungsi untuk mengunduh gambar dari URL dan menyimpannya ke penyimpanan lokal.
///
/// [imageUrl] adalah URL gambar yang ingin diunduh.
/// [fileName] adalah nama file yang akan digunakan saat menyimpan gambar ke penyimpanan lokal.
Future<String> saveImageToLocal(String imageUrl, String fileName) async {
  try {
    // Mendapatkan direktori penyimpanan lokal.
    final directory = await getApplicationDocumentsDirectory();

    // Membuat jalur file berdasarkan nama file dan direktori lokal.
    final filePath = '${directory.path}/$fileName';

    // Mengunduh gambar dari URL.
    final response = await http.get(Uri.parse(imageUrl));

    // Mengecek apakah gambar berhasil diunduh.
    if (response.statusCode == 200) {
      // Membuat file di jalur yang telah ditentukan.
      final file = File(filePath);

      // Menyimpan konten gambar ke file.
      await file.writeAsBytes(response.bodyBytes);

      print('Gambar berhasil disimpan ke: $filePath');
      return filePath; // Mengembalikan jalur file gambar yang disimpan.
    } else {
      print('Gagal mengunduh gambar: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Terjadi kesalahan: $e');
    return '';
  }
}
