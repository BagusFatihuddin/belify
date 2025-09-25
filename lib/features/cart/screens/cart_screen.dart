import 'package:belify/features/checkout/screen/checkout_screen.dart';
import 'package:belify/features/checkout/screen/order_history_screen.dart';
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';
import '../widgets/cart_item.dart';
import '../widgets/bottom_navigation.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = CartController();
  List<CartItemModel> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final items = await cartController.fetchCartItems();
      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('Gagal ambil data keranjang: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity({
    required int index,
    required int newQty,
  }) async {
    setState(() {
      cartItems[index].jumlah = newQty;
    });

    try {
      await cartController.updateQuantity(
        userId: widget.userId,
        productId: cartItems[index].idProduk,
        quantity: newQty,
      );
    } catch (e) {
      print('Gagal update qty: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal update jumlah item.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : _buildCartItemsList(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                const CheckoutScreen(), // update kalau perlu kirim user_id
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Checkout Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const CustomBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Cart',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF404040),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.history, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Riwayat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return CartItem(
              imageUrl: item.gambar,
              name: item.nama,
              currentPrice: item.hargaSetelahDiskon,
              originalPrice: item.hargaAsli,
              discountPercentage: item.diskon,
              quantity: item.jumlah,
              onQuantityChanged:
                  (newQty) => _updateQuantity(index: index, newQty: newQty),
            );
          },
        ),
      ),
    );
  }
}
