import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/bahan.dart';
import 'package:xhalona_pos/globals/product/models/product.dart';
import 'package:xhalona_pos/models/response/masterall.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/bahan/bahan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/mAll_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/bahan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/master_bahan_screen.dart';

// ignore: must_be_immutable
class AddEditBahan extends StatefulWidget {
  BahanDAO? kategori;
  String? partId;
  AddEditBahan({super.key, this.kategori, this.partId});

  @override
  _AddEditBahanState createState() => _AddEditBahanState();
}

class _AddEditBahanState extends State<AddEditBahan> {
  BahanRepository _kategoriRepository = BahanRepository();
  final BahanController controller = Get.put(BahanController());
  final ProductController controllerPro = Get.put(ProductController());
  final MasAllController controllerMas = Get.put(MasAllController());

  final _formKey = GlobalKey<FormState>();
  final _nameBahanController = TextEditingController();
  final _productController = TextEditingController();
  final _unitController = TextEditingController();
  bool _isLoading = true;
  String? _product;
  String? _unit;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.kategori != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _productController.text = widget.kategori!.partId;
      _nameBahanController.text = widget.kategori!.bomPartName;
      _unitController.text = widget.kategori!.unitId;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditBahan() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kategoriRepository.addEditBahan(
            rowId: widget.kategori?.rowId.toString(),
            bomPartId: _product,
            partId: widget.partId,
            unitId: _unit,
            actionId: widget.kategori == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterBahanScreen()),
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
            MaterialPageRoute(builder: (context) => MasterBahanScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Bahan",
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
                      // Field Nama
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

                      Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: AppTypeahead<MasAllDAO>(
                                label: "Unit",
                                controller: _unitController,
                                onSelected: (selectedPartId) {
                                  setState(() {
                                    _unit = selectedPartId ?? "";
                                    _unitController.text = selectedPartId ?? "";
                                    controllerMas.fetchProducts();
                                  });
                                },
                                updateFilterValue: (newValue) async {
                                  await controllerMas.updateTypeValue(newValue);
                                  return controllerMas.masAllHeader;
                                },
                                displayText: (akun) => akun.masDesc,
                                getId: (akun) => akun.masterId,
                                onClear: (forceClear) {
                                  if (forceClear ||
                                      _unitController.text != _unit) {}
                                }),
                          )),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(handleAddEditBahan, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MasterBahanScreen()),
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
