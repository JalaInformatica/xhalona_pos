import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/models/dao/kasbankdetail.dart';
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
  String? _coa;
  bool _isLoading = true;

  final List<String> flagDK = ['D', 'K'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();

    _noTrxController.text = widget.noTrx ?? '';
    _ketController.text = widget.ket ?? '';

    if (widget.kasbankdetail != null) {
      _hargaController.text = widget.kasbankdetail!.priceUnit.toString();
      _qtyController.text = widget.kasbankdetail!.qty.toString();
      _flagDK = widget.kasbankdetail!.flagDK ?? '';
      _coa = widget.kasbankdetail!.acId ?? '';
    } else {
      _hargaController.text = '';
      _qtyController.text = '';
      _flagDK = '';
      _coa = '';
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
          priceUnit: _hargaController.text,
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
                        "Harga",
                        "Masukkan harga",
                        _hargaController,
                      ),
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

  Widget masterButton(VoidCallback onTap, String label, IconData icon,
      {Color color = AppColor.primaryColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: color, // Background color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(label,
                style: AppTextStyle.textTitleStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isEnabled = true, // Tambahkan parameter ini
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: isEnabled, // Atur properti enabled berdasarkan parameter
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 16,
            margin: EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
          ),
        );
      },
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
                  border: OutlineInputBorder(),
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

  Widget buildDropdownFieldJK(
      String label, List<String> items, ValueChanged<String?> onChanged,
      {bool enabled = true}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: enabled ? onChanged : null, // Disable onChanged if not enabled
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
      disabledHint: Text('Pilih $label'), // Optional: hint when disabled
    );
  }
}
