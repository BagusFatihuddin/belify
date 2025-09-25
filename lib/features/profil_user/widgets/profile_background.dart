import 'package:flutter/material.dart';

class ProfileBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient background
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A7F65), Color(0xFF115543)],
            stops: [0.2096, 0.8291],
          ).createShader(rect);

    canvas.drawRect(rect, paint);

    // Draw decorative circles
    final Paint circlePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    // Draw circles as shown in the design
    canvas.drawCircle(Offset(73.5, 44.5), 5.5, circlePaint);
    canvas.drawCircle(Offset(169, 86), 3, circlePaint);
    canvas.drawCircle(Offset(66.5, 96.5), 4.5, circlePaint);
    canvas.drawCircle(Offset(305, 48), 3, circlePaint);
    canvas.drawCircle(Offset(276, 92), 6, circlePaint);
    canvas.drawCircle(Offset(235, 60), 4, circlePaint);
    canvas.drawCircle(Offset(166.5, 44.5), 3.5, circlePaint);
    canvas.drawCircle(Offset(360, 70), 3, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
