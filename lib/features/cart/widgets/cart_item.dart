import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItem extends StatefulWidget {
  final String imageUrl;
  final String name;
  final int currentPrice;
  final int originalPrice;
  final int discountPercentage;
  final int quantity;
  final Function(int) onQuantityChanged;

  const CartItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(quantity);
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalHarga = widget.currentPrice * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(),
          const SizedBox(width: 16),
          Expanded(child: _buildProductDetails(totalHarga)),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.white,
      alignment: Alignment.center,
      child: Image.network(
        widget.imageUrl,
        width: 94,
        height: 94,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 94,
            height: 94,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildProductDetails(int totalHarga) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF404040),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Rp ${formatCurrency(widget.currentPrice)}',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF404040),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Rp ${formatCurrency(widget.originalPrice)}',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9E9E9E),
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE44A4A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${widget.discountPercentage}% OFF',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Total: Rp ${formatCurrency(totalHarga)}',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A7F65),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'lib/shared/assets/icons/loveIcon.svg',
              width: 24,
              height: 24,
            ),
            _buildQuantitySelector(),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _decreaseQuantity,
            child: SvgPicture.asset(
              'lib/shared/assets/icons/minusIcon.svg',
              width: 24,
              height: 24,
            ),
          ),
          Expanded(
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF404040),
              ),
            ),
          ),
          GestureDetector(
            onTap: _increaseQuantity,
            child: SvgPicture.asset(
              'lib/shared/assets/icons/addIcon.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  String formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
