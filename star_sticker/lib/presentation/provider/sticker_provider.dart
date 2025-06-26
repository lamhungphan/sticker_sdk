import 'package:flutter/material.dart';
import 'package:star_sticker/models/category.dart';
import 'package:star_sticker/models/sticker.dart';
import 'package:star_sticker/services/category_api.dart';
import 'package:star_sticker/services/sticker_api.dart';

class StickerProvider with ChangeNotifier {
  Map<String, List<Sticker>> _allSticker = {};
  Map<String, List<Sticker>> get allSticker => _allSticker;

  Map<String, List<Sticker>> _premiumSticker = {};
  Map<String, List<Sticker>> get premiumSticker => _premiumSticker;

  List<Sticker> _thumb = [];
  List<Sticker> get thumb => _thumb;

  Map<String, Category> _categoryMap = {};
  Map<String, Category> get categoryMap => _categoryMap;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasData => _allSticker.isNotEmpty;

  /// Load toàn bộ sticker, thumb, premium và category map
  Future<void> loadAllStickers() async {
    _setLoading(true);
    _error = null;

    try {
      final allFuture = StickerApi.fetchAllStickers();
      final proFuture = StickerApi.fetchPremiumStickers();
      final thumbFuture = StickerApi.fetchThumb();
      final categories = await CategoryApi.fetchCategories();

      _allSticker = await allFuture;
      _premiumSticker = await proFuture;
      _thumb = await thumbFuture;
      _categoryMap = {for (var cat in categories) cat.id: cat};
    } catch (e) {
      _error = 'Failed to load stickers: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Kiểm tra sticker có thuộc danh sách premium không
  bool isStickerPremium(String categoryId, Sticker sticker) {
    final premiumList = _premiumSticker[categoryId];
    if (premiumList == null || premiumList.isEmpty) return false;
    return premiumList.any((s) => s.id == sticker.id);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
