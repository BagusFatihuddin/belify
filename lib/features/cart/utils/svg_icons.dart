import 'package:flutter/material.dart';

class SvgIcon {
  // Search icon
  static Widget search() {
    return CustomPaint(size: const Size(20, 20), painter: _SearchIconPainter());
  }

  // Camera icon
  static Widget camera() {
    return CustomPaint(size: const Size(20, 20), painter: _CameraIconPainter());
  }

  // Notification icon
  static Widget notification() {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _NotificationIconPainter(),
    );
  }

  // Location icon
  static Widget location() {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _LocationIconPainter(),
    );
  }

  // Down arrow icon
  static Widget down() {
    return CustomPaint(size: const Size(20, 20), painter: _DownIconPainter());
  }

  // Star icon
  static Widget star() {
    return CustomPaint(size: const Size(16, 16), painter: _StarIconPainter());
  }

  // Home icon
  static Widget home({Color color = Colors.black}) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _HomeIconPainter(color: color),
    );
  }

  // Cart icon
  static Widget cart({Color color = Colors.black}) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _CartIconPainter(color: color),
    );
  }

  // User icon
  static Widget user({Color color = Colors.black}) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _UserIconPainter(color: color),
    );
  }
}

class _SearchIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final Path path =
        Path()
          ..moveTo(size.width * 0.875, size.height * 0.875)
          ..lineTo(size.width * 0.6938, size.height * 0.6938)
          ..moveTo(size.width * 0.7917, size.height * 0.4583)
          ..addOval(
            Rect.fromCircle(
              center: Offset(size.width * 0.4583, size.height * 0.4583),
              radius: size.width * 0.3333,
            ),
          );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CameraIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = const Color(0xFF404040)
          ..style = PaintingStyle.fill;

    // Camera body
    final Path bodyPath = Path();
    bodyPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.0833,
          size.height * 0.2639,
          size.width * 0.8334,
          size.height * 0.6111,
        ),
        Radius.circular(size.width * 0.05),
      ),
    );

    // Camera lens
    final Path lensPath = Path();
    lensPath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.5347),
        radius: size.width * 0.1736,
      ),
    );

    canvas.drawPath(bodyPath, paint);
    canvas.drawPath(lensPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotificationIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = const Color(0xFF404040)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final Path path =
        Path()
          ..moveTo(size.width * 0.5721, size.height * 0.875)
          ..cubicTo(
            size.width * 0.5476,
            size.height * 0.8763,
            size.width * 0.5425,
            size.height * 0.8811,
            size.width * 0.5416,
            size.height * 0.9054,
          )
          ..cubicTo(
            size.width * 0.5394,
            size.height * 0.9269,
            size.width * 0.5146,
            size.height * 0.9652,
            size.width * 0.5,
            size.height * 0.9652,
          )
          ..cubicTo(
            size.width * 0.4854,
            size.height * 0.9652,
            size.width * 0.4606,
            size.height * 0.9269,
            size.width * 0.4584,
            size.height * 0.9054,
          )
          ..cubicTo(
            size.width * 0.4575,
            size.height * 0.8811,
            size.width * 0.4524,
            size.height * 0.8763,
            size.width * 0.4279,
            size.height * 0.875,
          )
          ..moveTo(size.width * 0.75, size.height * 0.3333)
          ..cubicTo(
            size.width * 0.75,
            size.height * 0.267,
            size.width * 0.7237,
            size.height * 0.2034,
            size.width * 0.6768,
            size.height * 0.1566,
          )
          ..cubicTo(
            size.width * 0.6299,
            size.height * 0.1097,
            size.width * 0.5663,
            size.height * 0.0833,
            size.width * 0.5,
            size.height * 0.0833,
          )
          ..cubicTo(
            size.width * 0.4337,
            size.height * 0.0833,
            size.width * 0.3701,
            size.height * 0.1097,
            size.width * 0.3232,
            size.height * 0.1566,
          )
          ..cubicTo(
            size.width * 0.2763,
            size.height * 0.2034,
            size.width * 0.25,
            size.height * 0.267,
            size.width * 0.25,
            size.height * 0.3333,
          )
          ..cubicTo(
            size.width * 0.25,
            size.height * 0.625,
            size.width * 0.125,
            size.height * 0.7083,
            size.width * 0.125,
            size.height * 0.7083,
          )
          ..lineTo(size.width * 0.875, size.height * 0.7083)
          ..cubicTo(
            size.width * 0.875,
            size.height * 0.7083,
            size.width * 0.75,
            size.height * 0.625,
            size.width * 0.75,
            size.height * 0.3333,
          );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LocationIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    // Draw location pin
    final Path path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.cubicTo(
      size.width * 0.35,
      size.height * 0.1,
      size.width * 0.2,
      size.height * 0.25,
      size.width * 0.2,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.5,
      size.height * 0.9,
    );
    path.cubicTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.8,
      size.height * 0.65,
      size.width * 0.8,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.25,
      size.width * 0.65,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.1,
    );
    path.close();

    // Draw inner circle
    final Path circlePath = Path();
    circlePath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.4),
        radius: size.width * 0.15,
      ),
    );

    canvas.drawPath(path, paint);

    // Use different color for inner circle
    paint.color = Colors.white;
    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DownIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.65);
    path.lineTo(size.width * 0.25, size.height * 0.4);
    path.lineTo(size.width * 0.75, size.height * 0.4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = const Color(0xFFEBB65B)
          ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width * 0.5, size.height * 0);
    path.lineTo(size.width * 0.6225, size.height * 0.3275);
    path.lineTo(size.width, size.height * 0.3819);
    path.lineTo(size.width * 0.75, size.height * 0.6381);
    path.lineTo(size.width * 0.8056, size.height);
    path.lineTo(size.width * 0.5, size.height * 0.7819);
    path.lineTo(size.width * 0.1944, size.height);
    path.lineTo(size.width * 0.25, size.height * 0.6381);
    path.lineTo(size.width * 0, size.height * 0.3819);
    path.lineTo(size.width * 0.3775, size.height * 0.3275);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeIconPainter extends CustomPainter {
  final Color color;

  _HomeIconPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final Path path =
        Path()
          ..moveTo(size.width * 0.375, size.height * 0.9167)
          ..lineTo(size.width * 0.375, size.height * 0.5)
          ..lineTo(size.width * 0.625, size.height * 0.5)
          ..lineTo(size.width * 0.625, size.height * 0.9167)
          ..moveTo(size.width * 0.125, size.height * 0.375)
          ..lineTo(size.width * 0.5, size.height * 0.0833)
          ..lineTo(size.width * 0.875, size.height * 0.375)
          ..lineTo(size.width * 0.875, size.height * 0.8333)
          ..cubicTo(
            size.width * 0.875,
            size.height * 0.8554,
            size.width * 0.8661,
            size.height * 0.8763,
            size.width * 0.8505,
            size.height * 0.8919,
          )
          ..cubicTo(
            size.width * 0.8349,
            size.height * 0.9076,
            size.width * 0.814,
            size.height * 0.9167,
            size.width * 0.7917,
            size.height * 0.9167,
          )
          ..lineTo(size.width * 0.2083, size.height * 0.9167)
          ..cubicTo(
            size.width * 0.186,
            size.height * 0.9167,
            size.width * 0.1651,
            size.height * 0.9076,
            size.width * 0.1495,
            size.height * 0.8919,
          )
          ..cubicTo(
            size.width * 0.1339,
            size.height * 0.8763,
            size.width * 0.125,
            size.height * 0.8554,
            size.width * 0.125,
            size.height * 0.8333,
          )
          ..lineTo(size.width * 0.125, size.height * 0.375);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CartIconPainter extends CustomPainter {
  final Color color;

  _CartIconPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Cart body
    final Path cartPath = Path();
    cartPath.moveTo(size.width * 0.125, size.height * 0.0833);
    cartPath.lineTo(size.width * 0.25, size.height * 0.0833);
    cartPath.lineTo(size.width * 0.3333, size.height * 0.5833);
    cartPath.lineTo(size.width * 0.8333, size.height * 0.5833);
    cartPath.lineTo(size.width * 0.9167, size.height * 0.25);
    cartPath.lineTo(size.width * 0.3333, size.height * 0.25);
    cartPath.close();

    // Left wheel
    final Path leftWheelPath = Path();
    leftWheelPath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.375, size.height * 0.7917),
        radius: size.width * 0.0625,
      ),
    );

    // Right wheel
    final Path rightWheelPath = Path();
    rightWheelPath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.7083, size.height * 0.7917),
        radius: size.width * 0.0625,
      ),
    );

    canvas.drawPath(cartPath, paint);
    canvas.drawPath(leftWheelPath, paint);
    canvas.drawPath(rightWheelPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UserIconPainter extends CustomPainter {
  final Color color;

  _UserIconPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final Path path =
        Path()
          ..moveTo(size.width * 0.7917, size.height * 0.8651)
          ..lineTo(size.width * 0.7917, size.height * 0.7818)
          ..cubicTo(
            size.width * 0.7917,
            size.height * 0.7376,
            size.width * 0.7741,
            size.height * 0.6952,
            size.width * 0.7429,
            size.height * 0.664,
          )
          ..cubicTo(
            size.width * 0.7116,
            size.height * 0.6327,
            size.width * 0.6692,
            size.height * 0.6151,
            size.width * 0.625,
            size.height * 0.6151,
          )
          ..lineTo(size.width * 0.375, size.height * 0.6151)
          ..cubicTo(
            size.width * 0.3308,
            size.height * 0.6151,
            size.width * 0.2884,
            size.height * 0.6327,
            size.width * 0.2571,
            size.height * 0.664,
          )
          ..cubicTo(
            size.width * 0.2259,
            size.height * 0.6952,
            size.width * 0.2083,
            size.height * 0.7376,
            size.width * 0.2083,
            size.height * 0.7818,
          )
          ..lineTo(size.width * 0.2083, size.height * 0.8651)
          ..moveTo(size.width * 0.625, size.height * 0.2818)
          ..cubicTo(
            size.width * 0.625,
            size.height * 0.3736,
            size.width * 0.5833,
            size.height * 0.4651,
            size.width * 0.5,
            size.height * 0.4651,
          )
          ..cubicTo(
            size.width * 0.4167,
            size.height * 0.4651,
            size.width * 0.375,
            size.height * 0.3736,
            size.width * 0.375,
            size.height * 0.2818,
          )
          ..cubicTo(
            size.width * 0.375,
            size.height * 0.19,
            size.width * 0.4167,
            size.height * 0.0985,
            size.width * 0.5,
            size.height * 0.0985,
          )
          ..cubicTo(
            size.width * 0.5833,
            size.height * 0.0985,
            size.width * 0.625,
            size.height * 0.19,
            size.width * 0.625,
            size.height * 0.2818,
          );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
