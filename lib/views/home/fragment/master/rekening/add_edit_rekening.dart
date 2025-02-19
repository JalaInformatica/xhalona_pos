import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/rekening.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
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
      _kdRekeningController.text = widget.rekening!.acId;
      _nameRekeningController.text = widget.rekening!.namaAc;
      _noRekeningController.text = widget.rekening!.acNoReff!;
      _nameBankController.text = widget.rekening!.bankName!;
      _atasNamaController.text = widget.rekening!.bankAcName!;
      _coaController.text = widget.rekening!.acGL!;
      _groupController.text = widget.rekening!.acGroupId!;
      _userAccesController.text = widget.rekening!.accesToUserId!;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah/Edit Data Rekening",
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

                    buildTextField(
                        "Nama Bank", "Masukkan nama Bank", _nameBankController),
                    SizedBox(height: 16),

                    buildTextField(
                        "Atas Nama", "Masukkan atas nama", _atasNamaController),
                    SizedBox(height: 16),

                    buildTextField("COA ", "Masukkan coa", _coaController),
                    SizedBox(height: 16),

                    buildTextField("Group", "Masukkan group", _groupController),
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
                                  builder: (context) => MasterRekeningScreen()),
                              (route) => false);
                        }, "Batal", Icons.refresh),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
