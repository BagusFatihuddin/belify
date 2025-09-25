import 'package:belify/features/profil_user/controller/logout_controller.dart';
import 'package:belify/features/profil_user/screen/update_profile_screen.dart';
import 'package:belify/features/profil_user/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/menu_item.dart';
import '../widgets/profile_background.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userPhoto = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Nama tidak ditemukan';
      _userEmail = prefs.getString('user_email') ?? 'Email tidak ditemukan';
      _userPhoto =
          prefs.getString('user_photo') ??
          'https://res.cloudinary.com/dshhlawvf/image/upload/v1751117398/images_adugdp.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [_buildHeader(), _buildContent()]),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 152,
          child: CustomPaint(painter: ProfileBackgroundPainter()),
        ),
        Positioned(
          top: 52,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SvgPicture.asset(
                  'lib/shared/assets/icons/notif.svg', //=======================================================================
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildProfileCard(),
          const SizedBox(height: 24),
          _buildGeneralSection(),
          const SizedBox(height: 24),
          _buildHelpSection(),
          const SizedBox(height: 24),
          _buildLogoutSection(),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'App version: 1.0',
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontFamily: 'Manrope',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 80), // Space for bottom navigation bar
        ],
      ),
    );
  }

  // ==================== ProfilCard ====================
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 29,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                (_userPhoto.isNotEmpty && _userPhoto.startsWith('http'))
                    ? NetworkImage(_userPhoto)
                    : const NetworkImage(
                      'https://res.cloudinary.com/dshhlawvf/image/upload/v1751117398/images_adugdp.png',
                    ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Color(0xFF404040),
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _userEmail,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontFamily: 'Manrope',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
              );
            },
            child: SvgPicture.asset(
              'lib/shared/assets/icons/edit.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  //========================================

  Widget _buildGeneralSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General',
          style: TextStyle(
            color: Color(0xFF404040),
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/transaction.svg',
          title: 'Transaction',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/Wishlist.svg',
          title: 'Wishlist',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/SavedAddress.svg',
          title: 'Saved Address',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/payment.svg',
          title: 'Payment Methods',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/notificationIcon.svg',
          title: 'Notification',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/Security.svg',
          title: 'Security',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Help',
          style: TextStyle(
            color: Color(0xFF404040),
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/userIcon.svg',
          title: 'Get in Touch With Us',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            color: Color(0xFF404040),
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        MenuItem(
          icon: 'lib/shared/assets/icons/logout.svg',
          title: 'Logout',
          onTap: () => _showLogoutConfirmation(context), // 👈 pakai dialog
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Logout"),
            content: const Text("Apakah kamu yakin ingin logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Batal
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  LogoutController.logout(context); // Lakukan logout
                },
                child: const Text("Logout"),
              ),
            ],
          ),
    );
  }
}
