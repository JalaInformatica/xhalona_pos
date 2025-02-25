import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/coa/coa_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';

// ignore: must_be_immutable
class AddEditCoa extends StatefulWidget {
  CoaDAO? coa;
  AddEditCoa({super.key, this.coa});

  @override
  _AddEditCoaState createState() => _AddEditCoaState();
}

class _AddEditCoaState extends State<AddEditCoa> {
  CoaRepository _coaRepository = CoaRepository();
  final CoaController controllerKar = Get.put(CoaController());

  final _formKey = GlobalKey<FormState>();
  final _kodeRekController = TextEditingController();
  final _nameController = TextEditingController();
  final _jenisRekController = TextEditingController();
  String? _flagDk;
  String? _flagTm;
  // ignore: unused_field
  String? _coa;
  bool _isActive = true; // Status Aktif/Non-Aktif
  bool _isLoading = true;

  final List<String> flagDks = ['D', 'K'];
  final List<String> flagTm = ['T', 'M'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.coa != null) {
      // Inisialisasi data dari coa jika tersedia
      _kodeRekController.text = widget.coa!.acId;
      _nameController.text = widget.coa!.namaRekening;
      _jenisRekController.text = widget.coa!.jenisRek;
      _flagDk = widget.coa!.flagDk;
      _flagTm = widget.coa!.flagTm;
      _isActive = widget.coa!.isActive == 1 ? true : false;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<CoaDAO> coa = controllerKar.coaHeader;

    void handleAddEditCoa() async {
      if (_formKey.currentState!.validate()) {
        String result = await _coaRepository.addEditCoa(
          pAccId: '',
          accId: _kodeRekController.text,
          namaRek: _nameController.text,
          jenisRek: _jenisRekController.text,
          flagDk: _flagDk,
          flagTm: _flagTm,
          isActive: _isActive ? "1" : "0",
          actionId: widget.coa == null ? "0" : "1",
        );

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
          controllerKar.fetchProducts();
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
            "Tambah/Edit Data Coa",
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
                      buildDropdownField("Parrent Account", coa, (value) {
                        setState(() {
                          _coa = value;
                        });
                      }),
                      SizedBox(height: 16),
                      buildTextField("Kode Rekening", "Masukkan kode rek",
                          _kodeRekController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Nama Rekening", "Masukkan nama rek",
                          _nameController),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
                      buildTextField("Jenis Rekening",
                          "Masukkan Jenis Rekening", _jenisRekController),
                      SizedBox(height: 16),

                      // Field BPJS Ketenagakerjaan
                      buildDropdownFieldJK("D/K", flagDks, (value) {
                        setState(() {
                          _flagDk = value;
                        });
                      }),
                      SizedBox(height: 16),

                      buildDropdownFieldJK("TM", flagTm, (value) {
                        setState(() {
                          _flagTm = value;
                        });
                      }),
                      SizedBox(height: 16),
                      // Field Aktif/Non-Aktif
                      SwitchListTile(
                        title: Text("Status Aktif"),
                        subtitle: Text(
                            "Tentukan apakah coa saat ini aktif atau tidak aktif"),
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
                          masterButton(handleAddEditCoa, "Simpan", Icons.add),
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

  Widget buildDropdownField(
      String label, List<CoaDAO> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColor.primaryColor),
        hintStyle: TextStyle(color: AppColor.primaryColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
            value: item.acId, child: Text(item.namaRekening));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
