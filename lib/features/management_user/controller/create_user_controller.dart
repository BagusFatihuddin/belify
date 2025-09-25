// path: lib/features/admin/controller/create_user_controller.dart

import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateUserController {
  static Future<bool> createUser({
    required String nama,
    required String email,
    required String nomorHp,
    required String password,
    required String alamat,
    required String role,
    required BuildContext context,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiBase.baseUrl}users/create.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nama": nama,
        "email": email,
        "nomor_hp": nomorHp,
        "password": password,
        "alamat": alamat,
        "role": role,
        "provider": "manual",
      }),
    );

    final result = json.decode(response.body);

    if (result['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('✅ ${result["message"]}')));
      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ ${result["message"]}')));
      return false;
    }
  }
}
