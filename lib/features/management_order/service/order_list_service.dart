import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belify/shared/services/api_base.dart';

class AdminOrderService {
  static Future<List<dynamic>> fetchOrders() async {
    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}admin/orders/index.php'),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success']) return data['data'];
    }
    return [];
  }
}
