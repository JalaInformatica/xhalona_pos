import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/bahan.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/masterall.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
      _nameBahanController.text = widget.kategori!.bomPartName ?? '';
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

  Widget masterButton(VoidCallback onPressed, String label, IconData icon) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor, // Background color
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
        TypeAheadField<String>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.partName.toLowerCase().contains(pattern.toLowerCase()))
                .map((item) => item.partName)
                .toList();
          },
          builder: (context, textEditingController, focusNode) {
            // Set nilai controller dari textEditingController yang diberikan oleh TypeAheadField
            controller = textEditingController;

            return TextField(
              controller: controller, // Gunakan controller yang tetap
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Cari produk...",
              ),
              onChanged: onChanged, // Callback saat teks berubah
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSelected: (suggestion) {
            controller.text =
                suggestion; // Perbarui teks dengan pilihan pengguna
            onChanged(suggestion); // Kirim perubahan ke callback
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
        TypeAheadField<String>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.masDesc.toLowerCase().contains(pattern.toLowerCase()))
                .map((item) => item.masDesc)
                .toList();
          },
          builder: (context, textEditingController, focusNode) {
            // Set nilai controller dari textEditingController yang diberikan oleh TypeAheadField
            controller = textEditingController;

            return TextField(
              controller: controller, // Gunakan controller yang tetap
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: " Unit...",
              ),
              onChanged: onChanged, // Callback saat teks berubah
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSelected: (suggestion) {
            controller.text =
                suggestion; // Perbarui teks dengan pilihan pengguna
            onChanged(suggestion); // Kirim perubahan ke callback
          },
        ),
      ],
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
}
