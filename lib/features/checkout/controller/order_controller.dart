import 'package:shared_preferences/shared_preferences.dart';
import '../service/order_service.dart';

class OrderController {
  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  Future<List<dynamic>> getOrders(int userId) async {
    final response = await OrderService.fetchOrders(userId);
    if (response['success']) {
      return response['data'];
    }
    return [];
  }
}
