import 'package:belify/features/auth/screens/forgot_password.dart';
import 'package:belify/features/auth/widgets/social_login_button_facebook.dart';
import 'package:flutter/material.dart';
import '../../../shared/themes/style_text_color_auth.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';
import '../controllers/auth_controller_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 375),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Main content with padding
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 68, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================================================Welcome text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome Back!', style: AppTextStyles.heading),
                            const SizedBox(height: 8),
                            Text(
                              'Enter your email to start shopping and get awesome deals today!',
                              style: AppTextStyles.subheading,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // =============================================Input fields
                        Column(
                          children: [
                            CustomTextField(
                              label: 'Email',
                              iconSvg: 'lib/shared/assets/icons/mail.svg',
                              controller: _emailController,
                            ),

                            const SizedBox(height: 16),

                            CustomTextField(
                              label: 'Password',
                              iconSvg: 'lib/shared/assets/icons/lock.svg',
                              isPassword: true,
                              obscureText: _obscurePassword,
                              onToggleVisibility: _togglePasswordVisibility,
                              controller: _passwordController,
                            ),

                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextStyles.linkText,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ============================Login button
                        InkWell(
                          // onTap: () {
                          //   loginUser();
                          // },
                          onTap: () {
                            AuthController.loginUser(
                              context: context,
                              emailController: _emailController,
                              passwordController: _passwordController,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Log In',
                              style: AppTextStyles.buttonText,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // OR divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: AppColors.divider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'OR',
                                style: AppTextStyles.dividerText,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: AppColors.divider,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ========================Social login buttons===================
                        Column(
                          children: [
                            SocialLoginButtonFacebook(
                              text: 'Log In with Google',
                              iconSvg: 'lib/shared/assets/icons/google.svg',
                              onPressed: () {
                                AuthController.loginWithGoogle(context);
                              },
                              // onPressed: loginWithGoogle,
                            ),
                            const SizedBox(height: 16),
                            SocialLoginButtonFacebook(
                              text: 'Log In with Facebook',
                              iconSvg: 'lib/shared/assets/icons/facebook.svg',
                              onPressed: () {
                                // Handle Facebook login
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ==================================Register prompt
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: AppTextStyles.registerText,
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      // =======================
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    splashColor: const Color(
                                      0xFFFFFFFF,
                                    ).withAlpha(75), // Splash effect
                                    highlightColor: const Color(
                                      0xFF000000,
                                    ).withAlpha(25), // Highlight effect
                                    child: Text(
                                      'Register', // Teks yang ditampilkan
                                      style:
                                          AppTextStyles
                                              .registerLinkText, // Gaya teks
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 60,
                        ), // Extra space for bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SVG strings for icons
