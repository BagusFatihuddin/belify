import 'package:flutter/material.dart';
import '../utils/svg_icons.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String discountPercentage;
  final String productName;
  final String currentPrice;
  final String originalPrice;
  final String rating;
  final String reviewCount;
  final VoidCallback onTap; // 👈 Tambahkan ini

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.discountPercentage,
    required this.productName,
    required this.currentPrice,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.onTap, // 👈 Tambahkan ini juga
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 👈 Pakai di sini
      // onTap: () {
      //   print('Product tapped: $productName');
      //   // TODO: Navigasi ke halaman detail produk
      // },
      child: Container(
        width: double.infinity,
        // width: 152,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 121,
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(3),
                    color: Colors.white,
                    child: Center(
                      child: Image.network(
                        imageUrl.isNotEmpty
                            ? imageUrl
                            : 'https://via.placeholder.com/120',
                        width: 112,
                        height: 113,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        discountPercentage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF404040),
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentPrice,
              style: const TextStyle(
                color: Color(0xFF404040),
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              originalPrice,
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.2,
                decoration: TextDecoration.lineThrough,
              ),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                SvgIcon.star(),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: const TextStyle(
                    color: Color(0xFF404040),
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($reviewCount)',
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
