import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const cloudName = 'dshhlawvf';
  static const uploadPreset = 'belify_upload';

  static Future<String?> uploadImage(String path) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['secure_url'];
    }
    return null;
  }
}
