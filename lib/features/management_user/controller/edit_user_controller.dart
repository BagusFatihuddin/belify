import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUserController {
  static Future<bool> updateUser({
    required int id,
    required String nama,
    required String email,
    required String nomorHp,
    required String alamat,
    required String role,
    required BuildContext context,
  }) async {
    final response = await http.put(
      Uri.parse("${ApiBase.baseUrl}users/update.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "id": id,
        "nama": nama,
        "email": email,
        "nomor_hp": nomorHp,
        "alamat": alamat,
        "role": role,
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
