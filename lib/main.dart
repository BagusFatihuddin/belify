// lib/main.dart
import 'package:flutter/material.dart'; // 📦 Import library utama Flutter untuk UI
import 'package:shared_preferences/shared_preferences.dart'; // 📦 Untuk menyimpan data lokal (token, role, dll.)
import 'shared/routes/app_routes.dart'; // 📦 Import file routing
import 'features/home/screen/home_screen.dart'; // 📦 Import layar Home
import 'features/auth/screens/login_screen.dart'; // 📦 Import layar Login

void main() {
  runApp(const MyApp()); // 🚀 Jalankan aplikasi dengan widget MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 🔧 Constructor MyApp dengan key opsional

  // 🔍 Fungsi async untuk ambil role user dari SharedPreferences
  Future<String?> getUserRole() async {
    final prefs =
        await SharedPreferences.getInstance(); // ✅ Ambil instance penyimpanan lokal
    final token = prefs.getString('token'); // 🔑 Ambil token login user
    final role = prefs.getString(
      'role',
    ); // 👤 Ambil role user (misalnya: admin, user, dll.)

    // 📌 Kalau token & role ada → return role, kalau tidak → return null
    if (token != null && token.isNotEmpty && role != null) {
      return role;
    }
    return null; // ❌ Kalau belum login
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 🚫 Hilangkan banner merah "DEBUG"
      onGenerateRoute:
          AppRoutes.generateRoute, // 📌 Routing app (navigasi antar screen)
      home: FutureBuilder<String?>(
        // 🔮 Tunggu hasil getUserRole()
        future: getUserRole(), // ✅ Jalankan fungsi ambil role
        builder: (context, snapshot) {
          // ⏳ Jika masih loading → tampilkan loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ✅ Kalau ada role → masuk ke HomeScreen
          if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen(
              role: snapshot.data!, // 🛠 Kirim role ke HomeScreen
            );
          } else {
            // ❌ Kalau belum login → masuk ke LoginScreen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
