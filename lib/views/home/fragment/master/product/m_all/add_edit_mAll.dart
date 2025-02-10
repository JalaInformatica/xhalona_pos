import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/masterall.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
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
}
