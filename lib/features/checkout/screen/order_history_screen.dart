import 'package:belify/features/checkout/controller/order_controller.dart';
import './OrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final controller = OrderController();
  List<dynamic> orders = [];
  bool isLoading = true;
  final Color primaryColor = const Color(0xFF1A7F65);

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final userId = await controller.getUserId();
    final orderList = await controller.getOrders(userId);
    setState(() {
      orders = orderList;
      isLoading = false;
    });
  }

  String formatTanggal(String rawDateTime) {
    try {
      final dateTime = DateTime.parse(rawDateTime);
      return DateFormat("d MMMM yyyy, HH:mm", "id_ID").format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  Widget buildStatusBadge(String status) {
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'diproses':
        bgColor = Colors.orange;
        break;
      case 'selesai':
        bgColor = Colors.green;
        break;
      case 'dibatalkan':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        border: Border.all(color: bgColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: bgColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Riwayat Pesanan'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
              ? const Center(child: Text('Belum ada pesanan'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => OrderDetailScreen(orderId: order['id']),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pesanan #${order['id']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                buildStatusBadge(order['status']),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Total: Rp${order['total_harga']}",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Metode: ${order['metode_pembayaran']}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Tanggal: ${order['waktu_pemesanan'] != null ? formatTanggal(order['waktu_pemesanan']) : '-'}",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

//=============================================================================
// import 'package:belify/features/checkout/controller/order_controller.dart';
// import './OrderDetailScreen.dart';
// import 'package:flutter/material.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});

//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   final controller = OrderController();
//   List<dynamic> orders = [];
//   bool isLoading = true;
//   final Color primaryColor = const Color(0xFF1A7F65);

//   @override
//   void initState() {
//     super.initState();
//     loadOrders();
//   }

//   Future<void> loadOrders() async {
//     final userId = await controller.getUserId();
//     final orderList = await controller.getOrders(userId);
//     setState(() {
//       orders = orderList;
//       isLoading = false;
//     });
//   }

//   Widget buildStatusBadge(String status) {
//     Color bgColor;
//     switch (status.toLowerCase()) {
//       case 'diproses':
//         bgColor = Colors.orange;
//         break;
//       case 'selesai':
//         bgColor = Colors.green;
//         break;
//       case 'dibatalkan':
//         bgColor = Colors.red;
//         break;
//       default:
//         bgColor = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor.withOpacity(0.2),
//         border: Border.all(color: bgColor),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: bgColor,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Riwayat Pesanan'),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : orders.isEmpty
//               ? const Center(child: Text('Belum ada pesanan'))
//               : ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 16,
//                 ),
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   final order = orders[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (_) => OrderDetailScreen(orderId: order['id']),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Pesanan #${order['id']}",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 buildStatusBadge(order['status']),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "Total: Rp${order['total_harga']}",
//                               style: TextStyle(
//                                 color: primaryColor,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Metode: ${order['metode_pembayaran']}",
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               "Tanggal: ${order['tanggal'] ?? '-'}",
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

//===================================================================

// import 'dart:convert';
// import 'package:belify/features/checkout/screen/OrderDetailScreen.dart';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});

//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   List<dynamic> orders = [];
//   bool isLoading = true;

//   final Color primaryColor = const Color(0xFF1A7F65);

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   Future<void> fetchOrders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id') ?? 0;

//     final res = await http.get(
//       Uri.parse('${ApiBase.baseUrl}orders/user.php?user_id=$userId'),
//     );

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);
//       if (body['success']) {
//         setState(() {
//           orders = body['data'];
//           isLoading = false;
//         });
//       } else {
//         setState(() => isLoading = false);
//       }
//     }
//   }

//   Widget buildStatusBadge(String status) {
//     Color bgColor;
//     switch (status.toLowerCase()) {
//       case 'diproses':
//         bgColor = Colors.orange;
//         break;
//       case 'selesai':
//         bgColor = Colors.green;
//         break;
//       case 'dibatalkan':
//         bgColor = Colors.red;
//         break;
//       default:
//         bgColor = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor.withOpacity(0.2),
//         border: Border.all(color: bgColor),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: bgColor,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Riwayat Pesanan'),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : orders.isEmpty
//               ? const Center(child: Text('Belum ada pesanan'))
//               : ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 16,
//                 ),
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   final order = orders[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (_) => OrderDetailScreen(orderId: order['id']),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Pesanan #${order['id']}",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 buildStatusBadge(order['status']),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "Total: Rp${order['total_harga']}",
//                               style: TextStyle(
//                                 color: primaryColor,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Metode: ${order['metode_pembayaran']}",
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               "Tanggal: ${order['tanggal'] ?? '-'}",
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }
