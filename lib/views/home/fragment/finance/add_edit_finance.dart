import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kasbank.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/rekening.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/kasbank/kasbank_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/rekening_controller.dart';
import 'package:xhalona_pos/views/home/fragment/finance/metodebayar/metodebayar_screen.dart';
import 'package:xhalona_pos/views/home/fragment/finance/kasbankdetail/edit_kasbankdetail.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_viewer_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';

// ignore: must_be_immutable
class AddEditFinance extends StatefulWidget {
  KasBankDAO? finance;
  AddEditFinance({super.key, this.finance});

  @override
  _AddEditFinanceState createState() => _AddEditFinanceState();
}

class _AddEditFinanceState extends State<AddEditFinance> {
  KasBankRepository _financeRepository = KasBankRepository();
  final RekeningController controllerKar = Get.put(RekeningController());
  final FinanceController controllerFi = Get.put(FinanceController());
  final KustomerController controllerKus = Get.put(KustomerController());

  final _formKey = GlobalKey<FormState>();
  final _noTrxController = TextEditingController();
  final _ketController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jmlBayarController = TextEditingController();
  final _financeController = TextEditingController();
  final _kustomerController = TextEditingController();
  String _jenisTrx = 'M';
  String? _finance;
  String? _kustomer;
  bool _isLoading = true;
  bool _isRadioEnabled = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
      if (widget.finance != null) {
        // Inisialisasi data dari finance jika tersedia
        _noTrxController.text = widget.finance!.voucherNo;
        _ketController.text = widget.finance!.ket;
        _tanggalController.text = DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(widget.finance!.voucherDate));
        _jmlBayarController.text = widget.finance!.jmlBayar.toString();
        _financeController.text = widget.finance!.acId;
        _finance = widget.finance!.acId;
        _kustomerController.text = widget.finance!.refName;
        _kustomer = widget.finance!.refName;
        _isRadioEnabled = widget.finance!.isApproved == false ? true : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditFinance() async {
      if (_formKey.currentState!.validate()) {
        String result = await _financeRepository.addEditKasBank(
          acId: _finance,
          refID: _kustomer,
          subModulId: _jenisTrx,
          vocherDate: DateFormat('yyyy-MM-dd').format(
            DateFormat('dd-MM-yyyy').parse(_tanggalController.text),
          ),
          vocherNo: _noTrxController.text,
          ket: _ketController.text,
          actionId: widget.finance == null ? "0" : "1",
        );

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          controllerFi.fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
      }
    }

