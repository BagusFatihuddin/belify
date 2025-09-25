import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../../home/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  // ==================== REGISTER LOKAL ====================
  static Future<void> registerUser({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required TextEditingController addressController,
  }) async {
    // final url = Uri.parse(
    //   'http://192.168.233.123/ecommerce_api/auth/register.php',
    // );

    final url = Uri.parse("${ApiBase.baseUrl}auth/register.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nameController.text.trim(),
          "email": emailController.text.trim(),
          "nomor_hp": phoneController.text.trim(),
          "password": passwordController.text.trim(),
          "alamat": addressController.text.trim(),
          "provider": "local",
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint('📩 Register Response: $data');

      if (context.mounted) {
        if (data['success'] == true) {
          await _handleSuccessLogin(context, data);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Berhasil daftar sebagai customer!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Gagal daftar.')),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ ERROR registerUser: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal terhubung ke server: $e')),
        );
      }
    }
  }

  // ==================== REGISTER DENGAN GOOGLE ====================
  static Future<void> registerWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            '958710853688-mu9pvm3338ekff4psnvk388s53b00nnl.apps.googleusercontent.com',
      );

      await googleSignIn.signOut(); // biar bisa pilih akun
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('ID Token Google kosong');
      }

      // final response = await http.post(
      //   Uri.parse(
      //     'http://192.168.233.123/ecommerce_api/auth/register_with_google.php',
      //   ),
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}auth/register_with_google.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      final data = jsonDecode(response.body);
      debugPrint("Google register response: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          await _handleSuccessLogin(context, data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Registrasi berhasil")),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data['error'] ?? 'Gagal daftar/login dengan Google',
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Google Register error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error Google Register: $e")));
      }
    }
  }

  // ==================== HANDLE SIMPAN USER & ARAHKAN KE HOME ====================
  static Future<void> _handleSuccessLogin(
    BuildContext context,
    Map data,
  ) async {
    final user = data['user'];
    final token = data['token'];

    final userPhone = user['nomor_hp'] ?? '';
    final userAddress = user['alamat'] ?? '';
    final userPhotoUrl =
        (user['foto'] ??
                'https://res.cloudinary.com/dshhlawvf/image/upload/v1751117398/images_adugdp.png')
            .toString();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('user_id', user['id']);
    await prefs.setString('user_name', user['nama'] ?? '');
    await prefs.setString('user_email', user['email'] ?? '');
    await prefs.setString('role', user['role'] ?? '');
    await prefs.setString('user_phone', userPhone);
    await prefs.setString('user_address', userAddress);
    await prefs.setString('user_photo', userPhotoUrl);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(role: user['role'] ?? 'customer'),
      ),
    );
  }
}
