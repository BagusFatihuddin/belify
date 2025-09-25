class ProductModel {
  final String nama, harga, diskon, deskripsi, stok, gambarUrl;

  ProductModel({
    required this.nama,
    required this.harga,
    required this.diskon,
    required this.deskripsi,
    required this.stok,
    required this.gambarUrl,
  });

  Map<String, String> toMap({int? id}) => {
    if (id != null) 'id': id.toString(),
    'nama': nama,
    'harga': harga,
    'diskon': diskon,
    'deskripsi': deskripsi,
    'stok': stok,
    'gambar1': gambarUrl,
    'gambar2': '',
    'gambar3': '',
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    nama: json['nama'],
    harga: json['harga'],
    diskon: json['diskon'],
    deskripsi: json['deskripsi'],
    stok: json['stok'],
    gambarUrl: json['gambar1'],
  );
}

// class ProductModel {
//   final String nama, harga, diskon, deskripsi, stok, gambarUrl;

//   ProductModel({
//     required this.nama,
//     required this.harga,
//     required this.diskon,
//     required this.deskripsi,
//     required this.stok,
//     required this.gambarUrl,
//   });

//   Map<String, String> toMap() => {
//     'nama': nama,
//     'harga': harga,
//     'diskon': diskon,
//     'deskripsi': deskripsi,
//     'stok': stok,
//     'gambar1': gambarUrl,
//     'gambar2': '',
//     'gambar3': '',
//   };
// }