    void handlePrint() async {
      controllerFi.printLapFinance(_noTrxController.text).then((url) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  LapPenjualanViewerScreen(url, "Print Kas Bank")),
        );
      });
    }

    void handleuPost() async {
      String? result;
      if (widget.finance!.isApproved == false) {
        result = await _financeRepository.postingKasBank(
            voucherNo: _noTrxController.text);
      } else {
        result = await _financeRepository.unpostingKasBank(
            voucherNo: _noTrxController.text);
      }

      bool isSuccess = result == "1";
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data gagal disimpan!')),
        );
        setState(() {});
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        controllerFi.fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan!')),
        );
      }
    }

    return SafeArea(child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              color: AppColor.primaryColor,
              child: Row(
              children: [
                AppIconButton(
                  foregroundColor: AppColor.whiteColor,
                    onPressed: (){
                    Navigator.of(context).pop();
                  }, 
                  icon: Icon(Icons.arrow_back)
                ),
                Text(
                  "Catatan Keuangan",
                  style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor),
                ),
                Spacer(),
                widget.finance != null
                    ? masterButton(
                        handlePrint,
                        'Print',
                        Icons.print,
                      )
                : SizedBox(),
          ],)),
            _isLoading ? buildShimmerLoading()
            : Expanded(child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 10.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IntrinsicWidth(
                          child: AppElevatedButton(
                            foregroundColor: AppColor.primaryColor,
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => MetodeBayarScreen()));
                            },
                            icon: Icons.settings, 
                            child: Text("Metode Bayar")
                          ),
                        )
                      ),       
                      // Field NIK
                      if(widget.finance!=null)
                      AppTextFormField(
                        context: context,
                        textEditingController: _noTrxController,
                        validator: (value) {
                          if (value == '') {
                            return "No Trx harus diisi!";
                          }
                          return null;
                        },
                        labelText: "No Trx",
                        inputAction: TextInputAction.next,
                        readOnly: true,
                      ),
                      Text(
                        'Jenis Trx',
                        style: AppTextStyle.textBodyStyle(),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                            title: Text('Masuk',
                                style: AppTextStyle.textBodyStyle()),
                            value: 'M',
                            contentPadding: EdgeInsets.all(0),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            groupValue: _jenisTrx,
                            onChanged: _isRadioEnabled
                                ? (value) {
                                    setState(() {
                                      _jenisTrx = value.toString();
                                    });
                                  }
                                : null,
                          )),
                          Expanded(
                              child: RadioListTile(
                            title: Text('Keluar',
                                style: AppTextStyle.textBodyStyle()),
                            value: 'K',
                            contentPadding: EdgeInsets.all(0),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            groupValue: _jenisTrx,
                            onChanged: _isRadioEnabled
                                ? (value) {
                                    setState(() {
                                      _jenisTrx = value.toString();
                                    });
                                  }
                                : null,
                          )),
                        ],
                      ),
                      Visibility(
                          visible: true,
                          child: AppTypeahead<RekeningDAO>(
                                label: "Akun",
                                controller: _financeController,
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _finance = selectedPartId ?? "";
                                    _financeController.text =
                                        selectedPartId ?? "";
                                    controllerKar.fetchProducts();
                                  });
                                },
                                updateFilterValue: (newValue) async {
                                  await controllerKar.updateTypeValue(newValue);
                                  return controllerKar.rekeningHeader;
                                },
                                displayText: (akun) => akun.namaAc,
                                getId: (akun) => akun.acId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _financeController.text != _finance) {}
                                }),
                          ),

                      // buildTypeAheadFieldAkun(
                      //   "Akun",
                      //   rekening,
                      //   (value) {
                      //     setState(() {
                      //       _finance = value;
                      //     });
                      //   },
                      //   controllerKar.updateFilterValue,
                      //   enabled: widget.finance != null &&
                      //           widget.finance!.isApproved == true
                      //       ? false
                      //       : true,
                      // ),
                      AppTextFormField(
                        context: context,
                        textEditingController: _tanggalController..text=DateFormat('dd-MM-yyyy')
                                                        .format(DateTime.now()),
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
                                            focusedDay: _tanggalController
                                                    .text.isNotEmpty
                                                ? DateFormat("dd-MM-yyyy")
                                                    .parse(
                                                        _tanggalController.text)
                                                : DateTime.now(),
                                            onDaySelected: (selectedDay, _) {
                                              setState(() {
                                                _tanggalController.text =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDay);
                                                SmartDialog.dismiss();
                                              });
                                            },
                                          ),
                                        ])));
                          });
                        },
                        labelText: "Tanggal",
                        style: AppTextStyle.textBodyStyle(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal Sampai tidak boleh kosong Trying to read dd from  at 0';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                          visible: true,
                          child: AppTypeahead<KustomerDAO>(
                                label:
                                    "${_jenisTrx == 'M' ? 'Diterima dari' : 'Keluar ke'} ",
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _kustomer = selectedPartId ?? "";
                                    _kustomerController.text =
                                        selectedPartId ?? "";
                                    controllerKus.fetchProducts();
                                  });
                                },
                                controller: _kustomerController,
                                updateFilterValue: (newValue) async {
                                  await controllerKus.updateTypeValue(newValue);
                                  return controllerKus.kustomerHeader;
                                },
                                displayText: (akun) => akun.suplierName,
                                getId: (akun) => akun.suplierId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _kustomerController.text != _kustomer) {}
                                }),
                          ),

                      // buildTypeAheadFieldRef(
                      //     "${_jenisTrx == 'M' ? 'Diterima dari' : 'Keluar ke'} ",
                      //     kustomer, (value) {
                      //   setState(() {
                      //     _kustomer = value;
                      //   });
                      // }, controllerKus.updateFilterValue),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _ketController,
                        validator: (value) {
                          if (value == '') {
                            return "Keterangan harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Keterangan",
                        inputAction: TextInputAction.next,
                        readOnly: widget.finance != null &&
                                widget.finance!.isApproved == true
                            ? true
                            : false,
                      ),
                      // Field BPJS Kesehatan
                      AppTextFormField(
                        context: context,
                        textEditingController: _jmlBayarController,
                        validator: (value) {
                          if (value == '') {
                            return "Jumlah Bayar harus diisi!";
                          }
                          return null;
                        },
                        hintText: "Jumlah Bayar",
                        inputAction: TextInputAction.next,
                        disabled: true,
                      ),

                      // Action Buttons
                      Row(
                        spacing: 4,
                        children: [
                          Expanded(child: AppElevatedButton(
                             onPressed: handleAddEditFinance,
                             backgroundColor: AppColor.primaryColor,
                             foregroundColor: AppColor.whiteColor,
                             icon: Icons.add, 
                             child: Text("Simpan", style: AppTextStyle.textSubtitleStyle(),)),),
                          Expanded(child: AppElevatedButton(
                            onPressed: handleuPost,
                            icon: Icons.post_add,
                            backgroundColor: widget.finance != null && widget.finance!.isApproved? AppColor.primaryColor : AppColor.purpleColor,
                            foregroundColor: AppColor.whiteColor,
                            borderColor: AppColor.transparentColor,
                            child: widget.finance != null &&
                                    widget.finance!.isApproved == true
                                ? Text('UnPost', style: AppTextStyle.textSubtitleStyle(),)
                                : Text('Post', style: AppTextStyle.textSubtitleStyle()),))
                        ],
                      ),
                    ],
                  ),
                ),
              )),
    ])));
  }
}
