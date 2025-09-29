import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/models/response/karyawan.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/models/response/departemen.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/globals/karyawan/karyawan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
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
  final _departmentController = TextEditingController();
  String? _gender;
  String? _department;
  bool _isActive = true; // Status Aktif/Non-Aktif
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.karyawan != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _nikController.text = widget.karyawan!.empId;
      _nameController.text = widget.karyawan!.fullName;
      _departmentController.text = widget.karyawan!.kd_dept!;
      _joinDateController.text = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(widget.karyawan!.dateIn));
      _bpjsKesController.text = widget.karyawan!.bpjsNo;
      _bpjsKetController.text = widget.karyawan!.bpjsTk!;
      _birthDateController.text = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(widget.karyawan!.birthDate!));
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
    void handleAddEditKaryawan() async {
      if (_formKey.currentState!.validate()) {
        String result = await _karyawanRepository.addEditKaryawan(
          empId: _nikController.text,
          fullName: _nameController.text,
          dateIn: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd-MM-yyyy').parse(_joinDateController.text)),
          bpjsNo: _bpjsKesController.text,
          bpjsTk: _bpjsKetController.text,
          birthDate: DateFormat('yyyy-MM-dd').format(
              DateFormat('dd-MM-yyyy').parse(_birthDateController.text)),
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
            MaterialPageRoute(builder: (context) => HomePage()),
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
            MaterialPageRoute(builder: (context) => HomePage()),
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
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _nikController,
                              validator: (value) {
                                if (value == '') {
                                  return "NIK harus diisi!";
                                }
                                return null;
                              },
                              labelText: "NIK",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(width: 16),

                          // Field Nama
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _nameController,
                              validator: (value) {
                                if (value == '') {
                                  return "Nama harus diisi!";
                                }
                                return null;
                              },
                              labelText: "Nama",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Field Tanggal Masuk
                      AppTextFormField(
                        context: context,
                        textEditingController: _joinDateController,
                        readOnly: true,
                        suffixIcon: Icon(Icons.calendar_today),
                        onTap: () {
                          SmartDialog.show(builder: (context) {
                            return AppDialog(
                                content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppCalendar(
                                            focusedDay: _joinDateController
                                                    .text.isNotEmpty
                                                ? DateFormat("dd-MM-yyyy")
                                                    .parse(_joinDateController
                                                        .text)
                                                : DateTime.now(),
                                            onDaySelected: (selectedDay, _) {
                                              setState(() {
                                                _joinDateController.text =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDay);
                                                SmartDialog.dismiss();
                                              });
                                            },
                                          ),
                                        ])));
                          });
                        },
                        labelText: "Tanggal Masuk",
                        style: AppTextStyle.textBodyStyle(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal Masuk tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _bpjsKesController,
                              validator: (value) {
                                if (value == '') {
                                  return "BPJS Kesehatan harus diisi!";
                                }
                                return null;
                              },
                              labelText: "BPJS Kesehatan",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(width: 16),

                          // Field BPJS Ketenagakerjaan
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _bpjsKetController,
                              validator: (value) {
                                if (value == '') {
                                  return "BPJS Ketenagakerjaan harus diisi!";
                                }
                                return null;
                              },
                              labelText: "BPJS Ketenagakerjaan",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Field Jenis Kelamin
                      Text(
                        'Jenis Kelamin',
                        style: AppTextStyle.textBodyStyle(),
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                                  title: Text('Laki-Laki',
                                      style: AppTextStyle.textBodyStyle()),
                                  value: 'Laki-Laki',
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value.toString();
                                    });
                                  })),
                          Expanded(
                              child: RadioListTile(
                                  title: Text('Perempuan',
                                      style: AppTextStyle.textBodyStyle()),
                                  value: 'Perempuan',
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value.toString();
                                    });
                                  })),
                        ],
                      ),
                      SizedBox(height: 5),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _birthPlaceController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tempat Lahir harus diisi!";
                                }
                                return null;
                              },
                              labelText: "Tempat Lahir",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _birthDateController,
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today),
                              onTap: () {
                                SmartDialog.show(builder: (context) {
                                  return AppDialog(
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppCalendar(
                                            focusedDay: _birthDateController
                                                    .text.isNotEmpty
                                                ? DateFormat("dd-MM-yyyy")
                                                    .parse(_birthDateController
                                                        .text)
                                                : DateTime.now(),
                                            onDaySelected: (selectedDay, _) {
                                              setState(() {
                                                _birthDateController.text =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDay);
                                                SmartDialog.dismiss();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                              labelText: "Tanggal Lahir",
                              style: AppTextStyle.textBodyStyle(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tanggal Lahir tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          // Spasi antar field
                        ],
                      ),

                      SizedBox(height: 16),

                      // Field Alamat
                      AppTextFormField(
                        context: context,
                        textEditingController: _addressController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == '') {
                            return "Alamat harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Alamat",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      // Field Bagian
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
                                  await controller.updateTypeValue(newValue);
                                  return controller.departemenHeader;
                                },
                                displayText: (akun) => akun.namaDept,
                                getId: (akun) => akun.kdDept,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _departmentController.text !=
                                          _department) {}
                                }),
                          )),
                      SizedBox(height: 5),

                      // Field Bonus
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                                context: context,
                                textEditingController: _bonusController,
                                validator: (value) {
                                  if (value == '') {
                                    return "Bonus harus diisi!";
                                  }
                                  return null;
                                },
                                labelText: "Bonus",
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.number),
                          ),
                          SizedBox(width: 16),

                          // Field Target
                          Expanded(
                            child: AppTextFormField(
                                context: context,
                                textEditingController: _targetController,
                                validator: (value) {
                                  if (value == '') {
                                    return "Target harus diisi!";
                                  }
                                  return null;
                                },
                                labelText: "Target",
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.number),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),

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

  Widget buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColor.primaryColor),
        suffixIcon: Icon(Icons.calendar_today),
        suffixIconColor: AppColor.primaryColor,
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
}
