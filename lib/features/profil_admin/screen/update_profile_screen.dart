import 'package:belify/features/profil_admin/controller/update_profile_controller.dart';
import 'package:belify/features/profil_admin/widgets/update_profile_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;
  final _primaryColor = const Color(0xFF1A7F65);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('user_name') ?? '';
    _phoneController.text = prefs.getString('user_phone') ?? '';
    _addressController.text = prefs.getString('user_address') ?? '';
    setState(() {});
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    final success = await UpdateProfileController.updateProfile(
      context: context,
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    if (success && mounted) Navigator.pop(context);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil', style: GoogleFonts.poppins()),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                UpdateProfileTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  primaryColor: _primaryColor,
                ),
                UpdateProfileTextField(
                  controller: _phoneController,
                  label: 'Nomor HP',
                  primaryColor: _primaryColor,
                  keyboardType: TextInputType.phone,
                ),
                UpdateProfileTextField(
                  controller: _addressController,
                  label: 'Alamat',
                  primaryColor: _primaryColor,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
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
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            'Simpan Perubahan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
