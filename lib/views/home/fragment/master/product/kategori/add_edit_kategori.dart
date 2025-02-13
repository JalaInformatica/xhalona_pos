import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/kategori_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/kategori_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/master_kategori_screen.dart';

// ignore: must_be_immutable
class AddEditKategori extends StatefulWidget {
  KategoriDAO? kategori;
  AddEditKategori({super.key, this.kategori});

  @override
  _AddEditKategoriState createState() => _AddEditKategoriState();
}

class _AddEditKategoriState extends State<AddEditKategori> {
  KategoriRepository _kategoriRepository = KategoriRepository();
  final KategoriController controller = Get.put(KategoriController());

  final _formKey = GlobalKey<FormState>();
  final _nameKategoriController = TextEditingController();
  bool _isLoading = true;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.kategori != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _nameKategoriController.text = widget.kategori!.ketAnalisa;
      _isActive = widget.kategori!.isActive == 1 ? true : false;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditKategori() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kategoriRepository.addEditKategori(
            analisaId: widget.kategori?.analisaId,
            ketAnalisa: _nameKategoriController.text,
            isActive: _isActive ? "1" : "0",
            actionId: widget.kategori == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterKategoriScreen()),
            (route) => false,
          );
          controller.fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterKategoriScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Kategori",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
        ),
        body: _isLoading
            ? buildShimmerLoading()
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field Nama
                      buildTextField("Nama Kategori", "Masukkan nama Kategori",
                          _nameKategoriController),
                      SizedBox(height: 16),

                      // Field Aktif/Non-Aktif
                      SwitchListTile(
                        title: Text("Status Aktif"),
                        subtitle: Text(
                            "Tentukan apakah karyawan saat ini aktif atau tidak aktif"),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditKategori, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MasterKategoriScreen()),
                                (route) => false);
                          }, "Batal", Icons.refresh),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
