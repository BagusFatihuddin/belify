// import 'package:belify/features/checkout/controller/checkout_controller.dart';
// import 'package:flutter/material.dart';
// import 'order_history_screen.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final controller = CheckoutController();

//   List<dynamic> cartItems = [];
//   int total = 0;
//   String metode = 'transfer';
//   bool isLoading = true;

//   final Color primaryColor = const Color(0xFF1A7F65);

//   @override
//   void initState() {
//     super.initState();
//     loadCart();
//   }

//   Future<void> loadCart() async {
//     final userId = await controller.getUserId();
//     final items = await controller.getCartItems(userId);
//     setState(() {
//       cartItems = items;
//       total = controller.calculateTotal(items);
//       isLoading = false;
//     });
//   }

//   Future<void> handleCheckout() async {
//     final userId = await controller.getUserId();
//     final result = await controller.checkout(userId, metode);

//     if (result['success']) {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
//         );
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Checkout gagal')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Checkout'),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Pilih Metode Pembayaran",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               RadioListTile(
//                                 activeColor: primaryColor,
//                                 title: const Text("Transfer Manual"),
//                                 value: 'transfer',
//                                 groupValue: metode,
//                                 onChanged:
//                                     (val) => setState(() => metode = val!),
//                               ),
//                               RadioListTile(
//                                 activeColor: primaryColor,
//                                 title: const Text("Bayar di Tempat (COD)"),
//                                 value: 'cod',
//                                 groupValue: metode,
//                                 onChanged:
//                                     (val) => setState(() => metode = val!),
//                               ),
//                               const Divider(height: 32),
//                               Text(
//                                 "Total Pembayaran",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               Text(
//                                 "Rp$total",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: primaryColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: handleCheckout,
//                         icon: const Icon(Icons.check_circle_outline),
//                         label: const Text("Checkout Sekarang"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           textStyle: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
//=========================================================================

import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<dynamic> cartItems = [];
  int total = 0;
  String metode = 'transfer';
  bool isLoading = true;

  final Color primaryColor = const Color(0xFF1A7F65);

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;

    final res = await http.get(
      Uri.parse('${ApiBase.baseUrl}cart/get.php?user_id=$userId'),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success']) {
        setState(() {
          cartItems = body['data'];
          total = cartItems.fold<int>(0, (sum, item) {
            final harga =
                int.tryParse(
                  item['harga'].toString().replaceAll(RegExp(r'[^0-9]'), ''),
                ) ??
                0;
            final qty = int.tryParse(item['jumlah'].toString()) ?? 0;
            return sum + (harga * qty);
          });
          isLoading = false;
        });
      }
    }
  }

  Future<void> checkout() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;

    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}orders/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'metode_pembayaran': metode,
        'alamat_pengiriman': 'Alamat default user',
      }),
    );

    final body = jsonDecode(response.body);
    if (body['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'] ?? 'Checkout gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Checkout'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pilih Metode Pembayaran",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RadioListTile(
                                activeColor: primaryColor,
                                title: const Text("Transfer Manual"),
                                value: 'transfer',
                                groupValue: metode,
                                onChanged:
                                    (val) => setState(() => metode = val!),
                              ),
                              RadioListTile(
                                activeColor: primaryColor,
                                title: const Text("Bayar di Tempat (COD)"),
                                value: 'cod',
                                groupValue: metode,
                                onChanged:
                                    (val) => setState(() => metode = val!),
                              ),
                              const Divider(height: 32),
                              Text(
                                "Total Pembayaran",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "Rp$total",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: checkout,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Checkout Sekarang"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
