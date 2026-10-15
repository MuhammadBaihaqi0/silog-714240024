class Pelanggan {
  final String kode;
  final String nama;
  final String nomorTelepon;
  final String alamat;

  Pelanggan({
    required this.kode,
    required this.nama,
    required this.nomorTelepon,
    required this.alamat,
  });

  String alamatRingkas() {
    if (alamat.length <= 40) {
      return alamat;
    }
    return '${alamat.substring(0, 37)}...';
  }

  @override
  String toString() => '[$kode] $nama - $nomorTelepon';
}