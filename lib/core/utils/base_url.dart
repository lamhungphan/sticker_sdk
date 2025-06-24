import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static String get userUrl => dotenv.env['USER_URL'] ?? '';
  static String get stickerUrl => dotenv.env['STICKER_URL'] ?? '';
  static String get categoryUrl => dotenv.env['CATEGORY_URL'] ?? '';

  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static String get remove_bg_token => dotenv.env['REMOVE-BG-TOKEN'] ?? '';
}
