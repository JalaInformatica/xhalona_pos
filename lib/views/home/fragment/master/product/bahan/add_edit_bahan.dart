import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/bahan.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/masterall.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  bool _isLoading = true;
  String? _product;
  String? _unit;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.kategori != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _nameBahanController.text = widget.kategori!.bomPartName;
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
                      buildTypeAheadFieldProduct("Kode Produk/Nama Produk",
                          controllerPro.productHeader, (value) {
                        setState(() {
                          _product = value;
                        });
                      }, controllerPro.updateFilterValue),
                      SizedBox(height: 16),

                      buildTypeAheadField("Unit", controllerMas.masAllHeader,
                          (value) {
                        setState(() {
                          _unit = value;
                        });
                      }, controllerMas.updateFilterValue),
                      SizedBox(height: 32),

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

  Widget buildTypeAheadFieldProduct(
    String label,
    List<ProductDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<ProductDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.partName.toLowerCase().contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: AppColor.primaryColor),
                hintText: 'Cari nama...',
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
          itemBuilder: (context, ProductDAO suggestion) {
            return ListTile(
              title: Text(suggestion.partName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (ProductDAO suggestion) {
            controller.text = suggestion.partName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.partId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }

  Widget buildTypeAheadField(
    String label,
    List<MasAllDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<MasAllDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.masDesc.toLowerCase().contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: AppColor.primaryColor),
                hintText: 'Cari nama...',
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
          itemBuilder: (context, MasAllDAO suggestion) {
            return ListTile(
              title: Text(suggestion.masDesc
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (MasAllDAO suggestion) {
            controller.text =
                suggestion.masDesc.toString(); // Tampilkan nama produk di field
            onChanged(suggestion.masterId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }
}
