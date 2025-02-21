import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/models/dao/kasbankdetail.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
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
  String? _flagDK;
  String? _kasbankdetail;
  bool _isLoading = true;

  final List<String> flagDK = ['D', 'K'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();

    _noTrxController.text = widget.noTrx!;
    _ketController.text = widget.ket!;

    if (widget.kasbankdetail != null) {
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
                          "No Trx", "Masukkan no trx", _noTrxController,
                          isEnabled: false),
                      SizedBox(height: 16),

                      buildTypeAheadFieldAkun(
                        "Coa",
                        coa,
                        (value) {
                          setState(() {
                            _kasbankdetail = value;
                          });
                        },
                        controllerKus.updateFilterValue,
                      ),
                      SizedBox(height: 16),

                      buildDropdownFieldJK(
                        "Jenis Trx",
                        flagDK,
                        (value) {
                          setState(() {
                            _flagDK = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField(
                          "Harga", "Masukkan harga", _hargaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CurrencyInputFormatter()]),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField(
                        "Qty",
                        "Masukkan qty",
                        _qtyController,
                      ),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
                      buildTextField(
                        "Keterangan",
                        "Masukkan keterangan",
                        _ketController,
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

  Widget buildTypeAheadFieldAkun(
    String label,
    List<CoaDAO> items,
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
          child: TypeAheadField<CoaDAO>(
            suggestionsCallback: (pattern) async {
              if (!enabled) return []; // Tidak ada saran jika disabled
              updateFilterValue(pattern);
              return items
                  .where((item) => item.namaRekening
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
                  hintText: enabled ? "Cari akun..." : "Input dinonaktifkan",
                ),
                onChanged: (value) {
                  // Biarkan kosong, hanya proses saat dipilih
                },
              );
            },
            itemBuilder: (context, CoaDAO suggestion) {
              return ListTile(
                title: Text(suggestion.namaRekening.toString()),
              );
            },
            onSelected: (CoaDAO suggestion) {
              controller.text = suggestion.namaRekening.toString();
              onChanged(suggestion.acId);
            },
          ),
        ),
      ],
    );
  }
}
