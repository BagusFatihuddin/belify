import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:belify/shared/services/api_base.dart';

class OrderDetailService {
  static Future<Map<String, dynamic>> fetchOrderDetail(int orderId) async {
    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}orders/detail.php?order_id=$orderId'),
    );
    return res.statusCode == 200
        ? jsonDecode(res.body)
        : {'order': null, 'items': []};
  }

  static Future<String?> uploadPaymentProof(
    File image,
    String cloudName,
    String uploadPreset,
  ) async {
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request =
        http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final resStr = await response.stream.bytesToString();
    final result = jsonDecode(resStr);

    if (response.statusCode == 200) return result['secure_url'];
    return null;
  }

  static Future<bool> savePaymentProof({
    required int userId,
    required int orderId,
    required String paymentProofUrl,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiBase.baseUrl}payments/upload.php'),
      body: {
        'order_id': orderId.toString(),
        'user_id': userId.toString(),
        'bukti_pembayaran': paymentProofUrl,
        'rekening_tujuan': 'BCA - 1234567890 (A/N Toko Belify)',
        'metode_pembayaran': 'transfer_manual',
      },
    );

    final body = jsonDecode(res.body);
    return res.statusCode == 200 && body['success'] == true;
  }
}
