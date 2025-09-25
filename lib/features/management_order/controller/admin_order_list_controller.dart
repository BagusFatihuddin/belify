import '../service/order_list_service.dart';

class AdminOrderListController {
  Future<List<dynamic>> getOrders() async {
    return await AdminOrderService.fetchOrders();
  }
}
