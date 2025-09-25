import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartController {
  Future<List<CartItemModel>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}cart/index.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 'success' && body['data'] != null) {
        List data = body['data'];
        return data.map((e) => CartItemModel.fromJson(e)).toList();
      } else {
        throw Exception(body['message'] ?? 'Data keranjang kosong');
      }
    } else {
      throw Exception('Gagal ambil data keranjang');
    }
  }
  //================================================

  Future<void> updateQuantity({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}cart/update.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ KIRIM TOKEN DI SINI
      },
      body: jsonEncode({'product_id': productId, 'jumlah': quantity}),
    );

    print('UPDATE STATUS: ${response.statusCode}');
    print('UPDATE BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal update jumlah item');
    }
  }
}
