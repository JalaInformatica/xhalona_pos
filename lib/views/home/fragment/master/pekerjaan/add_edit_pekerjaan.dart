import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/pekerjaan.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/pekerjaan/pekerjaan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/pekerjaan_controller.dart';

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
      _kdPekerjaanController.text = widget.pekerjaan!.jobId;
      _namePekerjaanController.text = widget.pekerjaan!.jobDesc;
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
            MaterialPageRoute(builder: (context) => HomePage()),
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
            MaterialPageRoute(builder: (context) => HomePage()),
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
                      AppTextFormField(
                        context: context,
                        textEditingController: _kdPekerjaanController,
                        validator: (value) {
                          if (value == '') {
                            return "Kode Pekerjaan harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Kode Pekerjaan",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _namePekerjaanController,
                        validator: (value) {
                          if (value == '') {
                            return "Nama Pekerjaan harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Nama Pekerjaan",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditPekerjaan, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
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
