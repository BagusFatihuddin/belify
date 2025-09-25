import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/product_controller.dart';
import '../widgets/rating_stars.dart';

class ProductInfo extends StatefulWidget {
  final int id;

  const ProductInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  late Future<ProdukModel?> produkFuture;

  @override
  void initState() {
    super.initState();
    debugToken(); // 🔍 Tambahin ini untuk cek isi SharedPreferences
    produkFuture = getProdukById(widget.id);
  }

  void debugToken() async {
    final prefs = await SharedPreferences.getInstance();
    print('🔐 TOKEN: ${prefs.getString('token')}');
    print('👤 ROLE: ${prefs.getString('role')}');
    print('🆔 USER_ID: ${prefs.getInt('user_id')}');
  }

  Future<ProdukModel?> getProdukById(int id) async {
    try {
      List<ProdukModel> semuaProduk = await ProdukController().fetchProduk();
      return semuaProduk.firstWhere(
        (produk) => produk.id == id,
        orElse: () => throw 'Produk tidak ditemukan',
      );
    } catch (e) {
      debugPrint('Error ambil produk: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> addToCart(ProdukModel produk) async {
    final userToken = await getToken();

    if (userToken == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Token tidak ditemukan')));
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}cart/tambah.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: jsonEncode({'product_id': produk.id, 'jumlah': 1}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('✅ ${data["message"]}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${data["message"] ?? "Gagal menambahkan"}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProdukModel?>(
        future: produkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }

          ProdukModel produk = snapshot.data!;
          double hargaDiskon = produk.harga * (1 - produk.diskon / 100);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 42,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          produk.gambar,
                          height: 400,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk.nama,
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Rp${hargaDiskon.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFF404040),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rp${produk.harga.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFF404040),
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE44A4A),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      '${produk.diskon}% OFF',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const RatingStars(rating: 4.9, reviews: 256),
                              const SizedBox(height: 14),
                              const Text(
                                'Product Description',
                                style: TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                produk.deskripsi,
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildSizeSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => addToCart(produk),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF156651),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tambah ke Keranjang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSizeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Size',
            style: TextStyle(
              color: Color(0xFF404040),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 10),
          _buildSizeRow('Width:', '70 cm'),
          _divider(),
          _buildSizeRow('Depth:', '73 cm'),
          _divider(),
          _buildSizeRow('Height:', '75 cm'),
          _divider(),
          _buildSizeRow('Seat Width:', '57 cm'),
          _divider(),
          _buildSizeRow('Seat Depth:', '46 cm'),
          _divider(),
          _buildSizeRow('Seat Height:', '43 cm'),
          const SizedBox(height: 16),
          // Image.network(
          //   'https://cdn.builder.io/api/v1/image/assets/TEMP/b94176fc766cd380bd8a1786136c2d31bcbc6874',
          //   width: double.infinity,
          //   height: 335,
          //   fit: BoxFit.contain,
          // ),
        ],
      ),
    );
  }

  Widget _buildSizeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF404040),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Manrope',
              letterSpacing: -0.3,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF404040),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Manrope',
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: const Color.fromARGB(255, 255, 255, 255),
      // color: const Color(0xFFE0E0E0),
    );
  }
}
