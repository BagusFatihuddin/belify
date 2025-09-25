import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviews;

  const RatingStars({Key? key, required this.rating, required this.reviews})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPaint(
          size: const Size(74, 18),
          painter: RatingStarsPainter(rating: rating),
        ),
        const SizedBox(width: 4),
        Text(
          '$rating ($reviews)',
          style: const TextStyle(
            color: Color(0xFF404040),
            fontSize: 12,
            fontFamily: 'Manrope',
          ),
        ),
      ],
    );
  }
}

class RatingStarsPainter extends CustomPainter {
  final double rating;

  RatingStarsPainter({required this.rating});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = const Color(0xFFEBB65B)
          ..style = PaintingStyle.fill;

    // Draw a star shape
    final Path path = Path();

    // Star path coordinates (simplified from SVG)
    path.moveTo(8.06293, 2.51511);
    path.lineTo(9.93707, 2.51511);
    path.lineTo(10.9849, 5.32741);
    path.lineTo(14.8779, 6.10485);
    path.lineTo(15.4571, 7.88727);
    path.lineTo(13.1062, 9.75284);
    path.lineTo(13.5698, 13.6956);
    path.lineTo(12.0536, 14.7972);
    path.lineTo(9.55289, 13.1379);
    path.lineTo(8.44711, 13.1379);
    path.lineTo(5.94639, 14.7972);
    path.lineTo(4.43017, 13.6956);
    path.lineTo(5.23551, 10.8045);
    path.lineTo(4.8938, 9.75284);
    path.lineTo(2.54293, 7.88727);
    path.lineTo(3.12207, 6.10485);
    path.lineTo(6.12052, 5.97738);
    path.lineTo(7.01512, 5.32741);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
