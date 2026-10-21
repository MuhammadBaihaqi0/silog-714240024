import '../lib/layanan/layanan_pengiriman.dart';
import '../lib/layanan/moda.dart';

void main() {
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(
      kodeLayanan: 'TRK-REG',
      jarakKm: 780,
      beratKg: 1200,
    ),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP',
      jarakKm: 780,
      beratKg: 1200,
      ekspres: true,
    ),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    PengirimanUdara(
      kodeLayanan: 'UDR-EXP',
      jarakKm: 780,
      beratKg: 120,
      panjangCm: 80,
      lebarCm: 60,
      tinggiCm: 50,
    ),
  ];

  print('=== Perbandingan Layanan Pengiriman (Polimorfisme) ===');
  for (final layanan in daftarLayanan) {
    print(layanan.ringkasan());
  }

  // Polimorfisme pada sorting berdasarkan tarif
  daftarLayanan.sort((a, b) => a.hitungTarif().compareTo(b.hitungTarif()));
  print('\nLayanan termurah : ${daftarLayanan.first.kodeLayanan}');
  print(
    'Layanan tercepat : '
    '${daftarLayanan.reduce((a, b) => a.estimasiHari() <= b.estimasiHari() ? a : b).kodeLayanan}',
  );

  // Pemanfaatan mixin Terlacak
  final truk = daftarLayanan.whereType<PengirimanTruk>().first;
  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');
  print('\nRiwayat posisi ${truk.kodeLayanan}:');
  for (final r in truk.riwayat) {
    print('  $r');
  }
  print('Posisi terakhir: ${truk.posisiTerakhir()}');

  // Pemanfaatan mixin Terasuransi (Tugas Praktikum F)
  print('\n=== Pengujian Mixin Terasuransi ===');
  const double nilaiBarang = 50000000; // Rp 50.000.000

  final kapal = daftarLayanan.whereType<PengirimanKapal>().first;
  print(
    'Premi asuransi ${kapal.kodeLayanan} (nilai Rp${nilaiBarang.toStringAsFixed(0)}): '
    'Rp${kapal.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  final udara = daftarLayanan.whereType<PengirimanUdara>().first;
  print(
    'Premi asuransi ${udara.kodeLayanan} (nilai Rp${nilaiBarang.toStringAsFixed(0)}): '
    'Rp${udara.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  // Pembuktian PengirimanTruk tidak memiliki mixin Terasuransi
  print('\nVerifikasi mixin Terasuransi:');
  print('Apakah PengirimanKapal bertipe Terasuransi? ${(kapal as LayananPengiriman) is Terasuransi}');
  print('Apakah PengirimanUdara bertipe Terasuransi? ${(udara as LayananPengiriman) is Terasuransi}');
  print('Apakah PengirimanTruk bertipe Terasuransi? ${(truk as LayananPengiriman) is Terasuransi}');
}
