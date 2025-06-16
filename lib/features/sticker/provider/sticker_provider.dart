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

  // Gọi cùng lúc để dễ kiểm tra isLoading hay không
  Future<void> loadAllStickers() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final results = await Future.wait([
        StickerApi.fetchAllStickers(),
        StickerApi.fetchProStickers(),
        StickerApi.fetchThumb(),
      ]);

      _allSticker = results[0] as Map<String, List<Sticker>>;
      _proSticker = results[1] as Map<String, List<Sticker>>;
      _thumb = results[2] as List<Sticker>;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  // Future<void> getAllSticker() async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     _allSticker = await StickerApi.fetchAllStickers();
  //   } catch (e) {
  //     _error = e.toString();
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> getProSticker() async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     _proSticker = await StickerApi.fetchProStickers();
  //   } catch (e) {
  //     _error = e.toString();
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> getThumb() async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     _thumb = await StickerApi.fetchThumb();
  //   } catch (e) {
  //     _error = e.toString();
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }
}
