import 'package:shared_preferences/shared_preferences.dart';
import '../service/checkout_service.dart';

class CheckoutController {
  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  Future<List<dynamic>> getCartItems(int userId) async {
    final response = await CheckoutService.fetchCart(userId);
    if (response['success']) {
      return response['data'];
    }
    return [];
  }

  int calculateTotal(List<dynamic> cartItems) {
    return cartItems.fold<int>(0, (sum, item) {
      final harga =
          int.tryParse(
            item['harga'].toString().replaceAll(RegExp(r'[^0-9]'), ''),
          ) ??
          0;
      final qty = int.tryParse(item['jumlah'].toString()) ?? 0;
      return sum + (harga * qty);
    });
  }

  Future<Map<String, dynamic>> checkout(int userId, String metode) async {
    return await CheckoutService.createOrder(userId, metode);
  }
}
