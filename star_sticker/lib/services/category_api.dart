import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:star_sticker/utils/base_url.dart';
import 'package:star_sticker/models/category.dart';

class CategoryApi {
  const CategoryApi._();

  static final String _api = BaseUrl.categoryUrl;

  static Future<List<Category>> fetchCategories() async {
    final http.Response response = await http.get(
      Uri.parse(_api),
      headers: {'apikey': BaseUrl.apiKey, 'Authorization': 'Bearer ${BaseUrl.apiKey}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories. Status: ${response.statusCode}');
    }
  }

  static Future<Category> createCategory(Category category) async {
    final response = await http.post(
      Uri.parse(_api),
      headers: {
        'apikey': BaseUrl.apiKey,
        'Authorization': 'Bearer ${BaseUrl.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }
}
