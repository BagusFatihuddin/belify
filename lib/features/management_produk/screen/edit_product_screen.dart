import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/edit_product_controller.dart';
import '../models/product_model.dart';
import '../utils/snackbar_util.dart';
import '../widgets/custom_textfield.dart';

class EditProductScreen extends StatefulWidget {
  final int id;
  const EditProductScreen({super.key, required this.id});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final controller = EditProductController();
  final _primaryColor = const Color(0xFF1A7F65);
  final _nama = TextEditingController();
  final _harga = TextEditingController();
  final _diskon = TextEditingController();
  final _deskripsi = TextEditingController();
  final _stok = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final product = await controller.getProductById(widget.id);
    if (product != null) {
      setState(() {
        _nama.text = product.nama;
        _harga.text = product.harga;
        _diskon.text = product.diskon;
        _deskripsi.text = product.deskripsi;
        _stok.text = product.stok;
        _imageUrl = product.gambarUrl;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
      _imageUrl = await controller.uploadImage(picked.path);
      if (_imageUrl != null) {
        SnackbarUtil.show(context, 'Upload gambar berhasil');
      } else {
        SnackbarUtil.show(context, 'Upload gagal', color: Colors.red);
      }
    }
  }

  Future<void> _updateProduct() async {
    final product = ProductModel(
      nama: _nama.text,
      harga: _harga.text,
      diskon: _diskon.text,
      deskripsi: _deskripsi.text,
      stok: _stok.text,
      gambarUrl: _imageUrl ?? '',
    );
    final res = await controller.updateProduct(product, widget.id);
    SnackbarUtil.show(
      context,
      res['msg'],
      color: res['status'] ? Colors.green : Colors.red,
    );
  }

  Future<void> _deleteProduct() async {
    final res = await controller.deleteProduct(widget.id);
    SnackbarUtil.show(
      context,
      res['msg'],
      color: res['status'] ? Colors.green : Colors.red,
    );
    if (res['status']) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Produk',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: _primaryColor))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _nama,
                              label: 'Nama Produk',
                              primaryColor: _primaryColor,
                            ),
                            CustomTextField(
                              controller: _harga,
                              label: 'Harga',
                              keyboardType: TextInputType.number,
                              primaryColor: _primaryColor,
                            ),
                            CustomTextField(
                              controller: _diskon,
                              label: 'Diskon (%)',
                              keyboardType: TextInputType.number,
                              primaryColor: _primaryColor,
                            ),
                            CustomTextField(
                              controller: _deskripsi,
                              label: 'Deskripsi',
                              maxLines: 3,
                              primaryColor: _primaryColor,
                            ),
                            CustomTextField(
                              controller: _stok,
                              label: 'Stok',
                              keyboardType: TextInputType.number,
                              primaryColor: _primaryColor,
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  _imageUrl != null
                                      ? Image.network(_imageUrl!, height: 150)
                                      : _imageFile != null
                                      ? Image.file(_imageFile!, height: 150)
                                      : Container(
                                        height: 150,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: _pickImage,
                              icon: const Icon(Icons.image),
                              label: const Text('Pilih & Upload Gambar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _updateProduct,
                      child: Text(
                        'Update Produk',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _deleteProduct,
                      child: Text(
                        'Hapus Produk',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'create_product_screen.dart';

// class EditProductScreen extends StatefulWidget {
//   final int id;

//   const EditProductScreen({super.key, required this.id});

//   @override
//   State<EditProductScreen> createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _primaryColor = const Color(0xFF1A7F65);

//   final TextEditingController _nama = TextEditingController();
//   final TextEditingController _harga = TextEditingController();
//   final TextEditingController _diskon = TextEditingController();
//   final TextEditingController _deskripsi = TextEditingController();
//   final TextEditingController _stok = TextEditingController();

//   String? _imageUrl;
//   File? _imageFile;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchProduct();
//   }

//   Future<void> fetchProduct() async {
//     setState(() => _isLoading = true);
//     final res = await http.get(
//       Uri.parse('${ApiBase.baseUrl}produk/get_by_id.php?id=${widget.id}'),
//     );
//     final data = json.decode(res.body);
//     setState(() {
//       _nama.text = data['nama'];
//       _harga.text = data['harga'];
//       _diskon.text = data['diskon'];
//       _deskripsi.text = data['deskripsi'];
//       _stok.text = data['stok'];
//       _imageUrl = data['gambar1'];
//       _isLoading = false;
//     });
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _imageFile = File(picked.path));
//       await uploadImageToCloudinary(_imageFile!);
//     }
//   }

//   Future<void> uploadImageToCloudinary(File imageFile) async {
//     final url = Uri.parse(
//       'https://api.cloudinary.com/v1_1/dshhlawvf/image/upload',
//     );
//     final request =
//         http.MultipartRequest('POST', url)
//           ..fields['upload_preset'] = 'belify_upload'
//           ..files.add(
//             await http.MultipartFile.fromPath('file', imageFile.path),
//           );

//     final res = await request.send();
//     if (res.statusCode == 200) {
//       final respStr = await res.stream.bytesToString();
//       final data = json.decode(respStr);
//       setState(() => _imageUrl = data['secure_url']);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Gambar berhasil di-upload')));
//     }
//   }

//   Future<void> updateProduct() async {
//     final res = await http.post(
//       Uri.parse('${ApiBase.baseUrl}produk/update.php'),
//       body: {
//         'id': widget.id.toString(),
//         'nama': _nama.text,
//         'harga': _harga.text,
//         'diskon': _diskon.text,
//         'deskripsi': _deskripsi.text,
//         'stok': _stok.text,
//         'gambar1': _imageUrl ?? '',
//         'gambar2': '',
//         'gambar3': '',
//       },
//     );
//     final data = json.decode(res.body);
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(data['msg'])));
//   }

//   Future<void> deleteProduct() async {
//     final res = await http.post(
//       Uri.parse('${ApiBase.baseUrl}produk/delete.php'),
//       body: {'id': widget.id.toString()},
//     );
//     final data = json.decode(res.body);
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(data['msg'])));
//     if (data['status']) Navigator.pop(context);
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: _primaryColor),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: _primaryColor),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         style: GoogleFonts.poppins(),
//         decoration: _inputDecoration(label),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Edit Produk',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body:
//           _isLoading
//               ? Center(child: CircularProgressIndicator(color: _primaryColor))
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             _buildTextField(_nama, 'Nama Produk'),
//                             _buildTextField(
//                               _harga,
//                               'Harga',
//                               keyboardType: TextInputType.number,
//                             ),
//                             _buildTextField(
//                               _diskon,
//                               'Diskon (%)',
//                               keyboardType: TextInputType.number,
//                             ),
//                             _buildTextField(
//                               _deskripsi,
//                               'Deskripsi',
//                               maxLines: 3,
//                             ),
//                             _buildTextField(
//                               _stok,
//                               'Stok',
//                               keyboardType: TextInputType.number,
//                             ),
//                             const SizedBox(height: 16),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child:
//                                   _imageUrl != null
//                                       ? Image.network(_imageUrl!, height: 150)
//                                       : _imageFile != null
//                                       ? Image.file(_imageFile!, height: 150)
//                                       : Container(
//                                         height: 150,
//                                         width: double.infinity,
//                                         color: Colors.grey[200],
//                                         child: Icon(
//                                           Icons.image,
//                                           size: 50,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                             ),
//                             const SizedBox(height: 12),
//                             ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: _primaryColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                               ),
//                               onPressed: pickImage,
//                               icon: Icon(Icons.image),
//                               label: Text('Pilih & Upload Gambar'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       onPressed: updateProduct,
//                       child: Text(
//                         'Update Produk',
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: deleteProduct,
//                       child: Text(
//                         'Hapus Produk',
//                         style: GoogleFonts.poppins(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CreateProductScreen(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Tambah Produk Baru',
//                         style: GoogleFonts.poppins(color: _primaryColor),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
