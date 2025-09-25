import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:belify/features/checkout/controller/order_detail_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final controller = OrderDetailController();

  bool isLoading = true;
  bool isUploading = false;
  Map<String, dynamic>? orderData;
  List<dynamic> orderItems = [];
  File? selectedImage;
  final primaryColor = const Color(0xFF1A7F65);

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final data = await controller.getOrderDetail(widget.orderId);
    if (mounted) {
      setState(() {
        orderData = data['order'];
        orderItems = data['items'];
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  Future<void> uploadAndSave() async {
    if (selectedImage == null) return;
    setState(() => isUploading = true);

    final url = await controller.uploadImage(selectedImage!);
    if (url != null) {
      final userId = await controller.getUserId();
      final success = await controller.savePayment(
        userId: userId,
        orderId: widget.orderId,
        paymentProofUrl: url,
      );

      if (success) {
        if (mounted) {
          setState(() {
            orderData!['status'] = 'menunggu_verifikasi';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bukti pembayaran berhasil diupload')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal simpan bukti pembayaran')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal upload gambar')));
    }

    if (mounted) setState(() => isUploading = false);
  }

  Widget buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'menunggu_pembayaran':
        color = Colors.orange;
        break;
      case 'menunggu_verifikasi':
        color = Colors.blue;
        break;
      case 'diproses':
        color = Colors.purple;
        break;
      case 'selesai':
        color = Colors.green;
        break;
      case 'dibatalkan':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Detail Pesanan'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Status: ", style: TextStyle(fontSize: 16)),
                buildStatusBadge(orderData!['status']),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Rekening Tujuan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text("BCA - 1234567890 (A/N Toko Belify)"),
            ),
            const SizedBox(height: 16),
            const Text("Produk", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  final item = orderItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['gambar_produk'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(item['nama_produk']),
                      subtitle: Text(
                        "Rp${item['harga_saat_pemesanan']} x ${item['jumlah']}",
                      ),
                    ),
                  );
                },
              ),
            ),
            if (orderData!['status'] == 'menunggu_pembayaran') ...[
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: isUploading ? null : pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text('Pilih Bukti Pembayaran'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              if (selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(selectedImage!, height: 150),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isUploading ? null : uploadAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isUploading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text("Upload & Simpan"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:belify/shared/services/api_base.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/foundation.dart';

// class OrderDetailScreen extends StatefulWidget {
//   final int orderId;

//   const OrderDetailScreen({super.key, required this.orderId});

//   @override
//   State<OrderDetailScreen> createState() => _OrderDetailScreenState();
// }

// class _OrderDetailScreenState extends State<OrderDetailScreen> {
//   bool isLoading = true;
//   bool isUploading = false;
//   Map<String, dynamic>? orderData;
//   List<dynamic> orderItems = [];
//   String? paymentProofUrl;
//   File? selectedImage;

//   final cloudName = 'dshhlawvf';
//   final uploadPreset = 'belify_upload';

//   @override
//   void initState() {
//     super.initState();
//     fetchOrderDetails();
//   }

//   Future<void> fetchOrderDetails() async {
//     try {
//       final res = await http.get(
//         Uri.parse(
//           '${ApiBase.baseUrl}orders/detail.php?order_id=${widget.orderId}',
//         ),
//       );

//       if (res.statusCode == 200) {
//         final data = await compute(
//           jsonDecode,
//           res.body,
//         ); // ⏱️ offload to background
//         if (mounted) {
//           setState(() {
//             orderData = data['order'];
//             orderItems = data['items'];
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
//       }
//     }
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => selectedImage = File(picked.path));
//     }
//   }

//   Future<void> uploadImage() async {
//     if (selectedImage == null) return;

//     setState(() => isUploading = true);

//     try {
//       final uri = Uri.parse(
//         "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
//       );
//       final request =
//           http.MultipartRequest('POST', uri)
//             ..fields['upload_preset'] = uploadPreset
//             ..files.add(
//               await http.MultipartFile.fromPath('file', selectedImage!.path),
//             );

//       final response = await request.send();
//       final resStr = await response.stream.bytesToString();
//       final result = jsonDecode(resStr);

//       if (response.statusCode == 200) {
//         paymentProofUrl = result['secure_url'];
//         await savePaymentProof();
//       } else {
//         throw Exception('Upload gagal: ${result['error']['message']}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Gagal upload gambar: $e')));
//     } finally {
//       if (mounted) setState(() => isUploading = false);
//     }
//   }

//   Future<void> savePaymentProof() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id') ?? 0;

//     final body = {
//       'order_id': widget.orderId.toString(),
//       'user_id': userId.toString(),
//       'bukti_pembayaran': paymentProofUrl,
//       'rekening_tujuan': 'BCA - 1234567890 (A/N Toko Belify)',
//       'metode_pembayaran': 'transfer_manual',
//     };

//     final res = await http.post(
//       Uri.parse('${ApiBase.baseUrl}payments/upload.php'),
//       body: body,
//     );

//     final result = jsonDecode(res.body);

//     if (res.statusCode == 200 && result['success']) {
//       if (mounted) {
//         setState(() => orderData!['status'] = 'menunggu_verifikasi');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Bukti pembayaran berhasil diupload')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal simpan bukti: ${result['message']}')),
//       );
//     }
//   }

//   final Color primaryColor = const Color(0xFF1A7F65);

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Detail Pesanan'),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Text("Status: ", style: TextStyle(fontSize: 16)),
//                 buildStatusBadge(orderData!['status']),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Rekening Tujuan",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: const Text("BCA - 1234567890 (A/N Toko Belify)"),
//             ),
//             const SizedBox(height: 16),
//             const Text("Produk", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: orderItems.length,
//                 itemBuilder: (context, index) {
//                   final item = orderItems[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 6),
//                     child: ListTile(
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           item['gambar_produk'],
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           errorBuilder:
//                               (_, __, ___) => const Icon(Icons.broken_image),
//                         ),
//                       ),
//                       title: Text(item['nama_produk']),
//                       subtitle: Text(
//                         "Rp${item['harga_saat_pemesanan']} x ${item['jumlah']}",
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             if (orderData!['status'] == 'menunggu_pembayaran') ...[
//               const SizedBox(height: 8),
//               ElevatedButton.icon(
//                 onPressed: isUploading ? null : pickImage,
//                 icon: const Icon(Icons.upload_file),
//                 label: const Text('Pilih Bukti Pembayaran'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey.shade200,
//                   foregroundColor: primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (selectedImage != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.file(selectedImage!, height: 150),
//                 ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isUploading ? null : uploadImage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child:
//                       isUploading
//                           ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                           : const Text("Upload & Simpan"),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildStatusBadge(String status) {
//     Color color;
//     switch (status.toLowerCase()) {
//       case 'menunggu_pembayaran':
//         color = Colors.orange;
//         break;
//       case 'menunggu_verifikasi':
//         color = Colors.blue;
//         break;
//       case 'diproses':
//         color = Colors.purple;
//         break;
//       case 'selesai':
//         color = Colors.green;
//         break;
//       case 'dibatalkan':
//         color = Colors.red;
//         break;
//       default:
//         color = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: color,
//         ),
//       ),
//     );
//   }
// }
