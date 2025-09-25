import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/create_product_controller.dart';
import '../models/product_model.dart';
import '../utils/snackbar_util.dart';
import '../widgets/custom_textfield.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final controller = CreateProductController();
  final _primaryColor = const Color(0xFF1A7F65);

  final _nama = TextEditingController();
  final _harga = TextEditingController();
  final _diskon = TextEditingController();
  final _deskripsi = TextEditingController();
  final _stok = TextEditingController();

  File? _imageFile;
  String? _imageUrl;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
      _imageUrl = await controller.uploadImage(picked.path);
      if (_imageUrl != null) {
        SnackbarUtil.show(context, "Upload gambar berhasil");
      } else {
        SnackbarUtil.show(context, "Upload gagal", color: Colors.red);
      }
    }
  }

  Future<void> submitProduct() async {
    if (_imageUrl == null) {
      SnackbarUtil.show(context, "Gambar belum dipilih", color: Colors.red);
      return;
    }

    final product = ProductModel(
      nama: _nama.text,
      harga: _harga.text,
      diskon: _diskon.text,
      deskripsi: _deskripsi.text,
      stok: _stok.text,
      gambarUrl: _imageUrl!,
    );

    final res = await controller.createProduct(product);
    if (res['status']) {
      SnackbarUtil.show(
        context,
        "Produk berhasil ditambahkan",
        color: Colors.green,
      );
      Navigator.pop(context, true);
    } else {
      SnackbarUtil.show(context, "Gagal: ${res['msg']}", color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Produk',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                          _imageFile != null
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
                      onPressed: pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Pilih Gambar'),
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
              onPressed: submitProduct,
              child: Text(
                'Simpan Produk',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import '../controller/create_product_controller.dart';

// class CreateProductScreen extends StatefulWidget {
//   const CreateProductScreen({super.key});

//   @override
//   State<CreateProductScreen> createState() => _CreateProductScreenState();
// }

// class _CreateProductScreenState extends State<CreateProductScreen> {
//   final _controller = CreateProductController();

//   final TextEditingController _nama = TextEditingController();
//   final TextEditingController _harga = TextEditingController();
//   final TextEditingController _diskon = TextEditingController();
//   final TextEditingController _deskripsi = TextEditingController();
//   final TextEditingController _stok = TextEditingController();

//   final _primaryColor = const Color(0xFF1A7F65);
//   File? _imageFile;
//   String? _imageUrl;

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _imageFile = File(picked.path));
//       final url = await _controller.uploadImageToCloudinary(_imageFile!);
//       if (url != null) {
//         setState(() => _imageUrl = url);
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Upload gambar berhasil")));
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Upload gagal")));
//       }
//     }
//   }

//   Future<void> submitProduct() async {
//     if (_imageUrl == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Gambar belum dipilih"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     try {
//       final res = await _controller.createProduct(
//         nama: _nama.text,
//         harga: _harga.text,
//         diskon: _diskon.text,
//         deskripsi: _deskripsi.text,
//         stok: _stok.text,
//         gambarUrl: _imageUrl!,
//       );

//       if (res['status']) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Produk berhasil ditambahkan"),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context, true);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Gagal: ${res['msg']}"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("Error saat submit produk: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Terjadi kesalahan: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
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
//           'Tambah Produk',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     _buildTextField(_nama, 'Nama Produk'),
//                     _buildTextField(
//                       _harga,
//                       'Harga',
//                       keyboardType: TextInputType.number,
//                     ),
//                     _buildTextField(
//                       _diskon,
//                       'Diskon (%)',
//                       keyboardType: TextInputType.number,
//                     ),
//                     _buildTextField(_deskripsi, 'Deskripsi', maxLines: 3),
//                     _buildTextField(
//                       _stok,
//                       'Stok',
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 16),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child:
//                           _imageFile != null
//                               ? Image.file(_imageFile!, height: 150)
//                               : Container(
//                                 height: 150,
//                                 width: double.infinity,
//                                 color: Colors.grey[200],
//                                 child: Icon(
//                                   Icons.image,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                       ),
//                       onPressed: pickImage,
//                       icon: Icon(Icons.image),
//                       label: Text('Pilih Gambar'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: submitProduct,
//               child: Text(
//                 'Simpan Produk',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
