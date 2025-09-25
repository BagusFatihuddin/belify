import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> verifyOtp({
  required BuildContext context,
  required String email,
  required String otp,
}) async {
  if (otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter all digits'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}auth/verify_otp.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    final jsonData = jsonDecode(response.body);
    if (jsonData['success']) {
      final token = jsonData['token'];
      Navigator.pushNamed(
        context,
        '/update-password',
        arguments: {'email': email, 'token': token},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonData['message'] ?? 'OTP salah atau expired'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    print("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gagal verifikasi OTP'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

void resendCode(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Code resent successfully'),
      duration: Duration(seconds: 2),
    ),
  );
}
