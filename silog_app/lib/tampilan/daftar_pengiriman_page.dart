import 'package:flutter/material.dart';

import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import '../widget/ringkasan_pengiriman.dart';
import 'detail_pengiriman_page.dart';

class DaftarPengirimanPage extends StatelessWidget {
  const DaftarPengirimanPage({super.key});

  Widget _buildList(BuildContext context, List<Pengiriman> items) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Tidak ada pengiriman', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return KartuPengiriman(
          pengiriman: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPengirimanPage(pengiriman: item),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalNilai = dataPengiriman.fold<double>(
      0,
      (sum, item) => sum + item.nilaiBarang,
    );

    final dalamPerjalanan = dataPengiriman
        .where((p) => p.status == 'Dalam Perjalanan')
        .toList();

    final diterima = dataPengiriman
        .where((p) => p.status == 'Diterima')
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengiriman'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Cari resi',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Dalam Perjalanan'),
              Tab(text: 'Diterima'),
            ],
          ),
        ),
        body: Column(
          children: [
            RingkasanPengiriman(
              totalPengiriman: dataPengiriman.length,
              totalNilai: totalNilai,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(context, dataPengiriman),
                  _buildList(context, dalamPerjalanan),
                  _buildList(context, diterima),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Pengiriman Baru'),
        ),
      ),
    );
  }
}
