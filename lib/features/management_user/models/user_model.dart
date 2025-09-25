class User {
  final int id;
  final String nama;
  final String email;
  final String nomorHp;
  final String alamat;
  final String role;

  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.nomorHp,
    required this.alamat,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      nama: json['nama'],
      email: json['email'],
      nomorHp: json['nomor_hp'],
      alamat: json['alamat'] ?? '',
      role: json['role'],
    );
  }
}
