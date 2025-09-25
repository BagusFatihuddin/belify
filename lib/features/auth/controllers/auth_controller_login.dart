import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';
import '../../home/screen/home_screen.dart';

class AuthController {
  // ======================= LOGIN BIASA ==========================
  static Future<void> loginUser({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    try {
      final data = await AuthService.login(email, password);

      if (data['token'] != null && data['user'] != null) {
        await _handleLoginSuccess(context, data, fromGoogle: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  // ======================= LOGIN GOOGLE ==========================
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '958710853688-mu9pvm3338ekff4psnvk388s53b00nnl.apps.googleusercontent.com',
  );

  static Future<void> loginWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // biar bisa milih akun lagi

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Login Google dibatalkan oleh user');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("ID Token dari Google tidak ditemukan");
      }

      final data = await AuthService.googleLogin(idToken);

      if (data['token'] != null && data['user'] != null) {
        await _handleLoginSuccess(context, data, fromGoogle: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? 'Login Google gagal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error Google Sign-In: $e')));
    }
  }

  // ======================= PENYIMPANAN & NAVIGASI ==========================
  static Future<void> _handleLoginSuccess(
    BuildContext context,
    Map data, {
    bool fromGoogle = false,
  }) async {
    final user = data['user'];
    final token = data['token'];
    final role = user['role'];
    final userId = user['id'];
    final userName = user['nama'] ?? '';
    final userEmail = user['email'] ?? '';
    final userPhone = user['nomor_hp'] ?? '';
    final userAddress = user['alamat'] ?? '';
    final userPhotoUrl =
        (user['foto'] ??
                'https://res.cloudinary.com/dshhlawvf/image/upload/v1751117398/images_adugdp.png')
            .toString();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setInt('user_id', userId);
    await prefs.setString('user_name', userName);
    await prefs.setString('user_email', userEmail);
    await prefs.setString('user_phone', userPhone);
    await prefs.setString('user_address', userAddress);
    await prefs.setString('user_photo', userPhotoUrl);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(role: role)),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data['message'] ??
              (fromGoogle ? 'Login Google berhasil' : 'Login berhasil'),
        ),
      ),
    );
  }
}
