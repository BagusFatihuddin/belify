// screens/create_user_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/create_user_controller.dart';
import '../widget/custom_textfield.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _alamatController = TextEditingController();
  String _selectedRole = 'customer';
  bool _obscurePassword = true;
  final _primaryColor = const Color(0xFF1A7F65);

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await CreateUserController.createUser(
        nama: _namaController.text,
        email: _emailController.text,
        nomorHp: _noHpController.text,
        password: _passwordController.text,
        alamat: _alamatController.text,
        role: _selectedRole,
        context: context,
      );
      if (success) Navigator.pop(context);
    }
  }

  Widget _buildPasswordField() => CustomTextField(
    controller: _passwordController,
    label: "Password",
    obscure: _obscurePassword,
    primaryColor: _primaryColor,
    suffix: GestureDetector(
      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          _obscurePassword
              ? 'lib/shared/assets/icons/eyeOn.svg'
              : 'lib/shared/assets/icons/eyeOff.svg',
          width: 20,
          height: 20,
        ),
      ),
    ),
    validator:
        (value) => value!.length < 6 ? "Password minimal 6 karakter" : null,
  );

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
        "Tambah User",
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
                  keyboardType: TextInputType.emailAddress,
                  primaryColor: _primaryColor,
                ),
                CustomTextField(
                  controller: _noHpController,
                  label: "Nomor HP",
                  keyboardType: TextInputType.phone,
                  primaryColor: _primaryColor,
                ),
                _buildPasswordField(),
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
                    "Simpan User",
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
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../controller/create_user_controller.dart';

// class CreateUserScreen extends StatefulWidget {
//   const CreateUserScreen({super.key});

//   @override
//   State<CreateUserScreen> createState() => _CreateUserScreenState();
// }

// class _CreateUserScreenState extends State<CreateUserScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _namaController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _noHpController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _alamatController = TextEditingController();
//   String _selectedRole = 'customer';
//   bool _obscurePassword = true;

//   final _primaryColor = const Color(0xFF1A7F65);

//   @override
//   void dispose() {
//     _namaController.dispose();
//     _emailController.dispose();
//     _noHpController.dispose();
//     _passwordController.dispose();
//     _alamatController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate()) {
//       final success = await CreateUserController.createUser(
//         nama: _namaController.text,
//         email: _emailController.text,
//         nomorHp: _noHpController.text,
//         password: _passwordController.text,
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
//     bool obscure = false,
//     Widget? suffix,
//     TextInputType? keyboardType,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         keyboardType: keyboardType,
//         style: GoogleFonts.poppins(),
//         decoration: _inputDecoration(label).copyWith(suffixIcon: suffix),
//         validator: (value) => value!.isEmpty ? "$label wajib diisi" : null,
//       ),
//     );
//   }

//   Widget _buildPasswordField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: _passwordController,
//         obscureText: _obscurePassword,
//         style: GoogleFonts.poppins(),
//         decoration: _inputDecoration("Password").copyWith(
//           suffixIcon: GestureDetector(
//             onTap: () {
//               setState(() => _obscurePassword = !_obscurePassword);
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SvgPicture.asset(
//                 _obscurePassword
//                     ? 'lib/shared/assets/icons/eyeOn.svg'
//                     : 'lib/shared/assets/icons/eyeOff.svg',
//                 width: 20,
//                 height: 20,
//               ),
//             ),
//           ),
//         ),
//         validator:
//             (value) => value!.length < 6 ? "Password minimal 6 karakter" : null,
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
//           "Tambah User",
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
//                   _buildPasswordField(),
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
//                       "Simpan User",
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
