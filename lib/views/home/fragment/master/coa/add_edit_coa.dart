import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
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
  final _coaController = TextEditingController();
  String? _flagDk;
  String? _flagTm;
  // ignore: unused_field
  String? _coa;
  bool _isActive = true; // Status Aktif/Non-Aktif
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.coa != null) {
      // Inisialisasi data dari coa jika tersedia
      _kodeRekController.text = widget.coa!.acId;
      _nameController.text = widget.coa!.namaRekening;
      _jenisRekController.text = widget.coa!.jenisRek;
      _coaController.text = widget.coa!.acId;
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
                      Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: AppTypeahead<CoaDAO>(
                                label: "Akun",
                                controller: _coaController,
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _coa = selectedPartId ?? "";
                                    _coaController.text = selectedPartId ?? "";
                                    controllerKar.fetchProducts();
                                  });
                                },
                                updateFilterValue: (newValue) async {
                                  await controllerKar
                                      .updateFilterValue(newValue);
                                  return controllerKar.coaHeader;
                                },
                                displayText: (akun) => akun.namaRekening,
                                getId: (akun) => akun.acId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _coaController.text != _coa) {}
                                }),
                          )),
                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _kodeRekController,
                        validator: (value) {
                          if (value == '') {
                            return "Kode Rekening harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Kode Rekening",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _nameController,
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

                      // Field BPJS Kesehatan
                      AppTextFormField(
                        context: context,
                        textEditingController: _jenisRekController,
                        validator: (value) {
                          if (value == '') {
                            return "Jenis Rekening harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Jenis Rekening",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      // Field BPJS Ketenagakerjaan
                      Text(
                        'D/K',
                        style: AppTextStyle.textBodyStyle(),
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                                  title: Text('D',
                                      style: AppTextStyle.textBodyStyle()),
                                  value: 'D',
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: _flagDk,
                                  onChanged: (value) {
                                    setState(() {
                                      _flagDk = value.toString();
                                    });
                                  })),
                          Expanded(
                              child: RadioListTile(
                                  title: Text('K',
                                      style: AppTextStyle.textBodyStyle()),
                                  value: 'K',
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: _flagDk,
                                  onChanged: (value) {
                                    setState(() {
                                      _flagDk = value.toString();
                                    });
                                  })),
                        ],
                      ),
                      SizedBox(height: 16),

                      Text(
                        'TM',
                        style: AppTextStyle.textBodyStyle(),
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                                  title: Text('T',
                                      style: AppTextStyle.textBodyStyle()),
                                  value: 'T',
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: _flagTm,
                                  onChanged: (value) {
                                    setState(() {
                                      _flagTm = value.toString();
                                    });
                                  })),
                          Expanded(
                              child: RadioListTile(
                                  title: Text('M',
                                      style: AppTextStyle.textBodyStyle()),
                                  value: 'M',
                                  contentPadding: EdgeInsets.all(0),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: _flagTm,
                                  onChanged: (value) {
                                    setState(() {
                                      _flagTm = value.toString();
                                    });
                                  })),
                        ],
                      ),
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
}
