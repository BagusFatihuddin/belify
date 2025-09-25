import 'dart:convert';
import '../models/product_model.dart';
import '../services/cloudinary_service.dart';
import 'package:belify/shared/services/api_base.dart';
import 'package:http/http.dart' as http;

class EditProductController {
  Future<ProductModel?> getProductById(int id) async {
    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}produk/get_by_id.php?id=$id'),
    );
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return ProductModel.fromJson(data);
    }
    return null;
  }

  Future<String?> uploadImage(String path) =>
      CloudinaryService.uploadImage(path);

  Future<Map<String, dynamic>> updateProduct(
    ProductModel product,
    int id,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiBase.baseUrl}produk/update.php'),
      body: product.toMap(id: id),
    );
    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final res = await http.post(
      Uri.parse('${ApiBase.baseUrl}produk/delete.php'),
      body: {'id': id.toString()},
    );
    return json.decode(res.body);
  }
}
