import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.asset(icon, width: 24, height: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF404040),
                      fontFamily: 'Manrope',
                      fontSize: 16,
                    ),
                  ),
                ),
                SvgPicture.string(
                  '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12.6086 12.0088L12.6175 12L12.6086 11.9911L8.70864 8.09115C8.52788 7.91039 8.4373 7.68034 8.4373 7.39999C8.4373 7.11963 8.52788 6.88959 8.70864 6.70883C8.8894 6.52807 9.11945 6.43749 9.3998 6.43749C9.68016 6.43749 9.91021 6.52807 10.091 6.70883L14.691 11.3088C14.7898 11.4077 14.8596 11.5145 14.9005 11.6292C14.9417 11.7444 14.9623 11.868 14.9623 12C14.9623 12.132 14.9417 12.2556 14.9005 12.3708C14.8596 12.4855 14.7898 12.5923 14.691 12.6911L10.091 17.2911C9.91021 17.4719 9.68016 17.5625 9.3998 17.5625C9.11945 17.5625 8.8894 17.4719 8.70864 17.2911C8.52788 17.1104 8.4373 16.8803 8.4373 16.6C8.4373 16.3196 8.52788 16.0896 8.70864 15.9088L12.6086 12.0088Z" fill="#404040" stroke="#404040" stroke-width="0.025"/>
                  </svg>''',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
