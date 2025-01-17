import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/repositories/coa/coa_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/master_coa_screen.dart';

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
  final _joinDateController = TextEditingController();
  final _jenisRekController = TextEditingController();
  final _bpjsKetController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bonusController = TextEditingController();
  final _targetController = TextEditingController();
  String? _flagDk;
  String? _flagTm;
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
      _kodeRekController.text = widget.coa!.acId ?? '';
      _nameController.text = widget.coa!.namaRekening ?? '';
      _jenisRekController.text = widget.coa!.jenisRek ?? '';
      _flagDk = widget.coa!.flagDk ?? '';
      _flagTm = widget.coa!.flagTm ?? '';
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
            MaterialPageRoute(builder: (context) => MasterCoaScreen()),
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
            MaterialPageRoute(builder: (context) => MasterCoaScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Coa",
            style: TextStyle(color: Colors.white),
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
                                    builder: (context) => MasterCoaScreen()),
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  Widget buildDropdownField(
      String label, List<CoaDAO> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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

  Widget buildDropdownFieldJK(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
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
