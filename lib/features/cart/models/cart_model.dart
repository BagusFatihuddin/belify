class CartItemModel {
  final String idKeranjang; // id dari keranjang_items
  final String idProduk; // product_id dari tabel produk
  final String nama;
  final int hargaAsli;
  final int diskon;
  final int hargaSetelahDiskon;
  int jumlah;
  final String gambar;

  CartItemModel({
    required this.idKeranjang,
    required this.idProduk,
    required this.nama,
    required this.hargaAsli,
    required this.diskon,
    required this.hargaSetelahDiskon,
    required this.jumlah,
    required this.gambar,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      idKeranjang: json['id'].toString(),
      idProduk: json['product_id'].toString(),
      nama: json['nama'] ?? '',
      hargaAsli: int.tryParse(json['harga_asli'].toString()) ?? 0,
      diskon: int.tryParse(json['diskon'].toString()) ?? 0,
      hargaSetelahDiskon:
          int.tryParse(json['harga_setelah_diskon'].toString()) ?? 0,
      jumlah: int.tryParse(json['jumlah'].toString()) ?? 0,
      gambar: json['gambar1'] ?? '',
    );
  }
}
