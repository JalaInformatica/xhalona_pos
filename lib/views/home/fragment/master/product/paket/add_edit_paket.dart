import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/paket.dart';
import 'package:xhalona_pos/globals/product/models/product.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/paket_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/paket_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/master_paket_screen.dart';

// ignore: must_be_immutable
class AddEditPaket extends StatefulWidget {
  PaketDAO? paket;
  String? partId;
  AddEditPaket({super.key, this.paket, this.partId});

  @override
  _AddEditPaketState createState() => _AddEditPaketState();
}

class _AddEditPaketState extends State<AddEditPaket> {
  PaketRepository _paketRepository = PaketRepository();
  final PaketController controller = Get.put(PaketController());
  final ProductController controllerPro = Get.put(ProductController());

  final _formKey = GlobalKey<FormState>();
  final _hargaController = TextEditingController();
  final _qtyController = TextEditingController();
  final _productController = TextEditingController();
  bool _isLoading = true;
  String? _product;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.paket != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _productController.text = widget.paket!.partId;
      _hargaController.text = widget.paket!.comUnitPrice.toString();
      _qtyController.text = widget.paket!.comValue.toString();
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditPaket() async {
      if (_formKey.currentState!.validate()) {
        String result = await _paketRepository.addEditPaket(
            comUnitPrice: parseRupiah(_hargaController.text).toString(),
            comValue: _qtyController.text,
            comPartId: _product,
            partId: widget.partId,
            actionId: widget.paket == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterPaketScreen()),
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
            MaterialPageRoute(builder: (context) => MasterPaketScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Paket",
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
                            child: AppTypeahead<ProductDAO>(
                                label: "Kode Produk/Nama Produk",
                                controller: _productController,
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _product = selectedPartId ?? "";
                                    _productController.text =
                                        selectedPartId ?? "";
                                    controllerPro.fetchProducts();
                                  });
                                },
                                updateFilterValue: (newValue) async {
                                  await controllerPro.updateTypeValue(newValue);
                                  return controllerPro.productHeader;
                                },
                                displayText: (akun) => akun.partName,
                                getId: (akun) => akun.partId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _productController.text != _product) {}
                                }),
                          )),
                      SizedBox(height: 16),

                      // Field Nama
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
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
                            ),
                          ),
                          SizedBox(width: 16),

                          // Field Nama
                          Expanded(
                            child: AppTextFormField(
                                context: context,
                                textEditingController: _hargaController,
                                validator: (value) {
                                  if (value == '') {
                                    return "Harga harus diisi!";
                                  }
                                  return null;
                                },
                                labelText: "Harga",
                                inputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [CurrencyInputFormatter()]),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(handleAddEditPaket, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MasterPaketScreen()),
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
