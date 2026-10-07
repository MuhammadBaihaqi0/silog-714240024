// MODUL PRAKTIKUM 3
// NULL SAFETY DAN PEMROGRAMAN ASINKRON
// File: modul03_async.dart

// TUGAS PRAKTIKUM 1
// DATABASE DATA KIRIMAN

final Map<String, String> dataKiriman = {
  'SLG-001': 'Bandung',
  'SLG-002': 'Surabaya',
  'SLG-003': 'Jakarta',
  'SLG-004': 'Yogyakarta',
  'SLG-005': 'Semarang',
};

// EXCEPTION UNTUK RESI TIDAK DITEMUKAN

class ResiTidakDitemukan implements Exception {
  final String resi;

  ResiTidakDitemukan(this.resi);

  @override
  String toString() {
    return 'Resi $resi tidak ditemukan pada basis data.';
  }
}

// LATIHAN 3
// FUTURE, ASYNC, DAN AWAIT

Future<String> ambilStatusKiriman(String resi) async {
  // Simulasi jeda jaringan selama dua detik
  await Future.delayed(const Duration(seconds: 2));

  // Mencari resi pada Map
  final kota = dataKiriman[resi];

  // Jika resi tidak ditemukan
  if (kota == null) {
    throw ResiTidakDitemukan(resi);
  }

  // Jika resi ditemukan
  return 'Paket $resi sedang dalam perjalanan menuju $kota.';
}

// FUNGSI MENGAMBIL ONGKOS KIRIM

Future<double> ambilOngkir(String resi) async {
  // Simulasi proses selama satu detik
  await Future.delayed(const Duration(seconds: 1));

  return 105400;
}

// LATIHAN 3
// PEMANGGILAN ASYNC SECARA BERURUTAN

Future<void> latihanAsync() async {
  print('LATIHAN 3 - ASYNC DAN AWAIT');

  print('1. Permintaan data dikirim...');

  try {
    // Menunggu proses mengambil status selesai
    final status = await ambilStatusKiriman('SLG-002');

    print('2. $status');

    // Setelah proses pertama selesai,
    // baru proses kedua dijalankan
    final ongkir = await ambilOngkir('SLG-002');

    print('3. Ongkos kirim: Rp${ongkir.toStringAsFixed(0)}');
  } on ResiTidakDitemukan catch (e) {
    print('Peringatan: $e');
  } on FormatException catch (e) {
    print('Kesalahan format: ${e.message}');
  } catch (e) {
    print('Gagal mengambil data: $e');
  }

  print('4. Proses selesai.');
  print('');
}

// LATIHAN 4
// FUTURE.WAIT

Future<void> bandingkanWaktu() async {
  print('LATIHAN 4 - FUTURE.WAIT');

  final mulai = DateTime.now();

  // Kedua proses dijalankan secara bersamaan
  final hasil = await Future.wait([
    ambilStatusKiriman('SLG-001'),
    ambilOngkir('SLG-001'),
  ]);

  final durasi = DateTime.now().difference(mulai);

  print('Status : ${hasil[0]}');
  print('Ongkir : ${hasil[1]}');
  print('Durasi total: ${durasi.inMilliseconds} ms');

  print('');
}

// TUGAS PRAKTIKUM 2
// MEMANTAU BANYAK RESI SECARA BERSAMAAN

Future<void> pantauBanyakResi(List<String> daftarResi) async {
  print('TUGAS PRAKTIKUM - PANTAU BANYAK RESI');

  // Semua resi diproses secara bersamaan
  final hasil = await Future.wait(
    daftarResi.map((resi) async {
      try {
        final status = await ambilStatusKiriman(resi);

        return 'BERHASIL | $status';
      } on ResiTidakDitemukan catch (e) {
        // Jika resi tidak ditemukan,
        // proses resi lain tetap berjalan
        return 'GAGAL | $e';
      } catch (e) {
        return 'ERROR | $resi | $e';
      }
    }),
  );

  // Menampilkan seluruh hasil
  for (final hasilResi in hasil) {
    print(hasilResi);
  }

  print('');
}

// MAIN PROGRAM

Future<void> main() async {
  // ----------------------------------------------------------
  // BAGIAN 1
  // Latihan async dan await
  // ----------------------------------------------------------

  await latihanAsync();

  // ----------------------------------------------------------
  // BAGIAN 2
  // Latihan Future.wait
  // ----------------------------------------------------------

  await bandingkanWaktu();

  // ----------------------------------------------------------
  // BAGIAN 3
  // TUGAS PRAKTIKUM
  // Skenario seluruh resi valid
  // ----------------------------------------------------------

  print('SKENARIO 1 - SEMUA RESI VALID');

  await pantauBanyakResi([
    'SLG-001',
    'SLG-002',
    'SLG-003',
    'SLG-004',
    'SLG-005',
  ]);

  // ----------------------------------------------------------
  // BAGIAN 4
  // TUGAS PRAKTIKUM
  // Skenario terdapat resi tidak valid
  // ----------------------------------------------------------

  print('SKENARIO 2 - ADA RESI TIDAK VALID');

  await pantauBanyakResi([
    'SLG-001',
    'SLG-999',
    'SLG-003',
    'SLG-888',
    'SLG-005',
  ]);
}
