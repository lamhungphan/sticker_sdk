import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:star_sticker/models/sticker.dart';
import 'package:star_sticker/utils/base_url.dart';

class StickerApi {
  StickerApi._(); // private constructor

  static final String _api = BaseUrl.stickerUrl;
  static final Map<String, String> _headers = {
    'apikey': BaseUrl.apiKey,
    'Authorization': 'Bearer ${BaseUrl.apiKey}',
  };

  static Uri get _uri => Uri.parse(_api);

  static Future<Map<String, List<Sticker>>> fetchAllStickers() async {
    final response = await http.get(_uri, headers: _headers);
    print('response' + response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final stickers = data.map((e) => Sticker.fromJson(e)).toList();
      return _groupByCategory(stickers);
    } else {
      throw Exception('Failed to load all stickers: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, List<Sticker>>> fetchPremiumStickers() async {
    final response = await http.get(_uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final stickers = data.map((e) => Sticker.fromJson(e)).where((s) => s.isPremium).toList();
      return _groupByCategory(stickers);
    } else {
      throw Exception('Failed to load premium stickers: ${response.statusCode} ${response.body}');
    }
  }

  static Future<List<Sticker>> fetchThumb() async {
    final response = await http.get(_uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final stickers = data.map((e) => Sticker.fromJson(e)).toList();
      final Map<String, Sticker> firstOfEach = {};

      for (final sticker in stickers) {
        firstOfEach.putIfAbsent(sticker.categoryId, () => sticker);
      }

      return firstOfEach.values.toList();
    } else {
      throw Exception('Failed to load thumb stickers: ${response.statusCode} ${response.body}');
    }
  }

  static Future<bool> uploadSticker(Sticker sticker, File imageFile) async {
    final request = http.MultipartRequest('POST', _uri)
      ..headers.addAll(_headers)
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

  static Map<String, List<Sticker>> _groupByCategory(List<Sticker> stickers) {
    final grouped = <String, List<Sticker>>{};
    for (var sticker in stickers) {
      grouped.putIfAbsent(sticker.categoryId, () => []).add(sticker);
    }
    return grouped;
  }
}
