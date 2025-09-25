import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _selectedImage;
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
        _imageUrl = null; // reset
      });
    }
  }

  Future<void> uploadToCloudinary() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    final cloudName = 'dshhlawvf';
    final uploadPreset = 'belify_upload';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    var request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', _selectedImage!.path),
          );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      setState(() {
        _imageUrl = jsonResponse['secure_url'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload gagal: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload ke Cloudinary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text('Pilih Gambar'),
              onPressed: pickImage,
            ),
            SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : uploadToCloudinary,
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Upload ke Cloudinary'),
            ),
            SizedBox(height: 20),
            if (_imageUrl != null)
              SelectableText(
                'Link Gambar:\n$_imageUrl',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
