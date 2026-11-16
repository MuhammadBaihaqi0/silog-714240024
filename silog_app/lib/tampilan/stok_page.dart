import 'package:flutter/material.dart';
import '../data/preferensi.dart';
import '../data/stok_repository.dart';
import '../model/stok.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final _repo = StokRepository.instance;
  final _pref = Preferensi();

  List<Stok> _daftar = [];
  String _gudang = 'GD-BDG';
  bool _memuat = true;

  // Tugas 2: pencarian
  final _pencarianCtrl = TextEditingController();
  bool _modeCari = false;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  @override
  void dispose() {
    _pencarianCtrl.dispose();
    super.dispose();
  }

  Future<void> _muat() async {
    setState(() => _memuat = true);
    _gudang = await _pref.ambilGudangTerakhir();
    final data = await _repo.ambilSemua(kodeGudang: _gudang);
    if (!mounted) return;
    setState(() {
      _daftar = data;
      _memuat = false;
    });
  }

  // Tugas 2: pencarian nama barang
  Future<void> _cariBarang(String kata) async {
    if (kata.isEmpty) {
      await _muat();
      return;
    }
    setState(() => _memuat = true);
    final hasil = await _repo.cari(kata, kodeGudang: _gudang);
    if (!mounted) return;
    setState(() {
      _daftar = hasil;
      _memuat = false;
    });
  }

  // Tugas 1: formulir penambahan stok dengan validasi
  Future<void> _bukaFormulirTambah() async {
    final hasil = await Navigator.push<Stok>(
      context,
      MaterialPageRoute(
        builder: (_) => FormStokPage(kodeGudang: _gudang),
      ),
    );
    if (hasil != null) {
      await _repo.simpan(hasil);
      await _muat();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${hasil.namaBarang} berhasil ditambahkan')),
      );
    }
  }

  Future<void> _ubahJumlah(Stok stok, int delta) async {
    final baru = stok.jumlah + delta;
    if (baru < 0) return;
    await _repo.perbarui(stok.salinDengan(jumlah: baru));
    await _muat();
  }

  Future<void> _hapus(Stok stok) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus data stok'),
        content: Text('Hapus ${stok.namaBarang} dari gudang $_gudang?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (ya == true && stok.id != null) {
      await _repo.hapus(stok.id!);
      await _muat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _daftar.fold<int>(0, (a, s) => a + s.jumlah);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stok Gudang $_gudang'),
        actions: [
          // Tugas 2: tombol pencarian
          IconButton(
            icon: Icon(_modeCari ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _modeCari = !_modeCari;
                if (!_modeCari) {
                  _pencarianCtrl.clear();
                  _muat();
                }
              });
            },
          ),
        ],
      ),
      body: _memuat
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tugas 2: kolom pencarian
                if (_modeCari)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: _pencarianCtrl,
                      decoration: InputDecoration(
                        hintText: 'Cari nama barang...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _pencarianCtrl.clear();
                            _muat();
                          },
                        ),
                      ),
                      onChanged: (v) => _cariBarang(v),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                      'Total stok: $total unit dari ${_daftar.length} jenis barang'),
                ),
                Expanded(
                  child: _daftar.isEmpty
                      ? const Center(child: Text('Belum ada data stok'))
                      : ListView.builder(
                          itemCount: _daftar.length,
                          itemBuilder: (context, i) {
                            final s = _daftar[i];
                            return ListTile(
                              title: Text(s.namaBarang),
                              subtitle:
                                  Text('${s.kodeBarang} - ${s.jumlah} unit'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline),
                                    onPressed: () => _ubahJumlah(s, -1),
                                  ),
                                  IconButton(
                                    icon:
                                        const Icon(Icons.add_circle_outline),
                                    onPressed: () => _ubahJumlah(s, 1),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _hapus(s),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaFormulirTambah,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Tugas 1: Formulir penambahan stok dengan validasi seperti Modul 7
class FormStokPage extends StatefulWidget {
  final String kodeGudang;
  const FormStokPage({super.key, required this.kodeGudang});

  @override
  State<FormStokPage> createState() => _FormStokPageState();
}

class _FormStokPageState extends State<FormStokPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeBarangCtrl = TextEditingController();
  final _namaBarangCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();

  @override
  void dispose() {
    _kodeBarangCtrl.dispose();
    _namaBarangCtrl.dispose();
    _jumlahCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final stok = Stok(
      kodeBarang: _kodeBarangCtrl.text.trim(),
      namaBarang: _namaBarangCtrl.text.trim(),
      kodeGudang: widget.kodeGudang,
      jumlah: int.parse(_jumlahCtrl.text.trim()),
      diperbaruiPada: DateTime.now(),
    );

    Navigator.pop(context, stok);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Stok Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _kodeBarangCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang',
                  hintText: 'Contoh: BRG-001',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Kode barang tidak boleh kosong';
                  }
                  if (v.trim().length < 3) {
                    return 'Kode barang minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaBarangCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Contoh: Laptop ASUS ROG',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nama barang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahCtrl,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  hintText: 'Contoh: 50',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  final angka = int.tryParse(v.trim());
                  if (angka == null) {
                    return 'Jumlah harus berupa angka';
                  }
                  if (angka < 0) {
                    return 'Jumlah tidak boleh negatif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Gudang: ${widget.kodeGudang}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Stok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

