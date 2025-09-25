import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:belify/shared/services/api_base.dart';

class AdminOrderService {
  static Future<Map<String, dynamic>?> fetchOrderDetail(int orderId) async {
    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}admin/orders/detail.php?order_id=$orderId'),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success']) return data;
    }
    return null;
  }

  static Future<bool> updateStatus(int orderId, String status) async {
    final res = await http.post(
      Uri.parse('${ApiBase.baseUrl}admin/orders/update_status.php'),
      body: {'order_id': orderId.toString(), 'status': status},
    );
    final data = jsonDecode(res.body);
    return data['success'] ?? false;
  }

  static Future<bool> deleteOrder(int orderId) async {
    final res = await http.post(
      Uri.parse('${ApiBase.baseUrl}admin/orders/delete.php'),
      body: {'order_id': orderId.toString()},
    );
    final data = jsonDecode(res.body);
    return data['success'] ?? false;
  }
}
