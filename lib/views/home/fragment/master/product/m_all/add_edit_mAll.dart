import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/masterall.dart';
import 'package:xhalona_pos/repositories/m_all/mAll_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/mAll_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/master_mAll_screen.dart';

// ignore: must_be_immutable
class AddEditMasAll extends StatefulWidget {
  MasAllDAO? pekerjaan;
  AddEditMasAll({super.key, this.pekerjaan});

  @override
  _AddEditMasAllState createState() => _AddEditMasAllState();
}

class _AddEditMasAllState extends State<AddEditMasAll> {
  MasAllRepository _pekerjaanRepository = MasAllRepository();
  final MasAllController controller = Get.put(MasAllController());
  final EmployeeModalController controllerEm =
      Get.put(EmployeeModalController());

  final _formKey = GlobalKey<FormState>();
  final _kdMasAllController = TextEditingController();
  final _nameMasAllController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.pekerjaan != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _kdMasAllController.text = widget.pekerjaan!.masterId ?? '';
      _nameMasAllController.text = widget.pekerjaan!.masCategory ?? '';
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditMasAll() async {
      if (_formKey.currentState!.validate()) {
        String result = await _pekerjaanRepository.addEditMasAll(
            rowId: widget.pekerjaan?.rowId,
            masId: _kdMasAllController.text,
            masCategory: _nameMasAllController.text,
            actionId: widget.pekerjaan == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterMasAllScreen()),
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
            MaterialPageRoute(builder: (context) => MasterMasAllScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Master All",
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

                      buildTextField("Keterangan", "Masukkan keterangan",
                          _kdMasAllController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Kategori", "Masukkan kategori",
                          _nameMasAllController),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditMasAll, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MasterMasAllScreen()),
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

  Widget masterButton(VoidCallback onPressed, String label, IconData icon) {
    return GestureDetector(
      onTap: onPressed,
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
