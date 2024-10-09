import 'package:dmb_app/common/state_enum.dart';
import 'package:dmb_app/common/utils.dart';
import 'package:flutter/foundation.dart';

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
      String savedPath = await saveImageToLocal(imageUrl, fileName);

      if (savedPath.isNotEmpty) {
        _message = "Save image successfully";
        _state = ResultState.success;
      } else {
        _state = ResultState.error;
        _message = "Failed to save image";
      }
    } catch (e) {
      _state = ResultState.error;
      throw Exception('Error saving image: $e');
    } finally {
      notifyListeners();
    }
  }
}
