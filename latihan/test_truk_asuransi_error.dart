
import '../lib/layanan/layanan_pengiriman.dart';
import '../lib/layanan/moda.dart';

void main() {
  final truk = PengirimanTruk(kodeLayanan: 'TRK-01', jarakKm: 100, beratKg: 50);
  truk.hitungPremi(5000000);
}
