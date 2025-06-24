import 'package:flutter/material.dart';
import 'package:sticker_app/models/category.dart';
import 'package:sticker_app/services/category_api.dart';

class CategoryProvider with ChangeNotifier {
  CategoryProvider() : super();

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    try {
      final categories = await CategoryApi.fetchCategories();
      _categories = categories;
      _isLoading = false;
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCustomCategory(String name) async {
    _isLoading = true;
    try {
      final newCategory = Category(id: '', name: name, imagePath: '', price: 0);
      final created = await CategoryApi.createCategory(newCategory);
      _categories = [..._categories, created];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating category: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
