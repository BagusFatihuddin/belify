import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/admin_order_list_controller.dart';
import 'AdminOrderDetailScreen.dart';

class AdminOrderListScreen extends StatefulWidget {
  const AdminOrderListScreen({super.key});

  @override
  State<AdminOrderListScreen> createState() => _AdminOrderListScreenState();
}

class _AdminOrderListScreenState extends State<AdminOrderListScreen> {
  final controller = AdminOrderListController();
  final Color _primaryColor = const Color(0xFF1A7F65);
  bool isLoading = true;
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = await controller.getOrders();
    if (mounted) setState(() => isLoading = false);
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      AdminOrderDetailScreen(orderId: int.parse(order['id'])),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order #${order['id']}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pelanggan: ${order['nama_user']}",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "Total: Rp${order['total_harga']}",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "Status: ${order['status']}",
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Kelola Pesanan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchOrders,
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder:
                      (context, index) => _buildOrderCard(orders[index]),
                ),
              ),
    );
  }
}

// import 'dart:convert';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
// import 'AdminOrderDetailScreen.dart';

// class AdminOrderListScreen extends StatefulWidget {
//   const AdminOrderListScreen({super.key});

//   @override
//   State<AdminOrderListScreen> createState() => _AdminOrderListScreenState();
// }

// class _AdminOrderListScreenState extends State<AdminOrderListScreen> {
//   final Color _primaryColor = const Color(0xFF1A7F65);
//   bool isLoading = true;
//   List<dynamic> orders = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   Future<void> fetchOrders() async {
//     final res = await http.get(
//       Uri.parse('${ApiBase.baseUrl}admin/orders/index.php'),
//     );

//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       if (data['success']) {
//         setState(() {
//           orders = data['data'];
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Widget _buildOrderCard(Map<String, dynamic> order) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 3,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (_) =>
//                       AdminOrderDetailScreen(orderId: int.parse(order['id'])),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Order #${order['id']}",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: _primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "Pelanggan: ${order['nama_user']}",
//                 style: GoogleFonts.poppins(fontSize: 14),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "Total: Rp${order['total_harga']}",
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 6),
//                   Text(
//                     "Status: ${order['status']}",
//                     style: GoogleFonts.poppins(
//                       fontSize: 13,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           'Kelola Pesanan',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//                 onRefresh: fetchOrders,
//                 child: ListView.builder(
//                   itemCount: orders.length,
//                   itemBuilder:
//                       (context, index) => _buildOrderCard(orders[index]),
//                 ),
//               ),
//     );
//   }
// }
