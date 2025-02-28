import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/rekening.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/rekening/rekening_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/rekening_controller.dart';

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
  final CoaController controllerKus = Get.put(CoaController());

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
  String? _kasbankdetail;
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
          automaticallyImplyLeading: false,
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
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _kdRekeningController,
                              validator: (value) {
                                if (value == '') {
                                  return "Kode Rekening harus diisi!";
                                }
                                return null;
                              },
                              labelText: "Kode Rekening",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(width: 16),

                          // Field BPJS Ketenagakerjaan
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _noRekeningController,
                              validator: (value) {
                                if (value == '') {
                                  return "No Rekening harus diisi!";
                                }
                                return null;
                              },
                              labelText: "No Rekening",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _nameRekeningController,
                        validator: (value) {
                          if (value == '') {
                            return "Nama Rekening harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Nama Rekening",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _nameBankController,
                              validator: (value) {
                                if (value == '') {
                                  return "Nama Bank harus diisi!";
                                }
                                return null;
                              },
                              labelText: "Nama Bank",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(width: 16),

                          // Field BPJS Ketenagakerjaan
                          Expanded(
                            child: AppTextFormField(
                              context: context,
                              textEditingController: _atasNamaController,
                              validator: (value) {
                                if (value == '') {
                                  return "Atas Nama harus diisi!";
                                }
                                return null;
                              },
                              labelText: "Atas Nama",
                              inputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _nameRekeningController,
                        validator: (value) {
                          if (value == '') {
                            return "Nama Rekening harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Nama Rekening",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: AppTypeahead<CoaDAO>(
                                label: "COA ",
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _kasbankdetail = selectedPartId ?? "";
                                    _coaController.text = selectedPartId ?? "";
                                    controllerKus.fetchProducts();
                                  });
                                },
                                controller: _coaController,
                                updateFilterValue: (newValue) async {
                                  await controllerKus.updateTypeValue(newValue);
                                  return controllerKus.coaHeader;
                                },
                                displayText: (akun) => akun.namaRekening,
                                getId: (akun) => akun.acId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _coaController.text != _kasbankdetail) {}
                                }),
                          )),

                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _groupController,
                        validator: (value) {
                          if (value == '') {
                            return "Group harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Group",
                        inputAction: TextInputAction.next,
                      ),

                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _userAccesController,
                        validator: (value) {
                          if (value == '') {
                            return "User Access harus diisi!";
                          }
                          return null;
                        },
                        labelText: "User Access",
                        inputAction: TextInputAction.next,
                      ),

                      SizedBox(height: 5),

                      SwitchListTile(
                        title: Text("Status Aktif"),
                        subtitle: Text(
                            "Tentukan apakah rekening saat ini aktif atau tidak aktif"),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      SizedBox(height: 15),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditRekening, "Simpan", Icons.add),
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
