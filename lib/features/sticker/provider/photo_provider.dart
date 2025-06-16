import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sticker_app/core/utils/media_picker.dart';

class PhotoProvider extends ChangeNotifier {
  List<AssetEntity> _assets = [];
  List<AssetEntity> get assets => _assets;

  Map<int, File?> _files = {};
  File? getFile(int index) => _files[index];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Tải danh sách ảnh và thông báo cho UI biết dữ liệu đã thay đổi
  Future<void> fetchMedia() async {
    _isLoading = true;

    notifyListeners();

    _assets = await loadMedia();
    _isLoading = false;

    notifyListeners();
  }

  // Chỉ tải file tương ứng với asset tại vị trí index nếu file đó chưa được tải
  Future<void> loadFileForIndex(int index) async {
    // File tại vị trí đó có rồi thì không làm gì
    if (_files[index] != null) {
      return;
    }

    // Tải File tại vị trí đó
    final file = await _assets[index].file;
    _files[index] = file;

    notifyListeners();
  }

  // Xóa dữ liệu sau khi xử lý xong tránh lỗi
  void clear() {
    _assets = [];
    _files = {};
    _isLoading = true;

    notifyListeners();
  }
}
