import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/order_detail_service.dart';

class OrderDetailController {
  final String cloudName = 'dshhlawvf';
  final String uploadPreset = 'belify_upload';

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    return await OrderDetailService.fetchOrderDetail(orderId);
  }

  Future<String?> uploadImage(File image) async {
    return await OrderDetailService.uploadPaymentProof(
      image,
      cloudName,
      uploadPreset,
    );
  }

  Future<bool> savePayment({
    required int userId,
    required int orderId,
    required String paymentProofUrl,
  }) async {
    return await OrderDetailService.savePaymentProof(
      userId: userId,
      orderId: orderId,
      paymentProofUrl: paymentProofUrl,
    );
  }
}
