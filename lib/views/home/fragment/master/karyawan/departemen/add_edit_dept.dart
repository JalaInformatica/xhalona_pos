import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/departemen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/departemen/depertemen_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/departemen/departemen_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/departemen/master_departemen_screen.dart';

// ignore: must_be_immutable
class AddEditDept extends StatefulWidget {
  DepartemenDAO? dept;
  AddEditDept({super.key, this.dept});

  @override
  _AddEditDeptState createState() => _AddEditDeptState();
}

class _AddEditDeptState extends State<AddEditDept> {
  DepartemenRepository _deptRepository = DepartemenRepository();
  final DepartemenController controller = Get.put(DepartemenController());

  final _formKey = GlobalKey<FormState>();
  final _kdDeptController = TextEditingController();
  final _nameDeptController = TextEditingController();
  bool _isLoading = true;

  final List<String> genders = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.dept != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _kdDeptController.text = widget.dept!.kdDept;
      _nameDeptController.text = widget.dept!.namaDept;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditDept() async {
      if (_formKey.currentState!.validate()) {
        String result = await _deptRepository.addEditDepartemen(
            kdDept: _kdDeptController.text,
            nmDept: _nameDeptController.text,
            actionId: widget.dept == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterDepartemenScreen()),
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
            MaterialPageRoute(builder: (context) => MasterDepartemenScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Departement",
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
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey.shade600,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _kdDeptController.text,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Nama Departement",
                          "Masukkan nama departement", _nameDeptController),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(handleAddEditDept, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MasterDepartemenScreen()),
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
