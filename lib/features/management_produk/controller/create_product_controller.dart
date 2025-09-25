import '../services/cloudinary_service.dart';
import '../models/product_model.dart';
import 'package:belify/shared/services/api_base.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateProductController {
  Future<String?> uploadImage(String path) =>
      CloudinaryService.uploadImage(path);

  Future<Map<String, dynamic>> createProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}produk/create.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: product.toMap(),
    );

    try {
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'msg': 'Invalid JSON'};
    }
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:http/http.dart' as http;

// class CreateProductController {
//   final cloudName = 'dshhlawvf';
//   final uploadPreset = 'belify_upload';

//   Future<String?> uploadImageToCloudinary(File imageFile) async {
//     final url = Uri.parse(
//       'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
//     );

//     final request =
//         http.MultipartRequest('POST', url)
//           ..fields['upload_preset'] = uploadPreset
//           ..files.add(
//             await http.MultipartFile.fromPath('file', imageFile.path),
//           );

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final resStr = await response.stream.bytesToString();
//       final data = json.decode(resStr);
//       return data['secure_url'];
//     } else {
//       return null;
//     }
//   }

//   Future<Map<String, dynamic>> createProduct({
//     required String nama,
//     required String harga,
//     required String diskon,
//     required String deskripsi,
//     required String stok,
//     required String gambarUrl,
//   }) async {
//     final response = await http.post(
//       Uri.parse('${ApiBase.baseUrl}produk/create.php'),
//       headers: {"Content-Type": "application/x-www-form-urlencoded"},
//       body: {
//         'nama': nama,
//         'harga': harga,
//         'diskon': diskon,
//         'deskripsi': deskripsi,
//         'stok': stok,
//         'gambar1': gambarUrl,
//         'gambar2': '',
//         'gambar3': '',
//       },
//     );

//     // DEBUG PRINT RESPONSE
//     print('Status Code: ${response.statusCode}');
//     print('Body: ${response.body}');

//     try {
//       final data = json.decode(response.body);
//       return data;
//     } catch (e) {
//       print('Gagal decode JSON: $e');
//       return {'status': false, 'msg': 'Response bukan JSON: ${response.body}'};
//     }
//   }
// }
