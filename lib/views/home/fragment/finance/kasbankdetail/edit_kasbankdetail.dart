import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/models/dao/kasbankdetail.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';
import 'package:xhalona_pos/repositories/kasbank/kasbankdetail_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_controller.dart';

// ignore: must_be_immutable
class AddEditKasBankDetail extends StatefulWidget {
  String? noTrx;
  String? ket;
  String? rowId;
  KasBankDetailDAO? kasbankdetail;
  AddEditKasBankDetail(
      {super.key, this.kasbankdetail, this.noTrx, this.ket, this.rowId});

  @override
  _AddEditKasBankDetailState createState() => _AddEditKasBankDetailState();
}

class _AddEditKasBankDetailState extends State<AddEditKasBankDetail> {
  KasBankDetailRepository _kasbankdetailRepository = KasBankDetailRepository();
  final CoaController controllerKus = Get.put(CoaController());
  final FinanceController controllerFi = Get.put(FinanceController());

  final _formKey = GlobalKey<FormState>();
  final _noTrxController = TextEditingController();
  final _ketController = TextEditingController();
  final _hargaController = TextEditingController();
  final _qtyController = TextEditingController();
  final _kasbankdetailController = TextEditingController();
  String? _flagDK;
  String? _kasbankdetail;
  bool _isLoading = true;

  final List<String> flagDK = ['D', 'K'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.noTrx != null) _noTrxController.text = widget.noTrx!;
    if (widget.kasbankdetail != null) {
      _noTrxController.text = widget.kasbankdetail!.detVoucherNo;
      _ketController.text = widget.kasbankdetail!.uraianDet;
      _hargaController.text = widget.kasbankdetail!.priceUnit.toString();
      _qtyController.text = widget.kasbankdetail!.qty.toString();
      _flagDK = widget.kasbankdetail!.flagDK;
    } else {
      _hargaController.text = '';
      _qtyController.text = '';
      _flagDK = '';
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<CoaDAO> coa = controllerKus.coaHeader;

    void handleAddEditKasBankDetail() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kasbankdetailRepository.addEditKasBankDetail(
          acId: _kasbankdetail,
          qty: _qtyController.text,
          priceUnit: parseRupiah(_hargaController.text).toString(),
          flagDk: _flagDK,
          voucerNo: _noTrxController.text,
          uraianDet: _ketController.text,
          rowId: widget.rowId,
          actionId: widget.kasbankdetail == null ? "0" : "1",
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
          controllerFi.fetchProducts();
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
            "Kas Bank Detail ${widget.noTrx}",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.whiteColor,
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
                                    _kasbankdetailController.text =
                                        selectedPartId ?? "";
                                    controllerKus.fetchProducts();
                                  });
                                },
                                controller: _kasbankdetailController,
                                updateFilterValue: (newValue) async {
                                  await controllerKus.updateTypeValue(newValue);
                                  return controllerKus.coaHeader;
                                },
                                displayText: (akun) => akun.namaRekening,
                                getId: (akun) => akun.acId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _kasbankdetailController.text !=
                                          _kasbankdetail) {}
                                }),
                          )),
                      SizedBox(height: 16),

                      Text(
                        'Jenis Trx',
                        style: AppTextStyle.textBodyStyle(),
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                            title: Text('Debit',
                                style: AppTextStyle.textBodyStyle()),
                            value: 'D',
                            contentPadding: EdgeInsets.all(0),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            groupValue: _flagDK,
                            onChanged: (value) {
                              setState(() {
                                _flagDK = value.toString();
                              });
                            },
                          )),
                          Expanded(
                              child: RadioListTile(
                            title: Text('Kredit',
                                style: AppTextStyle.textBodyStyle()),
                            value: 'K',
                            contentPadding: EdgeInsets.all(0),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            groupValue: _flagDK,
                            onChanged: (value) {
                              setState(() {
                                _flagDK = value.toString();
                              });
                            },
                          )),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _hargaController,
                        validator: (value) {
                          if (value == '') {
                            return "Jumlah Bayar harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Jumlah Bayar",
                        inputAction: TextInputAction.next,
                        inputFormatters: [CurrencyInputFormatter()],
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),

                      // Field Nama

                      AppTextFormField(
                        context: context,
                        textEditingController: _qtyController,
                        validator: (value) {
                          if (value == '') {
                            return "Qty harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Qty",
                        inputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
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
                      ),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditKasBankDetail, "Simpan", Icons.add),
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
