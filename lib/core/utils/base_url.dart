import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static String get userUrl => dotenv.env['USER_URL'] ?? '';
  static String get stickerUrl => dotenv.env['STICKER_URL'] ?? '';
  static String get remove_bg_token => dotenv.env['REMOVE-BG-TOKEN'] ?? '';
}
