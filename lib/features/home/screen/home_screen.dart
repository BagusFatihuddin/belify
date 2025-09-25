import 'package:belify/features/management_produk/screen/create_product_screen.dart';
import 'package:belify/features/management_produk/screen/edit_product_screen.dart';
import 'package:belify/features/detail_produk/screens/product_info.dart';
import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/location_selector.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_navigation.dart';
import '../controller/product_controller.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProdukModel> produkList = [];
  bool isLoading = true;

  final ProdukController produkController = ProdukController();

  @override
  void initState() {
    super.initState();
    loadProduk();
  }

  Future<void> loadProduk() async {
    try {
      final list = await produkController.fetchProduk();
      setState(() {
        produkList = list;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: CustomSearchBar(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: LocationSelector(),
              ),
              const SizedBox(height: 24),
              const PromotionalBanner(),

              // TOMBOL TAMBAH PRODUK (KHUSUS ADMIN)
              if (widget.role == 'admin')
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateProductScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Tambah Produk',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1A7F65,
                      ), // warna hijau tua
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Special Offers',
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontFamily: 'Manrope',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'See More',
                            style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Manrope',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.68,
                          children:
                              produkList.map((produk) {
                                final hargaDiskon =
                                    produk.harga -
                                    ((produk.harga * produk.diskon) ~/ 100);

                                return ProductCard(
                                  imageUrl: produk.gambar,
                                  discountPercentage: '${produk.diskon}% OFF',
                                  productName: produk.nama,
                                  currentPrice: _formatCurrency(hargaDiskon),
                                  originalPrice: _formatCurrency(produk.harga),
                                  rating: '4.8',
                                  reviewCount: '128',
                                  onTap: () {
                                    if (widget.role == 'admin') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditProductScreen(
                                                id: produk.id,
                                              ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => ProductInfo(id: produk.id),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                        ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  String _formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
