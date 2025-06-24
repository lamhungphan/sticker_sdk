import 'package:flutter/material.dart';
import 'package:sticker_app/models/sticker.dart';
import 'package:sticker_app/services/sticker_api.dart';

class StickerProvider with ChangeNotifier {
  Map<String, List<Sticker>> _allSticker = {};
  Map<String, List<Sticker>> get allSticker => _allSticker;

  Map<String, List<Sticker>> _premiumSticker = {};
  Map<String, List<Sticker>> get premiumSticker => _premiumSticker;

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
        StickerApi.fetchPremiumStickers(),
        StickerApi.fetchThumb(),
      ]);

      _allSticker = all as Map<String, List<Sticker>>;
      _premiumSticker = pro as Map<String, List<Sticker>>;
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

  bool isStickerPremium(String categoryId, Sticker sticker) {
    final premiumList = _premiumSticker[categoryId];
    if (premiumList == null) return false;
    return premiumList.any((s) => s.imagePath == sticker.imagePath);
  }
}
