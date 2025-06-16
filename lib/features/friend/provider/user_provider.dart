import 'package:flutter/material.dart';
import 'package:sticker_app/models/user.dart';
import 'package:sticker_app/services/user_api.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;

    // Thông báo cho widget dữ liệu đã thay đổi cần rebuild
    notifyListeners();

    try {
      _users = await UserApi.fetchUsers();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }
}
