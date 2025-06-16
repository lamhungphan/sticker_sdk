import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sticker_app/core/utils/base_url.dart';
import 'package:sticker_app/models/sticker.dart';

class StickerApi {
  const StickerApi._();

  static final String _api = BaseUrl.stickerUrl;

  static Future<Map<String, List<Sticker>>> fetchAllStickers() async {
    final http.Response response = await http.get(Uri.parse(_api));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Sticker> stickers = data.map((json) => Sticker.fromJson(json)).toList();

      final Map<String, List<Sticker>> grouped = {};

      for (var sticker in stickers) {
        final type = sticker.type;

        if (!grouped.containsKey(type)) {
          grouped[type] = [];
        }

        grouped[type]!.add(sticker);
      }
      // debugPrint("Grouped stickers: ${jsonEncode(grouped)}");
      return grouped;
    } else {
      throw Exception('Failed to load all sticker');
    }
  }

  static Future<Map<String, List<Sticker>>> fetchProStickers() async {
    final http.Response response = await http.get(Uri.parse(_api));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Sticker> stickers =
          data.map((json) => Sticker.fromJson(json)).where((sticker) => sticker.isPro == true).toList();

      final Map<String, List<Sticker>> grouped = {};

      for (var sticker in stickers) {
        final type = sticker.type;

        if (!grouped.containsKey(type)) {
          grouped[type] = [];
        }

        grouped[type]!.add(sticker);
      }

      return grouped;
    } else {
      throw Exception('Failed to load pro stickers');
    }
  }

  static Future<List<Sticker>> fetchThumb() async {
    final http.Response response = await http.get(Uri.parse(_api));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
  
      final List<Sticker> stickersThumb = data.map((json) => Sticker.fromJson(json)).toList();

      final Map<String, Sticker> firstOfEachType = {};

      for (final sticker in stickersThumb) {
        if (!firstOfEachType.containsKey(sticker.type)) {
          firstOfEachType[sticker.type] = sticker;
        }
      }
      return firstOfEachType.values.toList();
    } else {
      throw Exception('Failed to load thumb stickers');
    }
  }
}
