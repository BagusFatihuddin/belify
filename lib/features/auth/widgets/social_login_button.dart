import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../shared/themes/style_text_color_auth.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconSvg;
  // final VoidCallback onPressed;
  final Future<void> Function()? onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconSvg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed!(); // jalankan fungsi async
          }
        },

        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(iconSvg, width: 16, height: 16),
              const SizedBox(width: 14),
              Text(text, style: AppTextStyles.socialButtonText),
            ],
          ),
        ),
      ),
    );
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: onPressed,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: AppColors.primary),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SvgPicture.string(iconSvg, width: 16, height: 16),
  //           const SizedBox(width: 14),
  //           Text(text, style: AppTextStyles.socialButtonText),
  //         ],
  //       ),
  //     ),
  //   );
  // }