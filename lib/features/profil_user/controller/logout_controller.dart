import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController {
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Hapus semua data user
    await prefs.clear();

    // Arahkan user ke login, dan buang semua halaman sebelumnya
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
