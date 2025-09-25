import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../shared/themes/style_text_color_auth.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String iconSvg;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.iconSvg,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconSvg, width: 24, height: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.inputLabel),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  obscureText: isPassword ? obscureText : false,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  style: AppTextStyles.inputText,
                ),
              ],
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: onToggleVisibility,
              child: SvgPicture.asset(
                obscureText ? _eyeIconSvg : _eyeOffIconSvg,
                width: 20,
                height: 20,
              ),
            ),
        ],
      ),
    );
  }
}

// SVG string for the eye icon
const String _eyeIconSvg = 'lib/shared/assets/icons/eyeOn.svg';
const String _eyeOffIconSvg = 'lib/shared/assets/icons/eyeOff.svg';
