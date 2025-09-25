import 'package:belify/features/auth/widgets/social_login_button_facebook.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_login_button.dart';
import '../../../shared/themes/style_text_color_auth.dart';
import '../controllers/auth_controller_regis.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nohpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addresController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 44.0),
            constraints: const BoxConstraints(maxWidth: 480),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Color(0xFF404040),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your details below to get started on a seamless shopping experience.',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    fontFamily: 'Manrope',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: 'Username',
                        iconSvg: 'lib/shared/assets/icons/person.svg',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Email',
                        iconSvg: 'lib/shared/assets/icons/mail.svg',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Hanphone',
                        iconSvg: 'lib/shared/assets/icons/phone.svg',
                        controller: _nohpController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Password',
                        iconSvg: 'lib/shared/assets/icons/lock.svg',
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggleVisibility: _togglePasswordVisibility,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Addres',
                        iconSvg: 'lib/shared/assets/icons/location.svg',
                        controller: _addresController,
                      ),

                      // Tombol DAFTAR
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () async {
                                    setState(() => _isLoading = true);
                                    try {
                                      await AuthController.registerUser(
                                        context: context,
                                        nameController: _nameController,
                                        emailController: _emailController,
                                        phoneController: _nohpController,
                                        passwordController: _passwordController,
                                        addressController: _addresController,
                                      );
                                    } catch (e) {
                                      print('❌ Register Error: $e');
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Terjadi kesalahan: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },

                          child:
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Daftar'),
                        ),
                      ),

                      // Divider
                      Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFC2C2C2))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('OR'),
                            ),
                            Expanded(child: Divider(color: Color(0xFFC2C2C2))),
                          ],
                        ),
                      ),

                      // Tombol Google
                      Column(
                        children: [
                          SocialLoginButton(
                            text:
                                _isGoogleLoading
                                    ? 'Signing up...'
                                    : 'Sign Up with Google',
                            iconSvg: 'lib/shared/assets/icons/google.svg',
                            onPressed:
                                _isGoogleLoading
                                    ? null
                                    : () async {
                                      if (!mounted) return;
                                      setState(() => _isGoogleLoading = true);

                                      await AuthController.registerWithGoogle(
                                        context,
                                      );

                                      if (mounted) {
                                        setState(
                                          () => _isGoogleLoading = false,
                                        );
                                      }
                                    },
                          ),

                          const SizedBox(height: 16),
                          SocialLoginButtonFacebook(
                            text: 'Sign In with Facebook',
                            iconSvg: 'lib/shared/assets/icons/facebook.svg',
                            onPressed: () {
                              // coming soon
                            },
                          ),
                        ],
                      ),

                      // Login Link
                      Container(
                        margin: const EdgeInsets.only(top: 32, bottom: 24),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFF404040),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              fontFamily: 'Manrope',
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Login',
                                    style: AppTextStyles.registerLinkText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
