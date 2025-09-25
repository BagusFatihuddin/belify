import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static Future<Map<String, dynamic>> fetchOrders(int userId) async {
    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}orders/user.php?user_id=$userId'),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return {'success': false, 'data': []};
  }
}
