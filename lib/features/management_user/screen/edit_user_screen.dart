// screens/edit_user_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/edit_user_controller.dart';
import '../widget/custom_textfield.dart';

class EditUserScreen extends StatefulWidget {
  final int id;
  final String nama, email, nomorHp, alamat, role;

  const EditUserScreen({
    super.key,
    required this.id,
    required this.nama,
    required this.email,
    required this.nomorHp,
    required this.alamat,
    required this.role,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _noHpController;
  late final TextEditingController _alamatController;
  late String _selectedRole;

  final _primaryColor = const Color(0xFF1A7F65);

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _emailController = TextEditingController(text: widget.email);
    _noHpController = TextEditingController(text: widget.nomorHp);
    _alamatController = TextEditingController(text: widget.alamat);
    _selectedRole = widget.role;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await EditUserController.updateUser(
        id: widget.id,
        nama: _namaController.text,
        email: _emailController.text,
        nomorHp: _noHpController.text,
        alamat: _alamatController.text,
        role: _selectedRole,
        context: context,
      );
      if (success) Navigator.pop(context);
    }
  }

  Widget _buildDropdownRole() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: DropdownButtonFormField<String>(
      value: _selectedRole,
      items: const [
        DropdownMenuItem(value: 'customer', child: Text('Customer')),
        DropdownMenuItem(value: 'admin', child: Text('Admin')),
      ],
      onChanged: (val) => setState(() => _selectedRole = val!),
      decoration: InputDecoration(
        labelText: "Role",
        labelStyle: GoogleFonts.poppins(color: _primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.black),
      dropdownColor: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        "Edit User",
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextField(
                  controller: _namaController,
                  label: "Nama",
                  primaryColor: _primaryColor,
                ),
                CustomTextField(
                  controller: _emailController,
                  label: "Email",
                  primaryColor: _primaryColor,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _noHpController,
                  label: "Nomor HP",
                  primaryColor: _primaryColor,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  controller: _alamatController,
                  label: "Alamat",
                  primaryColor: _primaryColor,
                ),
                _buildDropdownRole(),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    "Update User",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../controller/edit_user_controller.dart';

// class EditUserScreen extends StatefulWidget {
//   final int id;
//   final String nama;
//   final String email;
//   final String nomorHp;
//   final String alamat;
//   final String role;

//   const EditUserScreen({
//     super.key,
//     required this.id,
//     required this.nama,
//     required this.email,
//     required this.nomorHp,
//     required this.alamat,
//     required this.role,
//   });

//   @override
//   State<EditUserScreen> createState() => _EditUserScreenState();
// }

// class _EditUserScreenState extends State<EditUserScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _namaController;
//   late TextEditingController _emailController;
//   late TextEditingController _noHpController;
//   late TextEditingController _alamatController;
//   late String _selectedRole;

//   final _primaryColor = const Color(0xFF1A7F65);

//   @override
//   void initState() {
//     super.initState();
//     _namaController = TextEditingController(text: widget.nama);
//     _emailController = TextEditingController(text: widget.email);
//     _noHpController = TextEditingController(text: widget.nomorHp);
//     _alamatController = TextEditingController(text: widget.alamat);
//     _selectedRole = widget.role;
//   }

//   @override
//   void dispose() {
//     _namaController.dispose();
//     _emailController.dispose();
//     _noHpController.dispose();
//     _alamatController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate()) {
//       final success = await EditUserController.updateUser(
//         id: widget.id,
//         nama: _namaController.text,
//         email: _emailController.text,
//         nomorHp: _noHpController.text,
//         alamat: _alamatController.text,
//         role: _selectedRole,
//         context: context,
//       );

//       if (success) Navigator.pop(context);
//     }
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
//     TextInputType? keyboardType,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: GoogleFonts.poppins(),
//         decoration: _inputDecoration(label),
//         validator: (value) => value!.isEmpty ? "$label wajib diisi" : null,
//       ),
//     );
//   }

//   Widget _buildDropdownRole() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         value: _selectedRole,
//         items: const [
//           DropdownMenuItem(value: 'customer', child: Text('Customer')),
//           DropdownMenuItem(value: 'admin', child: Text('Admin')),
//         ],
//         onChanged: (val) => setState(() => _selectedRole = val!),
//         decoration: _inputDecoration("Role"),
//         style: GoogleFonts.poppins(color: Colors.black),
//         dropdownColor: Colors.white,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit User",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildTextField(_namaController, "Nama"),
//                   _buildTextField(
//                     _emailController,
//                     "Email",
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   _buildTextField(
//                     _noHpController,
//                     "Nomor HP",
//                     keyboardType: TextInputType.phone,
//                   ),
//                   _buildTextField(_alamatController, "Alamat"),
//                   _buildDropdownRole(),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 14,
//                       ),
//                     ),
//                     onPressed: _submit,
//                     child: Text(
//                       "Update User",
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
