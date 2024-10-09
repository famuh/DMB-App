import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

/// A [RouteObserver] that observes the route changes in the app.
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

/// A [GlobalKey] that manages the [NavigatorState].
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Returns the width of the current media query context.
double mediaQueryWidth(context) => MediaQuery.of(context).size.width;

/// Returns the height of the current media query context.
double mediaQueryHeight(context) => MediaQuery.of(context).size.height;

/// Vertical space of 10, 30, and 50 pixels (px)
Widget spaceH10 = const SizedBox(height: 10);
Widget spaceH30 = const SizedBox(height: 30);
Widget spaceH50 = const SizedBox(height: 50);

/// Horizontal space of 10, 30, and 50 pixels (px)
Widget spaceW10 = const SizedBox(width: 10);
Widget spaceW30 = const SizedBox(width: 30);
Widget spaceW50 = const SizedBox(width: 50);

/// Show shackbar with message
void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// A function to download images from a URL and save them to local storage.
///
/// [imageUrl] is the URL of the image to download.
/// [fileName] is the file name to use when saving the image to local storage.
///
///
Future<String> saveImageToLocal(String imageUrl, String fileName) async {
  var status = await Permission.storage.status;
  if (status.isGranted) {
    try {
      // Get local directory
      final directory = await getApplicationDocumentsDirectory();

      // Create filepath to save image
      final filePath = '$directory/$fileName.jpg';

      // Download image from URL
      final response = await http.get(Uri.parse(imageUrl));

      // Check if image download successfully
      if (response.statusCode == 200) {
        // Create file in filePath created
        final file = File(filePath);

        // save image to gallery
        await ImageGallerySaver.saveImage(response.bodyBytes);

        // Save image to local
        await file.writeAsBytes(response.bodyBytes);

        return filePath; // Return image filepath
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  } else {
    await storagePermission(Permission.storage);
    return '';
  }
}

/// A function to request storage permission
///
/// checking sdk version first before request permission
Future<bool> storagePermission(Permission permission) async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;

  if (androidInfo.version.sdkInt >= 30) {
    var permissionStatus = await Permission.manageExternalStorage.request();
    return permissionStatus.isGranted;
  } else {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    } else {
      var requestStatus = await permission.request();
      return requestStatus.isGranted;
    }
  }
}
