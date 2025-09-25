import 'package:flutter/material.dart';
import '../controllers/forgot_password_sevice.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _checkEmail() async {
    final email = _emailController.text.trim();
    final result = await AuthService.checkEmail(email, context);

    if (result) {
      setState(() {
        _isEmailValid = true;
      });
    }
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    final success = await AuthService.sendOtp(email, context);

    if (success) {
      Navigator.pushNamed(context, '/otp', arguments: {'email': email});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 480),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(top: 68, bottom: 423),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontFamily: 'Lato',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 29),
                const Text(
                  'Enter your email id for the verification process, we will send 6 digit to your email',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontFamily: 'Lato',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 52),
                _buildEmailInput(),
                const SizedBox(height: 48),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(color: Color(0xFF757575), fontSize: 16),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isEmailValid ? _sendCode : _checkEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF156651),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          _isEmailValid ? 'Send Code' : 'Continue',
          style: const TextStyle(
            color: Color(0xFFFBFBFC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
