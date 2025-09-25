import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateProfileController {
  static Future<bool> updateProfile({
    required BuildContext context,
    required String name,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getInt('user_id');

    if (userId == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token atau user ID tidak ditemukan")),
      );
      return false;
    }

    try {
      final response = await http.put(
        Uri.parse('${ApiBase.baseUrl}users/update_profile.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': name.trim(),
          'nomor_hp': phone.trim(),
          'alamat': address.trim(),
        }),
      );

      final result = jsonDecode(response.body);

      if (result['success'] == true) {
        await prefs.setString('user_name', name.trim());
        await prefs.setString('user_phone', phone.trim());
        await prefs.setString('user_address', address.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal update profil')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal terhubung ke server: $e')));
      return false;
    }
  }
}
