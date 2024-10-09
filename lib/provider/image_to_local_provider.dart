import 'package:dmb_app/common/utils.dart';
import 'package:flutter/material.dart';

import '../common/state_enum.dart';

/// Provider to save image to local
class ImageToLocalProvider with ChangeNotifier {
  String? _savedImagePath;
  String? get savedImagePath => _savedImagePath;

  String? _message;
  String? get message => _message;

  ResultState? _state;
  ResultState? get state => _state;

  /// a function to save image to local
  Future<void> saveImage(String imageUrl, String fileName) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      /// create path to save image
      String savedPath = await saveImageToLocal(imageUrl, fileName);

      if (savedPath.isNotEmpty) {
        _savedImagePath = savedPath;
        _message = "Image saved successfully at $savedPath";
        _state = ResultState.success;
      } else {
        _state = ResultState.success;
        _message = "Kindly check your gallery";
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error saving image: $e';
    } finally {
      notifyListeners();
    }
  }
}
