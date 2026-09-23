double totalBerat(List<Map<String, Object>> kiriman) {
  double total = 0;

  for (final item in kiriman) {
    total += item['berat'] as double;
  }

  return total;
}

double rataRataBerat(List<Map<String, Object>> kiriman) {
  if (kiriman.isEmpty) {
    return 0;
  }

  return totalBerat(kiriman) / kiriman.length;
}

Map<String, Object> cariTerberat(List<Map<String, Object>> kiriman) {
  Map<String, Object> terberat = kiriman.first;

  for (final item in kiriman) {
    final beratItem = item['berat'] as double;
    final beratTerberat = terberat['berat'] as double;

    if (beratItem > beratTerberat) {
      terberat = item;
    }
  }

  return terberat;
}

Map<String, Object> cariTeringan(List<Map<String, Object>> kiriman) {
  Map<String, Object> teringan = kiriman.first;

  for (final item in kiriman) {
    final beratItem = item['berat'] as double;
    final beratTeringan = teringan['berat'] as double;

    if (beratItem < beratTeringan) {
      teringan = item;
    }
  }

  return teringan;
}

Map<String, int> hitungKategori(List<Map<String, Object>> kiriman) {
  int paketKecil = 0;
  int paketSedang = 0;
  int kargo = 0;

  for (final item in kiriman) {
    final berat = item['berat'] as double;

    if (berat <= 5) {
      paketKecil++;
    } else if (berat <= 20) {
      paketSedang++;
    } else {
      kargo++;
    }
  }

  return {
    'Paket Kecil': paketKecil,
    'Paket Sedang': paketSedang,
    'Kargo': kargo,
  };
}

void main() {
  final List<Map<String, Object>> kiriman = [
    {'resi': 'SLG-001', 'kota': 'Bandung', 'berat': 3.0},
    {'resi': 'SLG-002', 'kota': 'Surabaya', 'berat': 12.5},
    {'resi': 'SLG-003', 'kota': 'Makassar', 'berat': 7.2},
    {'resi': 'SLG-004', 'kota': 'Surabaya', 'berat': 4.8},
    {'resi': 'SLG-005', 'kota': 'Jayapura', 'berat': 18.0},
    {'resi': 'SLG-006', 'kota': 'Bandung', 'berat': 6.5},
    {'resi': 'SLG-007', 'kota': 'Makassar', 'berat': 10.0},
    {'resi': 'SLG-008', 'kota': 'Surabaya', 'berat': 2.5},
  ];

  final total = totalBerat(kiriman);
  final rataRata = rataRataBerat(kiriman);
  final terberat = cariTerberat(kiriman);
  final teringan = cariTeringan(kiriman);
  final kategori = hitungKategori(kiriman);

  print(' ANALISIS KIRIMAN ');
  print('Jumlah kiriman : ${kiriman.length}');
  print('Total berat    : ${total.toStringAsFixed(2)} kg');
  print('Rata-rata berat: ${rataRata.toStringAsFixed(2)} kg');

  print(
    'Kiriman terberat: '
    '${terberat['resi']} - '
    '${terberat['berat']} kg',
  );

  print(
    'Kiriman teringan: '
    '${teringan['resi']} - '
    '${teringan['berat']} kg',
  );

  print('\nJumlah berdasarkan kategori:');
  print('Paket Kecil  : ${kategori['Paket Kecil']}');
  print('Paket Sedang : ${kategori['Paket Sedang']}');
  print('Kargo        : ${kategori['Kargo']}');
}
