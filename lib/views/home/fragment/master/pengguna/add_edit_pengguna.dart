import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/pengguna.dart';
import 'package:xhalona_pos/models/response/departemen.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/pengguna/pengguna_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/pengguna/pengguna_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/departemen/departemen_controller.dart';

// ignore: must_be_immutable
class AddEditPengguna extends StatefulWidget {
  PenggunaDAO? pengguna;
  AddEditPengguna({super.key, this.pengguna});

  @override
  _AddEditPenggunaState createState() => _AddEditPenggunaState();
}

class _AddEditPenggunaState extends State<AddEditPengguna> {
  PenggunaRepository _penggunaRepository = PenggunaRepository();
  final PenggunaController controller = Get.put(PenggunaController());
  final DepartemenController controllerDept = Get.put(DepartemenController());

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _levelController = TextEditingController();
  bool _isLoading = true;
  bool _isActive = true;
  bool isScurePass = true;
  String? _role;
  String? _level;
  String? _department;

  Widget tooglePass() {
    return IconButton(
      onPressed: () {
        setState(() {
          isScurePass = !isScurePass;
        });
      },
      icon: isScurePass
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  final List<String> role = ['Admin', 'Finance', 'Kasir', 'Owner'];
  final List<Map<String, dynamic>> level = [
    {'id': '1', 'label': 'Admin'},
    {'id': '2', 'label': 'Finance'},
    {'id': '3', 'label': 'Kasir'},
    {'id': '4', 'label': 'Owner'},
  ];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.pengguna != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _usernameController.text = widget.pengguna!.userName;
      _departmentController.text = widget.pengguna!.deptId!;
      _emailController.text = widget.pengguna!.emailAddress;
      _levelController.text = widget.pengguna!.levelId.toString();
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditPengguna() async {
      if (_formKey.currentState!.validate()) {
        String result = await _penggunaRepository.addEditPengguna(
            memberId: _usernameController.text,
            deptId: _departmentController.text,
            password: _passController.text,
            levelId: _level,
            email: _emailController.text,
            roleId: _role,
            isActive: _isActive == true ? "1" : "0",
            actionId: widget.pengguna == null ? '0' : '1');

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
            "Tambah/Edit Data Pengguna",
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
                        textEditingController: _usernameController,
                        validator: (value) {
                          if (value == '') {
                            return "Username harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Username",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: AppTypeahead<DepartemenDAO>(
                                label: "Bagian",
                                controller: _departmentController,
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _department = selectedPartId ?? "";
                                    _departmentController.text =
                                        selectedPartId ?? "";
                                    controller.fetchProducts();
                                  });
                                },
                                updateFilterValue: (newValue) async {
                                  await controllerDept
                                      .updateTypeValue(newValue);
                                  return controllerDept.departemenHeader;
                                },
                                displayText: (akun) => akun.namaDept,
                                getId: (akun) => akun.kdDept,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _departmentController.text !=
                                          _department) {}
                                }),
                          )),
                      SizedBox(height: 16),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _passController,
                        suffixIcon: tooglePass(),
                        isScurePass: isScurePass,
                        validator: (value) {
                          if (value == '') {
                            return "Password harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Password",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: AppTypeahead<Map<String, dynamic>>(
                            label: "Level",
                            controller: _levelController,
                            onSelected: (selectedItem) {
                              setState(() {
                                _level = selectedItem ?? "";
                                _levelController.text = selectedItem ?? "";
                                controller.fetchProducts();
                              });
                            },
                            updateFilterValue: (newValue) async {
                              return level
                                  .where((item) => item['label']
                                      .toLowerCase()
                                      .contains(newValue.toLowerCase()))
                                  .toList();
                            },
                            displayText: (item) => item['label'],
                            getId: (item) => item['id'],
                            onClear: (forceClear) {
                              if (forceClear ||
                                  _levelController.text != _level) {
                                setState(() {
                                  _level = "";
                                  _levelController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _emailController,
                        validator: (value) {
                          if (value == '') {
                            return "Email harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Email",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      buildDropdownFieldJK("Role User", role, (value) {
                        setState(() {
                          _role = value;
                        });
                      }),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Status Aktif"),
                        subtitle: Text(
                            "Tentukan apakah member saat ini aktif atau tidak aktif"),
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
                              handleAddEditPengguna, "Simpan", Icons.add),
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

  Widget buildDropdownField(String label, List<DepartemenDAO> items,
      ValueChanged<String?> onChanged) {
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

  Widget buildDropdownFieldLevel(
    String label,
    List<Map<String, dynamic>> items,
    ValueChanged<String?> onChanged,
  ) {
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
      items: items.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item['id'].toString(), // Pastikan id diubah menjadi String
          child: Text(
              item['label'].toString()), // Pastikan label diubah menjadi String
        );
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
