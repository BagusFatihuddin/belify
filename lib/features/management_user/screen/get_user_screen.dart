// import 'package:belify/features/management_user/controller/get_user_controller.dart';
// import 'package:belify/features/management_user/screen/create_user_screen.dart';
// import 'package:belify/features/management_user/widget/user_card.dart';
// import 'package:belify/features/profil_admin/screen/update_profile_screen.dart';
// import 'package:belify/features/profil_user/widgets/bottom_navigation.dart';
// import 'package:belify/features/management_user/widget/profile_card.dart';
// import 'package:flutter/material.dart';

// class GetUserScreen extends StatefulWidget {
//   const GetUserScreen({super.key});

//   @override
//   State<GetUserScreen> createState() => _GetUserScreenState();
// }

// class _GetUserScreenState extends State<GetUserScreen> {
//   String _nama = '-';
//   String _email = '-';
//   List users = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     final info = await GetUserController.loadUserInfo();
//     final data = await GetUserController.fetchAllUsers(context);
//     setState(() {
//       _nama = info['nama']!;
//       _email = info['email']!;
//       users = data;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const CustomBottomNavigation(),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           ProfileCard(
//             name: _nama,
//             email: _email,
//             onEdit:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const UpdateProfileScreen(),
//                   ),
//                 ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const CreateUserScreen()),
//                 ),
//             icon: const Icon(Icons.add),
//             label: const Text('Tambah User'),
//           ),
//           const SizedBox(height: 20),
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//                 children:
//                     users
//                         .map(
//                           (u) =>
//                               UserCard(user: u, onEdit: () {}, onDelete: () {}),
//                         )
//                         .toList(),
//               ),
//         ],
//       ),
//     );
//   }
// }

import 'package:belify/features/management_user/controller/delete_user_controller.dart';
import 'package:belify/features/management_user/screen/create_user_screen.dart';
import 'package:belify/features/management_user/screen/edit_user_screen.dart';
//====================
import 'package:belify/features/profil_user/controller/logout_controller.dart';
import 'package:belify/features/profil_user/screen/update_profile_screen.dart';
import 'package:belify/features/profil_user/widgets/bottom_navigation.dart';
import 'package:belify/features/profil_user/widgets/menu_item.dart';
//===================================
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

import '../widget/profile_background.dart';

class GetUserScreen extends StatefulWidget {
  const GetUserScreen({Key? key}) : super(key: key);

  @override
  State<GetUserScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<GetUserScreen> {
  String _userName = '';
  String _userEmail = '';

  List<User> _allUsers = [];
  bool _isLoadingUsers = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchAllUsers();
  }

  void debugToken() async {
    final prefs = await SharedPreferences.getInstance();
    print('🔐 TOKEN: ${prefs.getString('token')}');
    print('👤 ROLE: ${prefs.getString('role')}');
    print('🆔 USER_ID: ${prefs.getInt('user_id')}');
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Nama tidak ditemukan';
      _userEmail = prefs.getString('user_email') ?? 'Email tidak ditemukan';
    });
  }

  Future<void> _fetchAllUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}users/get_all.php'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            _allUsers =
                (jsonData['data'] as List)
                    .map((user) => User.fromJson(user))
                    .toList();
          });
        }
      } else {
        print('Gagal fetch user: ${response.body}');
      }
    } catch (e) {
      print('Error fetch user: $e');
    } finally {
      setState(() {
        _isLoadingUsers = false;
      });
    }
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
                  'lib/shared/assets/icons/notif.svg',
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
          //====================================================
          MenuItem(
            icon: 'lib/shared/assets/icons/logout.svg',
            title: 'Logout',
            onTap: () => _showLogoutConfirmation(context), // 👈 pakai dialog
          ),
          const SizedBox(height: 24),

          const Text(
            'Daftar Semua User',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Manrope',
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // 🚀 Tombol Tambah User
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserScreen()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Tambah User"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A7F65),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // const SizedBox(height: 4),
          _isLoadingUsers
              ? const Center(child: CircularProgressIndicator())
              : _allUsers.isEmpty
              ? const Text('Tidak ada user ditemukan.')
              : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _allUsers.length,
                itemBuilder: (context, index) {
                  final user = _allUsers[index];
                  return _buildUserCard(user);
                },
              ),

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
          const SizedBox(height: 80),
        ],
      ),
    );
  }

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
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFF1A7F65),
              shape: BoxShape.circle,
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

  Widget _buildUserCard(User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => EditUserScreen(
                                id: int.parse(user.id.toString()),
                                nama: user.nama,
                                email: user.email,
                                nomorHp: user.nomorHp,
                                alamat: user.alamat,
                                role: user.role,
                              ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Konfirmasi"),
                              content: Text("Yakin hapus ${user.nama}?"),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        final success = await DeleteUserController.deleteUser(
                          id: int.parse(user.id.toString()),
                          context: context,
                        );

                        if (success) {
                          // Refresh state di parent
                          setState(() {
                            _allUsers.removeWhere((u) => u.id == user.id);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Email: ${user.email}", style: const TextStyle(fontSize: 14)),
          Text("No. HP: ${user.nomorHp}", style: const TextStyle(fontSize: 14)),
          Text("Alamat: ${user.alamat}", style: const TextStyle(fontSize: 14)),
          Text("Role: ${user.role}", style: const TextStyle(fontSize: 14)),
        ],
      ),
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
