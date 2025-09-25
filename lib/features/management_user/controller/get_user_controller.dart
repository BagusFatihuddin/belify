import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:belify/features/management_user/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetUserController {
  static Future<List<User>> fetchAllUsers(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}users/get_all.php'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return (data['data'] as List).map((e) => User.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('Fetch user error: $e');
    }
    return [];
  }

  static Future<Map<String, String>> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('user_name') ?? '-',
      'email': prefs.getString('user_email') ?? '-',
    };
  }
}
