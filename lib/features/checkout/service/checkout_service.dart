import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:http/http.dart' as http;

class CheckoutService {
  static Future<Map<String, dynamic>> fetchCart(int userId) async {
    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}cart/get.php?user_id=$userId'),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return {'success': false, 'data': []};
  }

  static Future<Map<String, dynamic>> createOrder(
    int userId,
    String metode,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}orders/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'metode_pembayaran': metode,
        'alamat_pengiriman': 'Alamat default user',
      }),
    );

    return jsonDecode(response.body);
  }
}
