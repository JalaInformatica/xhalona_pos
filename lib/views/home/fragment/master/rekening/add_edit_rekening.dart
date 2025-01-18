import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/rekening.dart';
import 'package:xhalona_pos/repositories/rekening/rekening_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/rekening_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/master_rekening_screen.dart';

// ignore: must_be_immutable
class AddEditRekening extends StatefulWidget {
  RekeningDAO? rekening;
  AddEditRekening({super.key, this.rekening});

  @override
  _AddEditRekeningState createState() => _AddEditRekeningState();
}

class _AddEditRekeningState extends State<AddEditRekening> {
  RekeningRepository _rekeningRepository = RekeningRepository();
  final RekeningController controller = Get.put(RekeningController());

  final _formKey = GlobalKey<FormState>();
  final _kdRekeningController = TextEditingController();
  final _nameRekeningController = TextEditingController();
  final _noRekeningController = TextEditingController();
  final _nameBankController = TextEditingController();
  final _atasNamaController = TextEditingController();
  final _coaController = TextEditingController();
  final _groupController = TextEditingController();
  final _userAccesController = TextEditingController();
  String? _jenisAc;
  bool _isLoading = true;
  bool _isActive = true;

  final List<String> jenisAc = ['K', 'B'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.rekening != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _kdRekeningController.text = widget.rekening!.acId ?? '';
      _nameRekeningController.text = widget.rekening!.namaAc ?? '';
      _noRekeningController.text = widget.rekening!.acNoReff ?? '';
      _nameBankController.text = widget.rekening!.bankName ?? '';
      _atasNamaController.text = widget.rekening!.bankAcName ?? '';
      _coaController.text = widget.rekening!.acGL ?? '';
      _groupController.text = widget.rekening!.acGroupId ?? '';
      _userAccesController.text = widget.rekening!.accesToUserId ?? '';
      _isActive = widget.rekening!.isActive == '1' ? true : false;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditRekening() async {
      if (_formKey.currentState!.validate()) {
        String result = await _rekeningRepository.addEditKaryawan(
            acId: _kdRekeningController.text,
            namaAc: _nameRekeningController.text,
            acNoReff: _noRekeningController.text,
            bankAcName: _atasNamaController.text,
            bankName: _nameBankController.text,
            acGL: _coaController.text,
            acGroupId: _groupController.text,
            acsUserId: _userAccesController.text,
            jenisAc: _jenisAc,
            actionId: widget.rekening == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterRekeningScreen()),
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
            MaterialPageRoute(builder: (context) => MasterRekeningScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Rekening",
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
                      buildDropdownFieldJK("Jenis Rek.", jenisAc, (value) {
                        setState(() {
                          _jenisAc = value;
                        });
                      }),
                      SizedBox(height: 16),
                      // Field NIK
                      buildTextField("Kode Rekening", "Masukkan nama Rekening",
                          _kdRekeningController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Nama Rekening", "Masukkan nama Rekening",
                          _nameRekeningController),
                      SizedBox(height: 16),

                      buildTextField("No Rekening", "Masukkan no Rekening",
                          _noRekeningController),
                      SizedBox(height: 16),

                      buildTextField("Nama Bank", "Masukkan nama Bank",
                          _nameBankController),
                      SizedBox(height: 16),

                      buildTextField("Atas Nama", "Masukkan atas nama",
                          _atasNamaController),
                      SizedBox(height: 16),

                      buildTextField("COA ", "Masukkan coa", _coaController),
                      SizedBox(height: 16),

                      buildTextField(
                          "Group", "Masukkan group", _groupController),
                      SizedBox(height: 16),

                      buildTextField("User Access", "Masukkan user access",
                          _userAccesController),
                      SizedBox(height: 16),

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
                              handleAddEditRekening, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MasterRekeningScreen()),
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
