import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kasbank.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/rekening.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
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
  String _jenisTrx = 'M';
  String? _finance;
  String? _kustomer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.finance != null) {
      // Inisialisasi data dari finance jika tersedia
      _noTrxController.text = widget.finance!.voucherNo;
      _ketController.text = widget.finance!.ket;
      _tanggalController.text = widget.finance!.voucherDate.split("T").first;
      _jmlBayarController.text = widget.finance!.jmlBayar.toString();
      _jenisTrx = widget.finance!.jenisAc;
      _kustomer = widget.finance!.refName;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<RekeningDAO> rekening = controllerKar.rekeningHeader;
    final List<KustomerDAO> kustomer = controllerKus.kustomerHeader;

    void handleAddEditFinance() async {
      if (_formKey.currentState!.validate()) {
        String result = await _financeRepository.addEditKasBank(
          acId: _finance,
          refID: _kustomer,
          subModulId: _jenisTrx,
          vocherDate: _tanggalController.text,
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

    void handlePrint() async {
      controllerFi.printLapFinance(_noTrxController.text).then((url) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  LapPenjualanViewerScreen(url, "Print Kas Bank")),
          (route) => false,
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
            "Finance",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
          actions: [
            widget.finance != null && widget.finance!.isApproved == false
                ? masterButton(() {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => AddEditKasBankDetail(
                                  noTrx: widget.finance!.voucherNo,
                                  ket: widget.finance!.ket,
                                  rowId: widget.finance!.rowId.toString(),
                                )),
                        (route) => false);
                  }, '', Icons.add)
                : SizedBox(),
            SizedBox(width: 5),
            masterButton(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MetodeBayarScreen()),
                  (route) => false);
            }, '', Icons.settings),
            SizedBox(width: 5),
            widget.finance != null
                ? masterButton(
                    handlePrint,
                    'Print',
                    Icons.print,
                  )
                : SizedBox(),
            SizedBox(width: 5),
          ],
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
                          "No Trx", "Masukkan no trx", _noTrxController,
                          isEnabled: widget.finance != null ? false : true),
                      SizedBox(height: 16),

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
                            onChanged: (value) {
                              _jenisTrx = value.toString();
                            },
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
                            onChanged: (value) {
                              _jenisTrx = value.toString();
                            },
                          )),
                        ],
                      ),
                      SizedBox(height: 16),

                      buildTypeAheadFieldAkun(
                        "Akun",
                        rekening,
                        (value) {
                          setState(() {
                            _finance = value;
                          });
                        },
                        controllerKar.updateFilterValue,
                        enabled: widget.finance != null &&
                                widget.finance!.isApproved == true
                            ? false
                            : true,
                      ),
                      SizedBox(height: 16),

                      Obx(() => AppTextFormField(
                            context: context,
                            textEditingController: _tanggalController,
                            readOnly: true,
                            icon: Icon(Icons.calendar_today),
                            onTap: () {
                              SmartDialog.show(builder: (context) {
                                return AppDialog(
                                    content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AppCalendar(
                                                focusedDay:
                                                    DateFormat("dd-MM-yyyy")
                                                        .parse(
                                                            _tanggalController
                                                                .text),
                                                onDaySelected:
                                                    (selectedDay, _) {
                                                  _tanggalController.text =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(selectedDay);
                                                  SmartDialog.dismiss();
                                                },
                                              ),
                                            ])));
                              });
                            },
                            labelText: "Tanggal",
                            style: AppTextStyle.textBodyStyle(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal Sampai tidak boleh kosong';
                              }
                              return null;
                            },
                          )),
                      SizedBox(height: 16),

                      buildTypeAheadFieldRef(
                          "${_jenisTrx == 'M' ? 'Diterima dari' : 'Keluar ke'} ",
                          kustomer, (value) {
                        setState(() {
                          _kustomer = value;
                        });
                      }, controllerKus.updateFilterValue),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField(
                        "Keterangan",
                        "Masukkan keterangan",
                        _ketController,
                        isEnabled: widget.finance != null &&
                                widget.finance!.isApproved == true
                            ? false
                            : true,
                      ),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
                      buildTextField("Jumlah Bayar", "Masukkan jumlah bayar",
                          _jmlBayarController,
                          isEnabled: widget.finance != null ? false : true),
                      SizedBox(height: 32),

                      // Action Buttons
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          masterButton(
                              handleAddEditFinance, "Simpan", Icons.add),
                          masterButton(
                            handleuPost,
                            widget.finance != null &&
                                    widget.finance!.isApproved == true
                                ? 'UnPost'
                                : 'Post',
                            Icons.post_add,
                          ),
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

  Widget buildTypeAheadFieldAkun(
    String label,
    List<RekeningDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue, {
    bool enabled = true,
  }) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        AbsorbPointer(
          // Membuat field tidak interaktif saat disabled
          absorbing: !enabled,
          child: TypeAheadField<RekeningDAO>(
            suggestionsCallback: (pattern) async {
              if (!enabled) return []; // Tidak ada saran jika disabled
              updateFilterValue(pattern);
              return items
                  .where((item) => item.bankAcName!
                      .toLowerCase()
                      .contains(pattern.toLowerCase()))
                  .toList();
            },
            builder: (context, textEditingController, focusNode) {
              controller = textEditingController;

              return TextField(
                controller: controller,
                focusNode: focusNode,
                enabled:
                    enabled, // Mengatur apakah field bisa diketik atau tidak
                decoration: InputDecoration(
                  labelText: label,
                  hintText: 'Cari akun...',
                  labelStyle: TextStyle(color: AppColor.primaryColor),
                  hintStyle: TextStyle(color: AppColor.primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primaryColor),
                  ),
                ),
                onChanged: (value) {
                  // Biarkan kosong, hanya proses saat dipilih
                },
              );
            },
            itemBuilder: (context, RekeningDAO suggestion) {
              return ListTile(
                title: Text(suggestion.bankAcName.toString()),
              );
            },
            onSelected: (RekeningDAO suggestion) {
              controller.text = suggestion.bankAcName.toString();
              onChanged(suggestion.acId);
            },
          ),
        ),
      ],
    );
  }

  Widget buildTypeAheadFieldRef(
    String label,
    List<KustomerDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<KustomerDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) => item.suplierName
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                hintText: 'Cari nama...',
                labelStyle: TextStyle(color: AppColor.primaryColor),
                hintStyle: TextStyle(color: AppColor.primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColor.primaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
              ),
              onChanged: (value) {
                // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
              },
            );
          },
          itemBuilder: (context, KustomerDAO suggestion) {
            return ListTile(
              title: Text(suggestion.suplierName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KustomerDAO suggestion) {
            controller.text = suggestion.suplierName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.suplierId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }
}
