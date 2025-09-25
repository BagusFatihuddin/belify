import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/admin_order_detail_controller.dart';

class AdminOrderDetailScreen extends StatefulWidget {
  final int orderId;
  const AdminOrderDetailScreen({super.key, required this.orderId});

  @override
  State<AdminOrderDetailScreen> createState() => _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState extends State<AdminOrderDetailScreen> {
  final controller = AdminOrderDetailController();
  final _primaryColor = const Color(0xFF1A7F65);
  final statusList = [
    'menunggu_pembayaran',
    'menunggu_verifikasi',
    'dikemas',
    'dikirim',
    'selesai',
  ];

  bool isLoading = true;
  Map<String, dynamic>? order;
  List<dynamic> items = [];
  Map<String, dynamic>? pembayaran;

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    final data = await controller.getOrderDetail(widget.orderId);
    if (data != null) {
      setState(() {
        order = data['order'];
        items = data['items'];
        pembayaran = data['pembayaran'];
        isLoading = false;
      });
    }
  }

  Future<void> updateStatus(String newStatus) async {
    final success = await controller.updateOrderStatus(
      widget.orderId,
      newStatus,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status diperbarui ke $newStatus")),
      );
      fetchOrder();
    }
  }

  Future<void> deleteOrder() async {
    final success = await controller.deleteOrder(widget.orderId);
    if (success) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pesanan berhasil dihapus")),
        );
      }
    }
  }

  Widget buildDetailCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order #${widget.orderId}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pelanggan: ${order!['nama_user']}",
              style: GoogleFonts.poppins(),
            ),
            Text(
              "Total: Rp${order!['total_harga']}",
              style: GoogleFonts.poppins(),
            ),
            Text("Status: ${order!['status']}", style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }

  Widget buildProdukList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Produk:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['gambar1'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item['nama'], style: GoogleFonts.poppins()),
                subtitle: Text(
                  "Jumlah: ${item['jumlah']}",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPembayaranSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bukti Pembayaran:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            if (pembayaran != null && pembayaran!['bukti_pembayaran'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pembayaran!['bukti_pembayaran'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Text("Belum ada bukti pembayaran.", style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }

  Widget buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: order!['status'],
      items:
          statusList
              .map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(status, style: GoogleFonts.poppins()),
                ),
              )
              .toList(),
      onChanged: (val) {
        if (val != null) updateStatus(val);
      },
      decoration: InputDecoration(
        labelText: 'Ubah Status',
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.black),
      dropdownColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesanan #${widget.orderId}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildDetailCard(),
            buildProdukList(),
            buildPembayaranSection(),
            const SizedBox(height: 12),
            buildStatusDropdown(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: deleteOrder,
              icon: const Icon(Icons.delete),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
              ),
              label: Text(
                "Hapus Pesanan",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class AdminOrderDetailScreen extends StatefulWidget {
//   final int orderId;
//   const AdminOrderDetailScreen({super.key, required this.orderId});

//   @override
//   State<AdminOrderDetailScreen> createState() => _AdminOrderDetailScreenState();
// }

// class _AdminOrderDetailScreenState extends State<AdminOrderDetailScreen> {
//   bool isLoading = true;
//   Map<String, dynamic>? order;
//   List<dynamic> items = [];
//   Map<String, dynamic>? pembayaran;
//   final _primaryColor = const Color(0xFF1A7F65);

//   final statusList = [
//     'menunggu_pembayaran',
//     'menunggu_verifikasi',
//     'dikemas',
//     'dikirim',
//     'selesai',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchDetail();
//   }

//   Future<void> fetchDetail() async {
//     final res = await http.get(
//       Uri.parse(
//         '${ApiBase.baseUrl}admin/orders/detail.php?order_id=${widget.orderId}',
//       ),
//     );

//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       if (data['success']) {
//         setState(() {
//           order = data['order'];
//           items = data['items'];
//           pembayaran = data['pembayaran'];
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> updateStatus(String newStatus) async {
//     final res = await http.post(
//       Uri.parse('${ApiBase.baseUrl}admin/orders/update_status.php'),
//       body: {'order_id': widget.orderId.toString(), 'status': newStatus},
//     );

//     final data = jsonDecode(res.body);
//     if (data['success']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status diperbarui ke $newStatus")),
//       );
//       fetchDetail(); // refresh
//     }
//   }

//   Future<void> deleteOrder() async {
//     final res = await http.post(
//       Uri.parse('${ApiBase.baseUrl}admin/orders/delete.php'),
//       body: {'order_id': widget.orderId.toString()},
//     );

//     final data = jsonDecode(res.body);
//     if (data['success']) {
//       if (context.mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Pesanan berhasil dihapus")),
//         );
//       }
//     }
//   }

//   Widget buildDetailCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Order #${widget.orderId}",
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: _primaryColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Pelanggan: ${order!['nama_user']}",
//               style: GoogleFonts.poppins(),
//             ),
//             Text(
//               "Total: Rp${order!['total_harga']}",
//               style: GoogleFonts.poppins(),
//             ),
//             Text("Status: ${order!['status']}", style: GoogleFonts.poppins()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildProdukList() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Daftar Produk:",
//               style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             ...items.map(
//               (item) => ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     item['gambar1'],
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 title: Text(item['nama'], style: GoogleFonts.poppins()),
//                 subtitle: Text(
//                   "Jumlah: ${item['jumlah']}",
//                   style: GoogleFonts.poppins(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildPembayaranSection() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Bukti Pembayaran:",
//               style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 10),
//             if (pembayaran != null && pembayaran!['bukti_pembayaran'] != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   pembayaran!['bukti_pembayaran'],
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               )
//             else
//               Text("Belum ada bukti pembayaran.", style: GoogleFonts.poppins()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildStatusDropdown() {
//     return DropdownButtonFormField<String>(
//       value: order!['status'],
//       items:
//           statusList.map((status) {
//             return DropdownMenuItem(
//               value: status,
//               child: Text(
//                 status,
//                 style: GoogleFonts.poppins(
//                   color: Colors.black,
//                 ), // <- warna teks item
//               ),
//             );
//           }).toList(),
//       onChanged: (val) {
//         if (val != null) updateStatus(val);
//       },
//       decoration: InputDecoration(
//         labelText: 'Ubah Status',
//         labelStyle: GoogleFonts.poppins(),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: _primaryColor),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       style: GoogleFonts.poppins(color: Colors.black), // <- warna teks terpilih
//       dropdownColor: Colors.white, // <- biar dropdown-nya nggak abu/gelap
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Pesanan #${widget.orderId}',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: _primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             buildDetailCard(),
//             buildProdukList(),
//             buildPembayaranSection(),
//             const SizedBox(height: 12),
//             buildStatusDropdown(),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: deleteOrder,
//               icon: const Icon(Icons.delete),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 14,
//                   horizontal: 24,
//                 ),
//               ),
//               label: Text(
//                 "Hapus Pesanan",
//                 style: GoogleFonts.poppins(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
