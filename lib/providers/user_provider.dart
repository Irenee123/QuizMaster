import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _fullName;
  String? _email;

  String? get fullName => _fullName;
  String? get email => _email;

  Future<void> saveUserData({required String fullName, required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('email', email);
    _fullName = fullName;
    _email = email;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _fullName = prefs.getString('fullName');
    _email = prefs.getString('email');
    notifyListeners();
  }
}