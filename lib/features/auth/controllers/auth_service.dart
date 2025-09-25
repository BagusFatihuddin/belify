import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belify/shared/services/api_base.dart';

class AuthService {
  /// Login dengan email & password
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("${ApiBase.baseUrl}auth/login.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    // Validasi status code
    if (response.statusCode != 200) {
      return {
        "error": true,
        "message": "Server error: ${response.statusCode}",
        "raw": response.body,
      };
    }

    // Decode JSON
    try {
      return json.decode(response.body);
    } catch (e) {
      return {
        "error": true,
        "message": "Response tidak valid JSON: $e",
        "raw": response.body,
      };
    }
  }

  /// Login via Google Sign In
  static Future<Map<String, dynamic>> googleLogin(String idToken) async {
    final url = Uri.parse("${ApiBase.baseUrl}auth/google-login.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id_token": idToken}),
    );

    print('Google login response status: ${response.statusCode}');
    print('Google login response body: ${response.body}');

    if (response.statusCode != 200) {
      return {
        "error": true,
        "message": "Server error: ${response.statusCode}",
        "raw": response.body,
      };
    }

    try {
      return json.decode(response.body);
    } catch (e) {
      return {
        "error": true,
        "message": "Response tidak valid JSON: $e",
        "raw": response.body,
      };
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   static Future<Map<String, dynamic>> login(
//     String email,
//     String password,
//   ) async {
//     final response = await http.post(
//       // Uri.parse("http://10.0.2.2/ecommerce_api/auth/login.php"),
//       Uri.parse("http://192.168.233.123/ecommerce_api/auth/login.php"),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"email": email, "password": password}),
//     );

//     // Debug log
//     print('Login response status: ${response.statusCode}');
//     print('Login response body: ${response.body}');

//     try {
//       return json.decode(response.body);
//     } catch (e) {
//       // Return error dalam bentuk Map supaya bisa ditangani di Flutter
//       return {
//         "error": true,
//         "message": "Response tidak valid JSON: $e",
//         "raw": response.body,
//       };
//     }
//   }

//   static Future<Map<String, dynamic>> googleLogin(String idToken) async {
//     final response = await http.post(
//       // Uri.parse("http://10.0.2.2/ecommerce_api/auth/google-login.php"),
//       Uri.parse("http://192.168.233.123/ecommerce_api/auth/google-login.php"),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"id_token": idToken}),
//     );

//     // Debug log
//     print('Google login response status: ${response.statusCode}');
//     print('Google login response body: ${response.body}');

//     try {
//       return json.decode(response.body);
//     } catch (e) {
//       return {
//         "error": true,
//         "message": "Response tidak valid JSON: $e",
//         "raw": response.body,
//       };
//     }
//   }
// }
