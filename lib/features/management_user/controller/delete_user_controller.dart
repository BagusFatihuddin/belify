import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteUserController {
  static Future<bool> deleteUser({
    required int id,
    required BuildContext context,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiBase.baseUrl}users/delete.php"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id": id}),
      );

      final result = json.decode(response.body);

      if (result['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ ${result['message']}")));
        return true;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ ${result['message']}")));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      return false;
    }
  }
}
