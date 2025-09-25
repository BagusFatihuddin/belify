// import 'dart:convert';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';

// class UpdateProfileScreen extends StatefulWidget {
//   const UpdateProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
// }

// class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();

//   bool _isLoading = false;
//   final _primaryColor = const Color(0xFF1A7F65);

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _nameController.text = prefs.getString('user_name') ?? '';
//       _phoneController.text = prefs.getString('user_phone') ?? '';
//       _addressController.text = prefs.getString('user_address') ?? '';
//     });
//   }

//   Future<void> _updateProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//     final userId = prefs.getInt('user_id');

//     if (userId == null || token.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Token atau user ID tidak ditemukan")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final response = await http.put(
//         Uri.parse('${ApiBase.baseUrl}users/update_profile.php'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'nama': _nameController.text.trim(),
//           'nomor_hp': _phoneController.text.trim(),
//           'alamat': _addressController.text.trim(),
//         }),
//       );

//       final result = jsonDecode(response.body);

//       if (result['success'] == true) {
//         await prefs.setString('user_name', _nameController.text.trim());
//         await prefs.setString('user_phone', _phoneController.text.trim());
//         await prefs.setString('user_address', _addressController.text.trim());

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profil berhasil diperbarui')),
//           );
//           Navigator.pop(context);
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Gagal update profil')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Gagal terhubung ke server: $e')));
//     }

//     setState(() => _isLoading = false);
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: GoogleFonts.poppins(color: _primaryColor),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: _primaryColor),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     int maxLines = 1,
//     TextInputType? keyboardType,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         style: GoogleFonts.poppins(),
//         decoration: _inputDecoration(label),
//       ),
//     );
//   }

//   Widget _buildSaveButton() {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _updateProfile,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _primaryColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//       ),
//       child:
//           _isLoading
//               ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//               : Text(
//                 'Simpan Perubahan',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profil', style: GoogleFonts.poppins()),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildTextField(_nameController, 'Nama Lengkap'),
//                 _buildTextField(
//                   _phoneController,
//                   'Nomor HP',
//                   keyboardType: TextInputType.phone,
//                 ),
//                 _buildTextField(
//                   _addressController,
//                   'Alamat',
//                   maxLines: 2,
//                   keyboardType: TextInputType.text,
//                 ),
//                 const SizedBox(height: 24),
//                 _buildSaveButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
