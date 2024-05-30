import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late String _userKey;

  // Getters
  String get userKey => _userKey;

  void setUserKey(String key) {
    _userKey = key;
    notifyListeners();
  }
}
