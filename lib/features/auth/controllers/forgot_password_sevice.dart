import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // static const baseUrl = 'http://192.168.233.123/ecommerce_api/auth';

  static Future<bool> checkEmail(String email, BuildContext context) async {
    if (email.isEmpty) {
      _showMessage(context, 'Email tidak boleh kosong');
      return false;
    }

    final url = Uri.parse('${ApiBase.baseUrl}auth/forgot_password.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        _showMessage(context, 'Email ditemukan, klik Send Code');
        return true;
      } else {
        _showMessage(context, jsonData['message'] ?? 'Email tidak ditemukan');
        return false;
      }
    } catch (e) {
      _showMessage(context, 'Gagal terhubung ke server');
      return false;
    }
  }

  static Future<bool> sendOtp(String email, BuildContext context) async {
    final url = Uri.parse('${ApiBase.baseUrl}auth/send_otp.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        return true;
      } else {
        _showMessage(context, jsonData['message'] ?? 'Gagal mengirim kode');
        return false;
      }
    } catch (e) {
      _showMessage(context, 'Gagal terhubung ke server');
      return false;
    }
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
