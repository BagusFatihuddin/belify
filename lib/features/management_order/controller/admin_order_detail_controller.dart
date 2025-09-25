import '../service/order_detail_service.dart';

class AdminOrderDetailController {
  Future<Map<String, dynamic>?> getOrderDetail(int orderId) async {
    return await AdminOrderService.fetchOrderDetail(orderId);
  }

  Future<bool> updateOrderStatus(int orderId, String status) async {
    return await AdminOrderService.updateStatus(orderId, status);
  }

  Future<bool> deleteOrder(int orderId) async {
    return await AdminOrderService.deleteOrder(orderId);
  }
}
