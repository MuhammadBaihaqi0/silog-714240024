import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silog_app/main.dart';
import 'package:silog_app/tampilan/daftar_pengiriman_page.dart';
import 'package:silog_app/tampilan/detail_pengiriman_page.dart';
import 'package:silog_app/widget/kartu_pengiriman.dart';
import 'package:silog_app/widget/ringkasan_pengiriman.dart';

void main() {
  testWidgets('SiLogApp memuat DaftarPengirimanPage dan komponen utamanya', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SiLogApp());

    // Verifikasi judul pada AppBar
    expect(find.text('Daftar Pengiriman'), findsOneWidget);

    // Verifikasi TabBar dengan 3 tab
    expect(find.widgetWithText(Tab, 'Semua'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Dalam Perjalanan'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Diterima'), findsOneWidget);

    // Verifikasi Ringkasan Pengiriman
    expect(find.byType(RingkasanPengiriman), findsOneWidget);
    expect(find.text('Total Pengiriman'), findsOneWidget);
    expect(find.text('3 Pengiriman'), findsOneWidget);
    expect(find.text('Total Nilai Barang'), findsOneWidget);
    expect(find.text('Rp24.325.000'), findsOneWidget);

    // Verifikasi KartuPengiriman
    expect(find.byType(KartuPengiriman), findsNWidgets(3));
    expect(find.text('SLG-2026-0001'), findsOneWidget);
    expect(find.text('SLG-2026-0002'), findsOneWidget);
    expect(find.text('SLG-2026-0003'), findsOneWidget);
  });

  testWidgets('Navigasi ke DetailPengirimanPage dan kembali berfungsi', (
    WidgetTester tester,
  ) async {
    // Beri viewport yang cukup tinggi
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SiLogApp());

    // Tap kartu pertama (SLG-2026-0001)
    await tester.tap(find.text('SLG-2026-0001'));
    await tester.pumpAndSettle();

    // Verifikasi masuk ke layar detail
    expect(find.byType(DetailPengirimanPage), findsOneWidget);
    expect(find.text('Informasi Pengiriman'), findsOneWidget);
    expect(find.text('Rincian Barang'), findsOneWidget);
    expect(find.text('Gudang Utama Bandung'), findsOneWidget);
    expect(find.text('Surabaya'), findsOneWidget);
    expect(find.text('Sepatu Lari Pria'), findsOneWidget);
    expect(find.text('10 pcs'), findsOneWidget);
    expect(find.text('Rp4500000'), findsOneWidget);

    // Tekan tombol Kembali ke Daftar pada AppBar atau tombol di body
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Verifikasi kembali ke DaftarPengirimanPage
    expect(find.byType(DaftarPengirimanPage), findsOneWidget);
    expect(find.byType(DetailPengirimanPage), findsNothing);
  });

  testWidgets('Filter TabBar (Semua, Dalam Perjalanan, Diterima) berfungsi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SiLogApp());

    // Tab Semua: 3 item
    expect(find.text('SLG-2026-0001'), findsOneWidget);
    expect(find.text('SLG-2026-0002'), findsOneWidget);
    expect(find.text('SLG-2026-0003'), findsOneWidget);

    // Pindah ke tab Dalam Perjalanan
    await tester.tap(find.widgetWithText(Tab, 'Dalam Perjalanan'));
    await tester.pumpAndSettle();

    // Hanya SLG-2026-0001 yang berstatus Dalam Perjalanan
    expect(find.text('SLG-2026-0001'), findsOneWidget);
    expect(find.text('SLG-2026-0002'), findsNothing);
    expect(find.text('SLG-2026-0003'), findsNothing);

    // Pindah ke tab Diterima
    await tester.tap(find.widgetWithText(Tab, 'Diterima'));
    await tester.pumpAndSettle();

    // Hanya SLG-2026-0003 yang berstatus Diterima
    expect(find.text('SLG-2026-0003'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsNothing);
    expect(find.text('SLG-2026-0002'), findsNothing);
  });
}
