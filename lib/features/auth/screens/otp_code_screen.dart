import 'package:flutter/material.dart';
import '../widgets/otp_input_field.dart';
import '../controllers/otp_controller.dart';

class OtpCodeScreen extends StatefulWidget {
  final String email;

  const OtpCodeScreen({super.key, this.email = 'satanseint@gmail.com'});

  @override
  State<OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState extends State<OtpCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? widget.email;
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onContinue() {
    final otp = _controllers.map((c) => c.text).join();
    verifyOtp(context: context, email: email, otp: otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 68),
                const Text(
                  'Enter 4 Digit Code',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 29),
                Text(
                  'Enter 6 digit code that you receive on your email ($email).',
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 52),
                Row(
                  children: List.generate(
                    6,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: index < 5 ? 20 : 0),
                      child: OtpInputField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        nextFocusNode:
                            index < 5 ? _focusNodes[index + 1] : null,
                        previousFocusNode:
                            index > 0 ? _focusNodes[index - 1] : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Email not received? ',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF68656E),
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => resendCode(context),
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF156651),
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 58),
                ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF156651),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 381),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
