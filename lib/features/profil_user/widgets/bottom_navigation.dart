import 'package:belify/features/management_order/screen/AdminOrderListScreen.dart';
import 'package:belify/features/profil_user/screen/account_screen.dart';
import 'package:belify/features/cart/screens/cart_screen.dart';
import 'package:belify/features/home/screen/home_screen.dart';
import 'package:belify/features/management_user/screen/get_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/svg_icons.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: SvgIcon.home(color: const Color(0xFFC2C2C2)),
            label: 'Home',
            isActive: false,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final role = prefs.getString('role');

              if (role == 'admin') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(role: 'admin'),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(role: 'customer'),
                  ),
                  (route) => false,
                );
              }
            },
          ),
          _buildNavItem(
            icon: SvgIcon.cart(color: const Color(0xFFC2C2C2)),
            label: 'My Cart',
            isActive: false,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final role = prefs.getString('role');
              final userId = prefs.getInt('user_id');

              if (role == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminOrderListScreen(),
                  ),
                );
              } else if (role == 'customer' && userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartScreen(userId: userId.toString()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Gagal mengakses halaman keranjang'),
                  ),
                );
              }
            },
          ),
          _buildNavItem(
            icon: SvgIcon.user(color: const Color(0xFF156651)),
            label: 'My Account',
            isActive: true,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final role = prefs.getString('role');

              if (role == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GetUserScreen()),
                );
              } else if (role == 'customer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isActive
                        ? const Color(0xFF156651)
                        : const Color(0xFFC2C2C2),
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
