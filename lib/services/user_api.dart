import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sticker_app/core/utils/base_url.dart';
import 'package:sticker_app/models/user.dart';

class UserApi {
  const UserApi._();

  static final String _api = BaseUrl.userUrl;

  static Future<List<User>> fetchUsers() async {
    final http.Response response = await http.get(Uri.parse(_api));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
