import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static String get userUrl => dotenv.env['USER_URL'] ?? '';
 }
