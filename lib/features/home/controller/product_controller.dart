import 'dart:convert';
import 'package:belify/shared/services/api_base.dart';
import 'package:http/http.dart' as http;

class ProdukModel {
  final int id;
  final String nama;
  final int harga;
  final int diskon;
  final String deskripsi;
  final int stok;
  final String gambar;

  ProdukModel({
    required this.id,
    required this.nama,
    required this.harga,
    required this.diskon,
    required this.deskripsi,
    required this.stok,
    required this.gambar,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: int.parse(json['id']),
      nama: json['nama'],
      harga: int.parse(json['harga']),
      diskon: int.parse(json['diskon']),
      deskripsi: json['deskripsi'],
      stok: int.parse(json['stok']),
      gambar: json['gambar1'] ?? '',
    );
  }
}

class ProdukController {
  final String baseUrl = '${ApiBase.baseUrl}produk/read.php';

  Future<List<ProdukModel>> fetchProduk() async {
    final res = await http.get(Uri.parse(baseUrl));
    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded['status'] == true && decoded['data'] != null) {
        final List<dynamic> data = decoded['data'];
        return data.map((item) => ProdukModel.fromJson(item)).toList();
      } else {
        throw Exception('Data kosong atau status false');
      }
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }
}
