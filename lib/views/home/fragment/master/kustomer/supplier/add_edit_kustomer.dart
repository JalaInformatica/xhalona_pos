import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';

// ignore: must_be_immutable
class AddEditKustomer extends StatefulWidget {
  KustomerDAO? kustomer;
  String? islabel;
  String? isSuplier;
  AddEditKustomer({super.key, this.kustomer, this.islabel, this.isSuplier});

  @override
  _AddEditKustomerState createState() => _AddEditKustomerState();
}

class _AddEditKustomerState extends State<AddEditKustomer> {
  KustomerRepository _kustomerRepository = KustomerRepository();
  final KustomerController controller = Get.put(KustomerController());

  final _formKey = GlobalKey<FormState>();
  final _kdKustomerController = TextEditingController();
  final _nameKustomerController = TextEditingController();
  final _telpKustomerController = TextEditingController();
  final _emailKustomerController = TextEditingController();
  final _address1KustomerController = TextEditingController();
  final _address2KustomerController = TextEditingController();
  bool _isLoading = true;

  final List<String> genders = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.kustomer != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _kdKustomerController.text = widget.kustomer!.suplierId;
      _nameKustomerController.text = widget.kustomer!.suplierName;
      _telpKustomerController.text = widget.kustomer!.telp;
      _emailKustomerController.text = widget.kustomer!.emailAdress;
      _address1KustomerController.text = widget.kustomer!.address1;
      _address2KustomerController.text = widget.kustomer!.address2;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditKustomer() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kustomerRepository.addEditKustomer(
            suplierId: _kdKustomerController.text,
            suplierName: _nameKustomerController.text,
            telp: _telpKustomerController.text,
            emailAdress: _emailKustomerController.text,
            adress1: _address1KustomerController.text,
            adress2: _address2KustomerController.text,
            isSuplier: widget.isSuplier,
            actionId: widget.kustomer == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
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
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data ${widget.islabel}",
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
                      buildTextField(
                          "Kode ${widget.islabel}",
                          "Masukkan kode ${widget.islabel}",
                          _kdKustomerController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField(
                          "Nama ${widget.islabel}",
                          "Masukkan nama ${widget.islabel}",
                          _nameKustomerController),
                      SizedBox(height: 16),

                      buildTextField(
                          "Telp ", "Masukkan Telp ", _telpKustomerController),
                      SizedBox(height: 16),
                      buildTextField("Email ", "Masukkan Email ",
                          _emailKustomerController),
                      SizedBox(height: 16),

                      buildTextField("Alamat ", "Masukkan Alamat ",
                          _address1KustomerController),
                      SizedBox(height: 16),

                      buildTextField("Alamat lain", "Masukkan Alamat ",
                          _address2KustomerController),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditKustomer, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
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
