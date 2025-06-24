import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sticker_app/core/utils/base_url.dart';
import 'package:sticker_app/models/sticker.dart';

class StickerApi {
  const StickerApi._();

  static final String _api = BaseUrl.stickerUrl;

  static Future<Map<String, List<Sticker>>> fetchAllStickers() async {
    final http.Response response = await http.get(
      Uri.parse(_api),
      headers: {'apikey': BaseUrl.apiKey, 'Authorization': 'Bearer ${BaseUrl.apiKey}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Sticker> stickers = data.map((json) => Sticker.fromJson(json)).toList();
      final Map<String, List<Sticker>> grouped = {};

      for (var sticker in stickers) {
        final type = sticker.categoryId;

        if (!grouped.containsKey(type)) {
          grouped[type] = [];
        }

        grouped[type]!.add(sticker);
      }
      return grouped;
    } else {
      throw Exception('Failed to load all sticker');
    }
  }

  static Future<Map<String, List<Sticker>>> fetchPremiumStickers() async {
    final http.Response response = await http.get(
      Uri.parse(_api),
      headers: {'apikey': BaseUrl.apiKey, 'Authorization': 'Bearer ${BaseUrl.apiKey}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Sticker> stickers =
          data.map((json) => Sticker.fromJson(json)).where((sticker) => sticker.isPremium == true).toList();

      final Map<String, List<Sticker>> grouped = {};

      for (var sticker in stickers) {
        final type = sticker.categoryId;

        if (!grouped.containsKey(type)) {
          grouped[type] = [];
        }

        grouped[type]!.add(sticker);
      }

      return grouped;
    } else {
      throw Exception('Failed to load premium stickers');
    }
  }

  static Future<List<Sticker>> fetchThumb() async {
    final http.Response response = await http.get(
      Uri.parse(_api),
      headers: {'apikey': BaseUrl.apiKey, 'Authorization': 'Bearer ${BaseUrl.apiKey}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Sticker> stickersThumb = data.map((json) => Sticker.fromJson(json)).toList();

      final Map<String, Sticker> firstOfEachType = {};

      for (final sticker in stickersThumb) {
        if (!firstOfEachType.containsKey(sticker.categoryId)) {
          firstOfEachType[sticker.categoryId] = sticker;
        }
      }
      return firstOfEachType.values.toList();
    } else {
      throw Exception('Failed to load thumb stickers');
    }
  }

  static Future<bool> uploadSticker(Sticker sticker, File imageFile) async {
    final uri = Uri.parse(_api);

    final request =
        http.MultipartRequest('POST', uri)
          ..fields['id'] = sticker.id
          ..fields['category_id'] = sticker.categoryId
          ..fields['image_path'] = sticker.imagePath
          ..fields['is_premium'] = sticker.isPremium.toString()
          ..fields['status'] = sticker.status
          ..fields['used_count'] = sticker.usedCount.toString()
          ..fields['tags'] = jsonEncode(sticker.tags)
          ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    return response.statusCode == 200;
  }
}
