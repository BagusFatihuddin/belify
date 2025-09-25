import 'package:belify/features/profil_user/screen/account_screen.dart';
import 'package:belify/features/auth/screens/otp_code_screen.dart';
import 'package:belify/features/auth/screens/password_update_screen.dart';
import 'package:belify/upload_gambar_page.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';

class AppRoutes {
  // static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const detail = '/detail';
  static const sofa = '/sofa';
  // static const cart = '/cart';
  static const account = '/account';
  static const upload_gambar = '/upload_gambar';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case home:
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      // case cart:
      // return MaterialPageRoute(builder: (_) => const CartScreen());
      case account:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      // case detail:
      // return MaterialPageRoute(builder: (_) => const ProductDetailPage());
      case upload_gambar:
        return MaterialPageRoute(builder: (_) => UploadImagePage());
      // case sofa:
      //   return MaterialPageRoute(builder: (_) => const SofaScreen());
      case '/otp':
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] ?? '';
        return MaterialPageRoute(builder: (_) => OtpCodeScreen(email: email));

      // Route ke halaman update password, butuh token
      case '/update-password':
        // final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => const PasswordUpdateScreen(),
          settings: settings, // penting agar bisa akses arguments di screen
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Route tidak ditemukan: ${settings.name}'),
                ),
              ),
        );
    }
  }
}
