import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';
import 'package:sticker_app/services/sticker_api.dart';

class StickerProvider with ChangeNotifier {
  Map<String, List<Sticker>> _allSticker = {};
  Map<String, List<Sticker>> get allSticker => _allSticker;

  Map<String, List<Sticker>> _proSticker = {};
  Map<String, List<Sticker>> get proSticker => _proSticker;

  List<Sticker> _thumb = [];
  List<Sticker> get thumb => _thumb;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadAllStickers() async {
    _setLoading(true);
    try {
      final [all, pro, thumb] = await Future.wait([
        StickerApi.fetchAllStickers(),
        StickerApi.fetchProStickers(),
        StickerApi.fetchThumb(),
      ]);

      _allSticker = all as Map<String, List<Sticker>>;
      _proSticker = pro as Map<String, List<Sticker>>;
      _thumb = thumb as List<Sticker>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isStickerPro(String type, Sticker sticker) {
    final proList = _proSticker[type];
    if (proList == null) return false;
    return proList.any((s) => s.path == sticker.path);
  }
}
