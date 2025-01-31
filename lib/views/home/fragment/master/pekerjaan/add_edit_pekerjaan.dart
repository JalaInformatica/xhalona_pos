import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/pekerjaan.dart';
import 'package:xhalona_pos/repositories/pekerjaan/pekerjaan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/pekerjaan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/master_pekerjaan_screen.dart';

// ignore: must_be_immutable
class AddEditPekerjaan extends StatefulWidget {
  PekerjaanDAO? pekerjaan;
  AddEditPekerjaan({super.key, this.pekerjaan});

  @override
  _AddEditPekerjaanState createState() => _AddEditPekerjaanState();
}

class _AddEditPekerjaanState extends State<AddEditPekerjaan> {
  PekerjaanRepository _pekerjaanRepository = PekerjaanRepository();
  final PekerjaanController controller = Get.put(PekerjaanController());

  final _formKey = GlobalKey<FormState>();
  final _kdPekerjaanController = TextEditingController();
  final _namePekerjaanController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.pekerjaan != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _kdPekerjaanController.text = widget.pekerjaan!.jobId ?? '';
      _namePekerjaanController.text = widget.pekerjaan!.jobDesc ?? '';
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditPekerjaan() async {
      if (_formKey.currentState!.validate()) {
        String result = await _pekerjaanRepository.addEditPekerjaan(
            jobId: _kdPekerjaanController.text,
            jobDesc: _namePekerjaanController.text,
            actionId: widget.pekerjaan == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterPekerjaanScreen()),
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
            MaterialPageRoute(builder: (context) => MasterPekerjaanScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Pekerjaan",
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
                      // Field NIK
                      buildTextField("Kode Pekerjaant",
                          "Masukkan nama Pekerjaan", _kdPekerjaanController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Nama Pekerjaan",
                          "Masukkan nama Pekerjaan", _namePekerjaanController),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditPekerjaan, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MasterPekerjaanScreen()),
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

  Widget masterButton(VoidCallback onTap, String label, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor, // Background color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(label,
                style: AppTextStyle.textTitleStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 16,
            margin: EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
          ),
        );
      },
    );
  }
}
