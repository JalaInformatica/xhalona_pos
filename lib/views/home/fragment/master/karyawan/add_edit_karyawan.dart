import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/models/dao/departemen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/karyawan/karyawan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/master_karyawan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/departemen/departemen_controller.dart';

// ignore: must_be_immutable
class AddEditKaryawan extends StatefulWidget {
  KaryawanDAO? karyawan;
  AddEditKaryawan({super.key, this.karyawan});

  @override
  _AddEditKaryawanState createState() => _AddEditKaryawanState();
}

class _AddEditKaryawanState extends State<AddEditKaryawan> {
  final DepartemenController controller = Get.put(DepartemenController());
  KaryawanRepository _karyawanRepository = KaryawanRepository();
  final KaryawanController controllerKar = Get.put(KaryawanController());

  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _joinDateController = TextEditingController();
  final _bpjsKesController = TextEditingController();
  final _bpjsKetController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bonusController = TextEditingController();
  final _targetController = TextEditingController();
  String? _gender;
  String? _department;
  bool _isActive = true; // Status Aktif/Non-Aktif
  bool _isLoading = true;

  final List<String> genders = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.karyawan != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _nikController.text = widget.karyawan!.empId;
      _nameController.text = widget.karyawan!.fullName;
      _joinDateController.text = widget.karyawan!.dateIn.split("T").first;
      _bpjsKesController.text = widget.karyawan!.bpjsNo;
      _bpjsKetController.text = widget.karyawan!.bpjsTk!;
      _birthDateController.text = widget.karyawan!.birthDate!.split("T").first;
      _birthPlaceController.text = widget.karyawan!.birthPlace!;
      _addressController.text = widget.karyawan!.alamat!;
      _bonusController.text = widget.karyawan!.bonusAmount!.toString();
      _targetController.text = widget.karyawan!.bonusTarget!.toString();
      _gender = widget.karyawan!.gender == 1 ? "Laki-laki" : "Perempuan";
      _department = widget.karyawan!.kd_dept;
      _isActive = widget.karyawan!.isActive == 1 ? true : false;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DepartemenDAO> departments = controller.departemenHeader;

    void handleAddEditKaryawan() async {
      if (_formKey.currentState!.validate()) {
        String result = await _karyawanRepository.addEditKaryawan(
          empId: _nikController.text,
          fullName: _nameController.text,
          dateIn: _joinDateController.text,
          bpjsNo: _bpjsKesController.text,
          bpjsTk: _bpjsKetController.text,
          birthDate: _birthDateController.text,
          birthPlace: _birthPlaceController.text,
          alamat: _addressController.text,
          bonusAmount: _bonusController.text,
          bonusTarget: _targetController.text,
          gender: _gender,
          kdDept: _department,
          isActive: _isActive ? "1" : "0",
          actionId: widget.karyawan == null ? "0" : "1",
        );

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterKaryawanScreen()),
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
            MaterialPageRoute(builder: (context) => MasterKaryawanScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Karyawan",
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
                          "NIK", "Masukkan NIK karyawan", _nikController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField(
                          "Nama", "Masukkan nama karyawan", _nameController),
                      SizedBox(height: 16),

                      // Field Tanggal Masuk
                      buildDateField("Tanggal Masuk", _joinDateController),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
                      buildTextField("BPJS Kesehatan",
                          "Masukkan nomor BPJS Kesehatan", _bpjsKesController),
                      SizedBox(height: 16),

                      // Field BPJS Ketenagakerjaan
                      buildTextField(
                          "BPJS Ketenagakerjaan",
                          "Masukkan nomor BPJS Ketenagakerjaan",
                          _bpjsKetController),
                      SizedBox(height: 16),

                      // Field Jenis Kelamin
                      buildDropdownFieldJK("Jenis Kelamin", genders, (value) {
                        setState(() {
                          _gender = value;
                        });
                      }),
                      SizedBox(height: 16),

                      // Field Tanggal Lahir
                      buildDateField("Tanggal Lahir", _birthDateController),
                      SizedBox(height: 16),

                      buildTextField("Tempat Lahir", "Masukkan tempat lahir",
                          _birthPlaceController),
                      SizedBox(height: 16),

                      // Field Alamat
                      buildTextField("Alamat", "Masukkan alamat karyawan",
                          _addressController),
                      SizedBox(height: 16),

                      // Field Bagian
                      buildDropdownField("Bagian", departments, (value) {
                        setState(() {
                          _department = value;
                        });
                      }),
                      SizedBox(height: 16),

                      // Field Bonus
                      buildTextField(
                          "Bonus", "Masukkan bonus karyawan", _bonusController,
                          keyboardType: TextInputType.number),
                      SizedBox(height: 16),

                      // Field Target
                      buildTextField("Target", "Masukkan target karyawan",
                          _targetController,
                          keyboardType: TextInputType.number),
                      SizedBox(height: 16),

                      // Field Aktif/Non-Aktif
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
                              handleAddEditKaryawan, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MasterKaryawanScreen()),
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

  Widget buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildDropdownField(String label, List<DepartemenDAO> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item.kdDept, child: Text(item.namaDept));
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
